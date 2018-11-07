import 'package:flutter/material.dart';

class GradientImageBackground extends StatelessWidget {
  final String imgURL;
  final Color color;
  final double opacity;

  GradientImageBackground(
      {this.imgURL = '', this.color = Colors.black87, this.opacity = 1.0});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: Opacity(
        opacity: opacity,
        child: Stack(
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
        ),
      ),
    );
  }
}
