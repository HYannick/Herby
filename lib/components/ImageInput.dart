import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:herby_app/scoped-models/main.dart';
import 'package:image_picker/image_picker.dart';
import 'package:scoped_model/scoped_model.dart';

class ImageInput extends StatefulWidget {
  @override
  ImageInputState createState() {
    return new ImageInputState();
  }
}

class ImageInputState extends State<ImageInput> {
  void _getImage(BuildContext context, ImageSource src, Function pickImage) {
    ImagePicker.pickImage(source: src, maxWidth: 800.0).then((File image) {
      pickImage(image);
      Navigator.pushNamed(context, '/plant-create');
    });
  }

  void _openImagePicker(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return Container(
              height: 150.0,
              padding: EdgeInsets.symmetric(horizontal: 10.0),
              child: ScopedModelDescendant<MainModel>(
                  builder: (BuildContext context, Widget child, model) {
                return Column(
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        'Pick an image!',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    FlatButton(
                      child: Text('Use Camera'),
                      onPressed: () {
                        _getImage(context, ImageSource.camera, model.pickImage);
                      },
                    ),
                    FlatButton(
                      child: Text('Use Gallery'),
                      onPressed: () {
                        _getImage(
                            context, ImageSource.gallery, model.pickImage);
                      },
                    )
                  ],
                );
              }));
        });
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      elevation: 5.0,
      backgroundColor: Colors.white,
      child: SvgPicture.asset('assets/photo-icon--outline.svg'),
      onPressed: () => _openImagePicker(context),
    );
  }
}
