import 'package:herby_app/scoped-models/plants.dart';
import 'package:herby_app/scoped-models/users.dart';
import 'package:scoped_model/scoped_model.dart';

class MainModel extends Model with UsersModel, PlantsModel {}
