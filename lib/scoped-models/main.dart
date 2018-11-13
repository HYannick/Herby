import 'package:herby_app/scoped-models/connected_plants.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model
    with ConnectedPlantsModel, UsersModel, PlantsModel, UtilityModel {}
