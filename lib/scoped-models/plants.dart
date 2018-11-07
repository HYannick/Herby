import 'package:herby_app/models/plant.dart';
import 'package:scoped_model/scoped_model.dart';

class PlantsModel extends Model {
  List<Plant> _plants = [];

  List<Plant> get plants {
    return List.from(_plants);
  }

  void _addPlant(Plant plant) {
    _plants.add(plant);
  }

  void _deletePlant(int index) {
    _plants.removeAt(index);
  }
}
