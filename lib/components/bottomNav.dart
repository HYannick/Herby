import 'package:flutter/material.dart';

class BottomNav extends StatelessWidget {
  final Color greenyColor = Color.fromRGBO(39, 200, 181, 1.0);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60.0,
      color: Colors.white,
      padding: EdgeInsets.all(5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: GestureDetector(
              onTap: () {
                print('Plants Tapped');
              },
              child: Column(
                children: <Widget>[
                  Image.asset(
                    'assets/plant-icon--green.png',
                    width: 30.0,
                  ),
                  Text(
                    'My plants',
                    style: TextStyle(color: greenyColor),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: LayoutBuilder(builder: (context, constraints) {
              double stackWidth = 70.0;
              double stackElevation = -40.0;
              return Stack(
                overflow: Overflow.visible,
                children: [
                  Positioned(
                    child: Column(
                      children: <Widget>[
                        Container(
                          padding: EdgeInsets.only(
                              top: 10.0, left: 10.0, right: 10.0, bottom: 10.0),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100.0)),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.black, width: 2.0),
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
          Expanded(
            flex: 2,
            child: Column(
              children: <Widget>[
                Icon(
                  Icons.person,
                  size: 30.0,
                ),
                Text('My Profile')
              ],
            ),
          ),
        ],
      ),
    );
  }
}
