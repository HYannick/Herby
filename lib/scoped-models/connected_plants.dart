import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:herby_app/models/plant.dart';
import 'package:herby_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/subjects.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

dynamic customEncode(dynamic item) {
  if (item is DateTime) {
    return item.toIso8601String();
  }
  return item;
}

mixin ConnectedPlantsModel on Model {
  List<Plant> _plants = [];
  User _authenticatedUser;
  File _imageURL;
  List<CameraDescription> _cameras;
  bool _isLoading = false;
  String _selectedPlantId;

  String get selectedPlantId => _selectedPlantId;

  File get imageURL => _imageURL;

  List<CameraDescription> get cameras => _cameras;

  int get selectedPlantIndex =>
      _plants.indexWhere((Plant plant) => plant.id == _selectedPlantId);

  void pickImage(File image) {
    _imageURL = image;
    notifyListeners();
  }

  void resetImage() {
    _imageURL = null;
  }

  void getCameras(List<CameraDescription> cams) {
    _cameras = cams;
  }

  Plant get selectedPlant {
    if (_selectedPlantId == null) {
      return null;
    }

    return _plants.firstWhere((Plant plant) => plant.id == _selectedPlantId,
        orElse: null);
  }

  Future<bool> addPlant(Map<String, dynamic> plantForm) {
    _isLoading = true;
    notifyListeners();

    Map<String, dynamic> userId = {'userId': _authenticatedUser.id};
    plantForm.addAll(userId);

    return http
        .post(
            'https://herby-47c7c.firebaseio.com/plants.json?auth=${_authenticatedUser.token}',
            body: json.encode(plantForm, toEncodable: customEncode))
        .then((http.Response res) {
      final Map<String, dynamic> responseData = json.decode(res.body);
      final Plant plant = Plant(
          id: responseData['name'],
          frequency: plantForm['frequency'],
          imgURL: plantForm['imgURL'],
          lastWatering: plantForm['lastWatering'],
          daysLeft: plantForm['daysLeft'],
          description: plantForm['description'],
          name: plantForm['name'],
          userId: _authenticatedUser.id);
      _plants.add(plant);
      _isLoading = false;
      notifyListeners();
      return true;
    }).catchError((error) {
      _isLoading = false;
      notifyListeners();
      return false;
    });
  }
}

mixin UsersModel on ConnectedPlantsModel {
  Timer _authTimer;
  PublishSubject<bool> _userSubject = PublishSubject();

  User get user => _authenticatedUser;

  PublishSubject<bool> get userSubject => _userSubject;

  Future<Map<String, dynamic>> authenticate(
      String email, String password, bool registerMode) async {
    _isLoading = true;
    notifyListeners();

    final Map<String, dynamic> userInfos = {
      'email': email,
      'password': password,
      'returnSecureToken': true
    };

    http.Response res;

    if (registerMode) {
      res = await http.post(
          'https://www.googleapis'
          '.com/identitytoolkit/v3/relyingparty/signupNewUser?key=AIzaSyBuiIHY'
          '-DL_6B2KtqlkvDGfENqpPvfbM10',
          body: jsonEncode(userInfos),
          headers: {'Content-Type': 'application/json'});
    } else {
      res = await http.post(
          'https://www.googleapis.com/identitytoolkit/v3/relyingparty/verifyPassword?key=AIzaSyBuiIHY-DL_6B2KtqlkvDGfENqpPvfbM10',
          body: jsonEncode(userInfos),
          headers: {'Content-Type': 'application/json'});
    }

    final Map<String, dynamic> resData = jsonDecode(res.body);
    bool hasError = true;
    String message = 'Something went wrong :(';

    if (resData.containsKey('idToken')) {
      hasError = false;
      message = 'Authentication succeded';
      _authenticatedUser =
          User(id: resData['localId'], email: email, token: resData['idToken']);
      setAuthTimeout(int.parse(resData['expiresIn']));
      _userSubject.add(true);
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final DateTime now = DateTime.now();
      final DateTime expiryTime =
          now.add(Duration(seconds: int.parse(resData['expiresIn'])));
      prefs.setString('token', resData['idToken']);
      prefs.setString('userId', resData['localId']);
      prefs.setString('userEmail', email);
      prefs.setString('expiryTime', expiryTime.toIso8601String());
    } else if (resData['error']['message'] == 'EMAIL_NOT_FOUND') {
      hasError = true;
      message = 'This email was not found.';
    } else if (resData['error']['message'] == 'INVALID_PASSWORD') {
      hasError = true;
      message = 'The password is invalid';
    } else if (resData['error']['message'] == 'EMAIL_EXISTS') {
      hasError = true;
      message = 'This email already exists.';
    }

    _isLoading = false;
    notifyListeners();
    return {'success': !hasError, 'message': message};
  }

  void logout() async {
    _authenticatedUser = null;
    _authTimer.cancel();
    _userSubject.add(false);
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    prefs.remove('userEmail');
    prefs.remove('userId');
  }

  void setAuthTimeout(int time) {
    _authTimer = Timer(Duration(seconds: time), logout);
  }

  void autoAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');
    final String expiryTimeString = prefs.getString('expiryTime');

    if (token != null) {
      final DateTime now = DateTime.now();
      final parsedExpiryTime = DateTime.parse(expiryTimeString);

      if (parsedExpiryTime.isBefore(now)) {
        _authenticatedUser = null;
        _userSubject.add(false);
        notifyListeners();
        return;
      }

      final String userID = prefs.getString('userId');
      final String userEmail = prefs.getString('userEmail');
      final int tokenLifeSpan = parsedExpiryTime.difference(now).inSeconds;
      _authenticatedUser = User(id: userID, email: userEmail, token: token);
      _userSubject.add(true);
      setAuthTimeout(tokenLifeSpan);
      notifyListeners();
    }
  }
}

