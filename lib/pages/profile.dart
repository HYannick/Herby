import 'package:flutter/material.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          Text('Profile page'),
          ScopedModelDescendant<MainModel>(
              builder: (BuildContext context, Widget child, MainModel model) {
            return RaisedButton.icon(
              label: Text('Logout'),
              onPressed: () {
                model.logout();
              },
              icon: Icon(Icons.exit_to_app),
            );
          }),
        ],
      ),
    );
  }
}
