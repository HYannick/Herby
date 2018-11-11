import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:herby_app/components/custom_notched_shapes.dart';
import 'package:herby_app/components/gradientImageBackground.dart';
import 'package:herby_app/pages/plant_create.dart';
import 'package:herby_app/pages/profile.dart';
import 'package:herby_app/plants_list.dart';

class HomePage extends StatefulWidget {
  HomePage();

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final Color greenyColor = Color.fromRGBO(39, 200, 181, 1.0);
  final Color mainGreen = Color.fromRGBO(140, 216, 207, 1.0);
  final String avatarURL = 'assets/avatar-sample.jpg';
  final String backgroundURL = 'assets/home-bg.jpg';
  final String username = 'Math';

  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      PlantsList(),
      PlantCreatePage(),
      ProfilePage()
    ];
    // _children[_currentIndex]
    return Scaffold(
      body: Stack(children: <Widget>[
        GradientImageBackground(
          opacity: 0.1,
          imgURL: backgroundURL,
          color: Colors.transparent,
          enableGradient: false,
        ),
        SafeArea(
            child: Column(
          children: <Widget>[
            _buildHeader(),
            Expanded(
              child: _children[_currentIndex],
            )
          ],
        )),
      ]),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        elevation: 5.0,
        backgroundColor: Colors.white,
        child: const Icon(
          Icons.add,
          size: 45.0,
          color: Color.fromRGBO(140, 216, 207, 1.0),
        ),
        onPressed: () {
          setState(() {
            _currentIndex = 1;
          });
        },
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CustomCircularNotchedRectangle(),
        notchMargin: 20.0,
        elevation: 10.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              FlatButton(
                shape: CircleBorder(),
                child: SvgPicture.asset('assets/plant-icon--outline.svg'),
                onPressed: () {
                  setState(() {
                    _currentIndex = 0;
                  });
                },
              ),
              IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () {
                  setState(() {
                    _currentIndex = 2;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding _buildHeader() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Row(
        children: <Widget>[
          Expanded(
              child: Row(
            children: <Widget>[
              Text(
                'Hello ',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25.0),
              ),
              Text(
                '$username!',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 25.0,
                    color: mainGreen),
              ),
            ],
          )),
          Container(
            width: 70.0,
            height: 70.0,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(5.0),
                    topLeft: Radius.circular(20.0),
                    bottomLeft: Radius.circular(20.0),
                    bottomRight: Radius.circular(20.0)),
                image: DecorationImage(
                    image: ExactAssetImage(avatarURL),
                    fit: BoxFit.cover,
                    alignment: Alignment(0.0, 0.25))),
          )
        ],
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