mixin PlantsModel on ConnectedPlantsModel {
  List<Plant> get allPlants => List.from(_plants);

  void selectPlant(String plantId) {
    _selectedPlantId = plantId;
  }

  List<Plant> get getNonWateredPlants =>
      _plants.where((Plant plant) => plant.daysLeft <= 2).toList();

  int getNextWatering({DateTime lastWatering, int frequency}) {
    DateTime nextWatering = lastWatering.add(Duration(days: frequency));
    int daysLeft = nextWatering.difference(DateTime.now()).inDays;
    int remainingDays = daysLeft > 0 ? daysLeft : 0;
    return remainingDays;
  }

  bool needWatering({DateTime lastWatering, int frequency}) {
    DateTime now = DateTime.now();
    int safeDays = 4;
    print(now.difference(lastWatering).inDays);
    print(frequency - safeDays);
    return now.difference(lastWatering).inDays > frequency - safeDays;
  }

  Future<bool> deletePlant(Plant plant) async {
    _isLoading = true;
    selectPlant(plant.id);
    notifyListeners();
    try {
      await http.delete(
          'https://herby-47c7c.firebaseio.com/plants/${plant.id}.json?auth=${_authenticatedUser.token}');
      _plants.removeAt(selectedPlantIndex);
      _isLoading = false;
      _selectedPlantId = null;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> editPlant(Map<String, dynamic> plantObj) async {
    _isLoading = true;
    notifyListeners();
    try {
      await http.put(
          'https://herby-47c7c.firebaseio.com/plants/$selectedPlantId.json?auth=${_authenticatedUser.token}',
          body: json.encode(plantObj, toEncodable: customEncode));
      final Plant plant = Plant(
        id: plantObj['id'],
        imgURL: plantObj['imgURL'],
        name: plantObj['name'],
        lastWatering: plantObj['lastWatering'],
        frequency: plantObj['frequency'],
        daysLeft: plantObj['daysLeft'],
        userId: plantObj['userId'],
        description: plantObj['description'],
      );
      _plants[selectedPlantIndex] = plant;
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<Null> fetchPlants() async {
    _isLoading = true;
    notifyListeners();
    try {
      final http.Response res = await http.get(
          'https://herby-47c7c.firebaseio.com/plants.json?auth=${_authenticatedUser.token}');

      final List<Plant> fetchedPlantsList = [];
      final Map<String, dynamic> plants = json.decode(res.body);

      if (plants == null) {
        _isLoading = false;
        notifyListeners();
        return null;
      }

      plants.forEach((String plantId, dynamic plantData) {
        final Plant plant = Plant(
          id: plantId,
          imgURL: plantData['imgURL'],
          name: plantData['name'],
          lastWatering: DateTime.parse(plantData['lastWatering']),
          frequency: plantData['frequency'],
          daysLeft: getNextWatering(
              lastWatering: DateTime.parse(plantData['lastWatering']),
              frequency: plantData['frequency']),
          userId: plantData['userId'],
          description: plantData['description'],
        );
        fetchedPlantsList.add(plant);
      });

      _plants = fetchedPlantsList;
      _plants.sort((a, b) {
        return a.daysLeft.compareTo(b.daysLeft);
      });
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return null;
    }
  }
}

mixin UtilityModel on ConnectedPlantsModel {
  bool get isLoading => _isLoading;
}
