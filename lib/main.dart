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
  final List<Map<String, dynamic>> _plants = [];

  void _addPlant(Map<String, dynamic> plant) {
    print(plant['name']);
    setState(() {
      _plants.add(plant);
    });
  }

  void _deletePlant(int index) {
    setState(() {
      _plants.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        routes: {
          '/': (BuildContext context) => AuthPage(),
          '/home': (BuildContext context) =>
              HomePage(_plants, _addPlant, _deletePlant)
        },
        onGenerateRoute: (RouteSettings settings) {
          final List<String> pathElements = settings.name.split('/');
          if (pathElements[0] != '') {
            return null;
          }
          if (pathElements[1].startsWith('plant')) {
            final int index = int.parse(pathElements[2]);
            Map plant = _plants[index];
            return MaterialPageRoute<bool>(
                builder: (BuildContext context) => PlantsDetailsPage(plant));
          }
          return null;
        },
        onUnknownRoute: (RouteSettings settings) {
          return MaterialPageRoute(
              builder: (BuildContext context) =>
                  HomePage(_plants, _addPlant, _deletePlant));
        });
  }
}
