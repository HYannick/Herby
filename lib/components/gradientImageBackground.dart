import 'dart:io';

import 'package:flutter/material.dart';

class GradientImageBackground extends StatelessWidget {
  final String imgURL;
  final Color color;
  final Color fadeColor;
  final double opacity;
  final double gradientOpacity;
  final bool enableGradient;
  final File imageFile;

  GradientImageBackground(
      {this.imgURL = '',
      this.enableGradient = true,
      this.color = Colors.black87,
      this.opacity = 1.0,
      this.fadeColor = Colors.transparent,
      this.gradientOpacity = 1.0,
      this.imageFile});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: color),
      child: Opacity(
        opacity: opacity,
        child: Stack(
          children: <Widget>[
            imageFile == null
                ? Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                      image: ExactAssetImage(imgURL),
                      fit: BoxFit.cover,
                    )),
                  )
                : Container(
                    constraints: BoxConstraints.expand(height: 400.0),
                    child: Image.file(
                      imageFile,
                      fit: BoxFit.cover,
                    ),
                  ),
            enableGradient
                ? Opacity(
                    opacity: gradientOpacity,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [color, fadeColor],
                            begin: Alignment.topCenter,
                            end: Alignment(0.0, 0.3)),
                      ),
                    ),
                  )
                : Container()
          ],
        ),
      ),
    );
  }
}
