import 'dart:async';
import 'dart:convert';

import 'package:herby_app/models/plant.dart';
import 'package:herby_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

mixin ConnectedPlantsModel on Model {
  List<Plant> _plants = [];
  User _authenticatedUser;
  bool _isLoading = false;
  String _selectedPlantId;

  String get selectedPlantId => _selectedPlantId;

  int get selectedPlantIndex =>
      _plants.indexWhere((Plant plant) => plant.id == _selectedPlantId);

  Plant get selectedPlant {
    if (_selectedPlantId == null) {
      return null;
    }

    print(_plants);
    print(_selectedPlantId);
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
  User get user {
    return _authenticatedUser;
  }

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
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('token', resData['idToken']);
      prefs.setString('userId', resData['localId']);
      prefs.setString('userEmail', email);
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

  void autoAuth() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token');

    if (token != null) {
      final String userID = prefs.getString('userId');
      final String userEmail = prefs.getString('userEmail');
      _authenticatedUser = User(id: userID, email: userEmail, token: token);
      notifyListeners();
    }
  }
}

dynamic customEncode(dynamic item) {
  if (item is DateTime) {
    return item.toIso8601String();
  }
  return item;
}

mixin PlantsModel on ConnectedPlantsModel {
  List<Plant> get allPlants => List.from(_plants);

  void selectPlant(String plantId) {
    _selectedPlantId = plantId;
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
          daysLeft: plantData['daysLeft'],
          userId: plantData['userId'],
          description: plantData['description'],
        );
        fetchedPlantsList.add(plant);
      });
      _plants = fetchedPlantsList;
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
