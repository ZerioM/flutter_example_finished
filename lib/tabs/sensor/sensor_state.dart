import 'dart:io';
import 'package:example_finished/modules/camera/screens/take_picture_screen.dart';
import 'package:example_finished/tabs/sensor/sensors_screen.dart';
import 'package:flutter/material.dart';

class SensorTabScreenState extends State<SensorTabScreen> {
  late String _image = "";
  // ignore: prefer_typing_uninitialized_variables
  // final cameras = await availableCameras();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        ElevatedButton(
            child: const Text('Open Camera'),
            onPressed: () async {
              final image = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        TakePictureScreen(camera: widget.camera)),
              );
              setState(() => _image = image);

              // Navigate to second route when tapped.
            }),
        Padding(
            padding: const EdgeInsets.all(10),
            child: _image != ""
                ? Image.file(File(_image))
                : const Text("No image!"))
      ]),
    ));
  }
}
