import 'dart:async';
import 'dart:convert';

import 'package:herby_app/models/plant.dart';
import 'package:herby_app/models/user.dart';
import 'package:http/http.dart' as http;
import 'package:scoped_model/scoped_model.dart';

mixin UsersModel on ConnectedPlantsModel {
  void login(String email, String password) {
    _authenticatedUser =
        User(id: 'daoeufnemzvz3', email: email, password: password);
  }
}

mixin PlantsModel on ConnectedPlantsModel {
  List<Plant> get allPlants => List.from(_plants);

  void deletePlant(int index) {
    _plants.removeAt(index);
  }

  void editPlant(Plant plant, int index) {
    _plants[index] = plant;
  }

  void fetchPlants() {
    _isLoading = true;
    notifyListeners();
    http
        .get('https://herby-47c7c.firebaseio.com/plants.json')
        .then((http.Response res) {
      final List<Plant> fetchedPlantsList = [];
      final Map<String, dynamic> plants = json.decode(res.body);

      if (plants == null) {
        _isLoading = false;
        notifyListeners();
        return;
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
    });
  }
}

mixin UtilityModel on ConnectedPlantsModel {
  bool get isLoading => _isLoading;
}

mixin ConnectedPlantsModel on Model {
  List<Plant> _plants = [];
  User _authenticatedUser;
  bool _isLoading = false;

  Future<Null> addPlant(Map<String, dynamic> plantForm) {
    _isLoading = true;
    notifyListeners();
    dynamic customEncode(dynamic item) {
      if (item is DateTime) {
        return item.toIso8601String();
      }
      return item;
    }

    Map<String, dynamic> userId = {'userId': _authenticatedUser.id};
    plantForm.addAll(userId);

    return http
        .post('https://herby-47c7c.firebaseio.com/plants.json',
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
    });
  }
}
