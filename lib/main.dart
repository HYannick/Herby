import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:herby_app/components/CameraInput.dart';
import 'package:herby_app/pages/auth.dart';
import 'package:herby_app/pages/home.dart';
import 'package:herby_app/pages/plant_create.dart';
import 'package:herby_app/pages/plants_details.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:herby_app/theme.dart';
import 'package:scoped_model/scoped_model.dart';

List<CameraDescription> cameras;
Future<Null> main() async {
  // Fetch the available cameras before initializing the app.
  try {
    cameras = await availableCameras();
  } on CameraException catch (e) {
    logError(e.code, e.description);
  }
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  MainModel _model;
  bool _isAuthenticated = false;

  @override
  void initState() {
    _model = MainModel();
    _model.autoAuth();
    _model.getCameras(cameras);
    _model.userSubject.listen((bool isAuthenticated) {
      setState(() {
        _isAuthenticated = isAuthenticated;
      });
    });
    super.initState();
  }

  Widget checkAuth(Widget widget) => !_isAuthenticated ? AuthPage() : widget;

  @override
  Widget build(BuildContext context) {
    return ScopedModel<MainModel>(
      model: _model,
      child: MaterialApp(
          theme: ThemeData(fontFamily: 'Nunito', backgroundColor: hWhite),
          debugShowCheckedModeBanner: false,
          routes: {
            '/': (BuildContext context) => checkAuth(HomePage(_model)),
            '/plant-create': (BuildContext context) =>
                checkAuth(PlantCreatePage())
          },
          onGenerateRoute: (RouteSettings settings) {
            if (!_isAuthenticated) {
              return MaterialPageRoute<bool>(
                  builder: (BuildContext context) => AuthPage());
            }
            final List<String> pathElements = settings.name.split('/');
            if (pathElements[0] != '') {
              return null;
            }
            if (pathElements[1].startsWith('plant')) {
              final String plantId = pathElements[2];
              return PageRouteBuilder<bool>(
                pageBuilder: (BuildContext context, Animation<double> animation,
                    Animation<double> secondaryAnimation) {
                  return AnimatedBuilder(
                      animation:
                          CurvedAnimation(parent: animation, curve: cubicEase),
                      builder: (BuildContext context, Widget child) {
                        return Opacity(
                          opacity: animation.value,
                          child: checkAuth(PlantsDetailsPage(plantId)),
                        );
                      });
                },
                transitionDuration: hDuration300,
              );
            }
            return null;
          },
          onUnknownRoute: (RouteSettings settings) {
            return MaterialPageRoute(
                builder: (BuildContext context) => checkAuth(HomePage(_model)));
          }),
    );
  }
}
