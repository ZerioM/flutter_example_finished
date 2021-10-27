import 'dart:io';
import 'package:camera/camera.dart';
import 'package:example_finished/widgets/take_pictures_state.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class SensorTabScreen extends StatefulWidget {
  const SensorTabScreen({
    Key? key,
    this.camera,
  }) : super(key: key);
  final CameraDescription? camera;
  @override
  SensorTabScreenState createState() => SensorTabScreenState();
}

class SensorTabScreenState extends State<SensorTabScreen> {

  late dynamic _image = "";
  final ImagePicker _picker = ImagePicker();

  // ignore: prefer_typing_uninitialized_variables
  // final cameras = await availableCameras();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(children: [
        ElevatedButton(
            child: const Text('Open File Picker'),
            onPressed: () async {
              final image = await _picker.pickImage(source: ImageSource.gallery);
              setState(() => _image = image);

              // Navigate to second route when tapped.
            }),
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
                ? Image.file(File(_image!.path),
                    scale: 0.5, fit: BoxFit.contain, height: 400)
                : const Text("No image!"))
      ]),
    ));
  }
}
