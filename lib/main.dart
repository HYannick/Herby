import 'package:flutter/material.dart';
import 'package:herby_app/pages/home.dart';
import 'package:herby_app/pages/plant_create.dart';
import 'package:herby_app/pages/plants_details.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:scoped_model/scoped_model.dart';

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
    final MainModel model = MainModel();
    return ScopedModel<MainModel>(
      model: model,
      child: MaterialApp(
          theme: ThemeData(fontFamily: 'Nunito'),
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (BuildContext context) => HomePage(model), //AuthPage(),
            '/home': (BuildContext context) => HomePage(model),
            '/plant-create': (BuildContext context) => PlantCreatePage()
          },
          onGenerateRoute: (RouteSettings settings) {
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1].startsWith('plant')) {
              final String plantId = pathElements[2];
              return MaterialPageRoute<bool>(
                  builder: (BuildContext context) =>
                      PlantsDetailsPage(plantId));
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => HomePage(model));
          }),
    );
  }
}
