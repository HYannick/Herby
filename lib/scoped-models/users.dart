import 'package:herby_app/models/user.dart';
import 'package:scoped_model/scoped_model.dart';

mixin UsersModel on Model {
  User _authenticatedUser;

  void login(String email, String password) {
    _authenticatedUser =
        User(id: 'daoeufnemzvz3', email: email, password: password);
  }
}
