import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:herby_app/components/custom_notched_shapes.dart';
import 'package:herby_app/plants_list.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:herby_app/screens/plant_search.dart';
import 'package:herby_app/screens/profile.dart';
import 'package:herby_app/theme.dart';

class HomePage extends StatefulWidget {
  MainModel model;

  HomePage(this.model);

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _currentPageIndex = 0;
  final controller = PageController(initialPage: 0);
  final String avatarURL = 'assets/avatar-sample.jpg';
  final String backgroundURL = 'assets/home-bg.jpg';
  final String username = 'Math';

  @override
  Widget build(BuildContext context) {
    // _children[_currentIndex]
    return Scaffold(
      backgroundColor: Colors.white,
      body: PageView(
        controller: controller,
        physics: NeverScrollableScrollPhysics(),
        scrollDirection: Axis.horizontal,
        onPageChanged: (int value) {
          setState(() {
            _currentPageIndex = value;
          });
        },
        children: <Widget>[PlantsList(), PlantSearchPage(), ProfilePage()],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: _buildFAB(context),
      bottomNavigationBar: BottomAppBar(
        shape: CustomCircularNotchedRectangle(),
        notchMargin: 20.0,
        elevation: 50.0,
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
                  controller.animateToPage(0,
                      duration: Duration(milliseconds: 500), curve: cubicEase);
                },
              ),
              IconButton(
                icon: Icon(Icons.person_outline),
                onPressed: () {
                  controller.animateToPage(2,
                      duration: Duration(milliseconds: 500), curve: cubicEase);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  FloatingActionButton _buildFAB(BuildContext context) {
    return FloatingActionButton(
      elevation: 5.0,
      backgroundColor: Colors.white,
      child: _currentPageIndex == 1
          ? SvgPicture.asset(
              'assets/photo-icon--outline.svg',
              width: 20.0,
            )
          : Icon(
              Icons.add,
              size: 30.0,
              color: Color.fromRGBO(140, 216, 207, 1.0),
            ),
      onPressed: () {
        if (_currentPageIndex == 1) {
          Navigator.of(context).pushNamed('/plant-create');
        } else {
          controller.animateToPage(1,
              duration: Duration(milliseconds: 500), curve: cubicEase);
        }
      },
    );
  }

  @override
  void initState() {
    widget.model.fetchPlants();
    super.initState();
  }
}
