import 'package:flutter/material.dart';

class GradientImageBackground extends StatelessWidget {
  String imgURL;
  Color color;

  GradientImageBackground({this.imgURL = '', this.color = Colors.black87});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: ExactAssetImage(imgURL),
            fit: BoxFit.cover,
          )),
        ),
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [color, Colors.transparent],
                begin: Alignment.topCenter,
                end: Alignment(0.0, 0.3)),
          ),
        ),
      ],
    );
  }
}
