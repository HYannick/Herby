import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
    return Scaffold(
      key: _scaffoldKey,
      body: Stack(
        children: <Widget>[
          AnimatedCrossFade(
              firstChild: Stack(
                children: <Widget>[
                  (!controller.value.isInitialized)
                      ? Container()
                      : _cameraPreviewWidget(),
                  Positioned(
                      bottom: 30.0,
                      left: MediaQuery.of(context).size.width / 2 - 50.0,
                      child: _captureControlRowWidget()),
                ],
              ),
              secondChild: imagePath != null
                  ? _thumbnailWidget()
                  : Center(
                      child: CircularProgressIndicator(),
                    ),
              crossFadeState: imagePath == null
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: Duration(milliseconds: 700))
        ],
      ),
    );
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;
    return Transform.scale(
      scale: controller.value.aspectRatio / deviceRatio,
      child: Center(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: CameraPreview(controller),
        ),
      ),
    );
  }

  /// Display the thumbnail of the captured image or video.
  Widget _thumbnailWidget() {
    final size = MediaQuery.of(context).size;
    return SizedBox(
      child: Image.file(
        File(imagePath),
        fit: BoxFit.cover,
      ),
      width: size.width,
      height: size.height,
    );
  }

  /// Display the control bar with buttons to take pictures and record videos.
  Widget _captureControlRowWidget() {
    return Container(
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

  void showInSnackBar(String message) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(content: Text(message)));
  }

  void onTakePictureButtonPressed() {
    takePicture().then((String filePath) {
      if (mounted) {
        widget.pickImage(File(filePath));
        setState(() {
          stackOpacity = 0.0;
          thumbnailOpacity = 1.0;
          imagePath = filePath;
        });
        if (filePath != null) showInSnackBar('Picture saved to $filePath');
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
      _showCameraException(e);
      return null;
    }
    return filePath;
  }

  void _showCameraException(CameraException e) {
    logError(e.code, e.description);
    showInSnackBar('Error: ${e.code}\n${e.description}');
  }
}
