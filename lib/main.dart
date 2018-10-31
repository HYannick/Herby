import 'package:flutter/material.dart';

main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text(
            'Herby',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Add a plant :D'),
              onPressed: () {},
            ),
            Card(
              elevation: 0.0,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          'Aloe Vera',
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20.0),
                        ),
                      ),
                      Container(
                          constraints: BoxConstraints.expand(
                            height:
                                Theme.of(context).textTheme.display1.fontSize *
                                        1.1 +
                                    120.0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              image: DecorationImage(
                                image: ExactAssetImage('assets/aloe.jpg'),
                                fit: BoxFit.cover,
                              )),
                          child: Container(
                            padding: EdgeInsets.all(15.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.0),
                              gradient: new LinearGradient(
                                  colors: [Colors.black87, Colors.transparent],
                                  begin: Alignment.topCenter,
                                  end: Alignment(0.0, 0.3)),
                            ),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                  flex: 2,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Next Watering in',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        '8 days',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20.0,
                                            color: Colors.white),
                                      ),
                                      DecoratedBox(
                                        decoration: BoxDecoration(
                                            //color: Colors.lightGreen
                                            gradient: LinearGradient(
                                                begin:
                                                    FractionalOffset.bottomLeft,
                                                end: FractionalOffset.topRight,
                                                colors: [
                                              Colors.black,
                                              Colors.transparent,
                                            ])),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  alignment: Alignment.topCenter,
                                  child: Image.asset(
                                    'assets/drop-icon--white.png',
                                    width: 30.0,
                                  ),
                                )
                              ],
                            ),
                          ))
                    ]),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
