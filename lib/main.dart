import 'package:flutter/material.dart';
import 'package:herby_app/pages/auth.dart';
import 'package:herby_app/pages/home.dart';
import 'package:herby_app/pages/plants_details.dart';

main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(fontFamily: 'Nunito'),
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/home': (BuildContext context) => HomePage()
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1].startsWith('plant')) {
            final int index = int.parse(pathElements[2]);
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => PlantsDetailsPage(null));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) => HomePage());
        });
  }
}
