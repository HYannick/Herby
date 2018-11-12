import 'package:herby_app/models/plant.dart';
import 'package:scoped_model/scoped_model.dart';

class PlantsModel extends Model {
  List<Plant> _plants = [
    Plant(
        frequency: 16,
        imgURL: 'assets/Aloe Vera.jpg',
        lastWatering: DateTime.now(),
        daysLeft: 6,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiualiquip ',
        name: 'Eccheveria Novalis'),
    Plant(
        frequency: 16,
        imgURL: 'assets/Dracena Marginata.jpg',
        lastWatering: DateTime.now(),
        daysLeft: 6,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing eli laboris nisi ut aliquip ',
        name: 'Eccheveria Novalis'),
    Plant(
        frequency: 16,
        imgURL: 'assets/Aloe Vera.jpg',
        lastWatering: DateTime.now(),
        daysLeft: 6,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiualiquip ',
        name: 'Eccheveria Novalis'),
    Plant(
        frequency: 16,
        imgURL: 'assets/Dracena Marginata.jpg',
        lastWatering: DateTime.now(),
        daysLeft: 6,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing eli laboris nisi ut aliquip ',
        name: 'Eccheveria Novalis'),
    Plant(
        frequency: 16,
        imgURL: 'assets/Aloe Vera.jpg',
        lastWatering: DateTime.now(),
        daysLeft: 6,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiualiquip ',
        name: 'Eccheveria Novalis'),
    Plant(
        frequency: 16,
        imgURL: 'assets/Dracena Marginata.jpg',
        lastWatering: DateTime.now(),
        daysLeft: 6,
        description:
            'Lorem ipsum dolor sit amet, consectetur adipiscing eli laboris nisi ut aliquip ',
        name: 'Eccheveria Novalis')
  ];

  List<Plant> get plants => List.from(_plants);

  void addPlant(Plant plant) {
    _plants.add(plant);
    notifyListeners();
  }

  void deletePlant(int index) {
    _plants.removeAt(index);
  }

  void editPlant(int index) {
    ;
  }
}
