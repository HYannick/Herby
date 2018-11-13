import 'package:herby_app/models/plant.dart';
import 'package:scoped_model/scoped_model.dart';

mixin PlantsModel on Model {
  List<Plant> _plants = [];

  List<Plant> get plants => List.from(_plants);

  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
  }

  void deletePlant(int index) {
    _plants.removeAt(index);
    notifyListeners();
  }

  void editPlant(Plant plant, int index) {
    _plants[index] = plant;
  }
}
