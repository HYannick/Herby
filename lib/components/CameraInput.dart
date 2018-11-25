import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:herby_app/theme.dart';
import 'package:path_provider/path_provider.dart';

class CameraInput extends StatefulWidget {
  final List<CameraDescription> cameras;
  final Function pickImage;

  CameraInput(this.cameras, this.pickImage);

  @override
  _CameraInputState createState() {
    return _CameraInputState();
  }
}

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class _CameraInputState extends State<CameraInput> {
  CameraController controller;
  String imagePath;
  double stackOpacity = 1.0;
  double thumbnailOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    controller = CameraController(widget.cameras[0], ResolutionPreset.high);
    controller.initialize().then((_) {
      if (!mounted) {
        return;
      }
      setState(() {});
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Stack(
          children: <Widget>[
            (!controller.value.isInitialized)
                ? Container()
                : _cameraPreviewWidget(),
            Positioned(
                bottom: 30.0,
                left: MediaQuery.of(context).size.width / 2 - 50.0,
                child: _captureControlRowWidget()),
            imagePath != null ? _thumbnailWidget() : Container()
          ],
        ),
      ],
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Transform.scale(
        scale: controller.value.aspectRatio / deviceRatio,
        child: AnimatedContainer(
          curve: cubicEase,
          height: imagePath != null ? 400.0 : size.height,
          duration: hDuration700,
          child: Center(
            child: AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: CameraPreview(controller),
            ),
          ),
        ));
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
        child: FadeInImage(
      width: size.width,
      height: imagePath != null ? 400.0 : size.height,
      placeholder: AssetImage('assets/drop-placeholder.png'),
      image: AssetImage(imagePath),
      fit: BoxFit.cover,
    ));
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return imagePath != null
        ? Container()
        : Container(
            width: 100.0,
            height: 100.0,
            padding: EdgeInsets.all(20.0),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(50.0),
                border: Border.all(color: Colors.white, width: 2.0)),
            child: IconButton(
              icon: const Icon(
                Icons.camera_alt,
                size: 40.0,
              ),
              color: Colors.white,
              onPressed: onTakePictureButtonPressed,
            ),
          );
  }

  String timestamp() => DateTime.now().millisecondsSinceEpoch.toString();

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        widget.pickImage(File(filePath));
        setState(() {
          stackOpacity = 0.0;
          thumbnailOpacity = 1.0;
          imagePath = filePath;
        });
      }
    });
  }

  Future<String> takePicture() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/Pictures/flutter_test';
    await Directory(dirPath).create(recursive: true);
    final String filePath = '$dirPath/${timestamp()}.jpg';

    if (controller.value.isTakingPicture) {
      // A capture is already pending, do nothing.
      return null;
    }

    try {
      await controller.takePicture(filePath);
    } on CameraException catch (e) {
      return null;
    }
    return filePath;
  }
}
