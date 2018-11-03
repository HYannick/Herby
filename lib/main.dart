import 'package:flutter/material.dart';
import 'package:herby_app/pages/auth.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: AuthPage());
  }
}
