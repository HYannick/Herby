import 'package:flutter/material.dart';
import 'package:herby_app/pages/plant_create.dart';
import 'package:herby_app/pages/profile.dart';
import 'package:herby_app/plants_list.dart';

class HomePage extends StatefulWidget {
  final List<Map<String, dynamic>> plants;
  final Function addPlant;
  final Function deletePlant;

  HomePage(this.plants, this.addPlant, this.deletePlant);

  @override
  HomePageState createState() {
    return new HomePageState();
  }
}

class HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final Color greenyColor = Color.fromRGBO(39, 200, 181, 1.0);
  @override
  Widget build(BuildContext context) {
    final List<Widget> _children = [
      PlantsList(widget.plants, widget.addPlant, widget.deletePlant),
      PlantCreatePage(widget.addPlant),
      ProfilePage()
    ];

    return Scaffold(
      body: SafeArea(child: _children[_currentIndex]),
      bottomNavigationBar: Theme(
        data: Theme.of(context).copyWith(
          // sets the background color of the `BottomNavigationBar`
          canvasColor: Colors.white,
          // sets the active color of the `BottomNavigationBar` if `Brightness` is light
          primaryColor: greenyColor,
        ),
        child: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.nature),
              title: Text('My plants'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.add),
              title: Container(
                height: 20.0,
                child: LayoutBuilder(builder: (context, constraints) {
                  double stackWidth = 70.0;
                  double stackElevation = -70.0;
                  return Stack(
                    overflow: Overflow.visible,
                    children: [
                      Positioned(
                        child: Column(
                          children: <Widget>[
                            Container(
                              padding: EdgeInsets.only(
                                  top: 10.0,
                                  left: 10.0,
                                  right: 10.0,
                                  bottom: 10.0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(100.0)),
                              child: Container(
                                padding: EdgeInsets.all(8.0),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.black, width: 2.0),
                                    borderRadius: BorderRadius.circular(100.0)),
                                child: Icon(
                                  Icons.add,
                                  size: 30.0,
                                ),
                              ),
                            ),
                            Text('Add new')
                          ],
                        ),
                        width: stackWidth,
                        top: stackElevation,
                        left: (constraints.maxWidth / 2) - (stackWidth / 2),
                      ),
                    ],
                  );
                }),
              ),
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), title: Text('Profile'))
          ],
        ),
      ),
    );
  }

  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
