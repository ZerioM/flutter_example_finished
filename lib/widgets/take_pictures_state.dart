import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter/cupertino.dart';

class TakePictureScreen extends StatefulWidget{
   const TakePictureScreen({
    Key? key,
     this.camera,
  }) : super(key: key);

  final CameraDescription? camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();

}
class TakePictureScreenState extends State<TakePictureScreen> {
  late CameraController _controller;
  late Future<void> _initializeControllerFuture;
  bool loading = false;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    _controller = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera!,
      // Define the resolution to use.
      ResolutionPreset.medium,
    );
    // Next, initialize the controller. This returns a Future.
    _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Take a picture')),
      body: FutureBuilder<void>(
        future: _initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done && !loading) {
            // If the Future is complete, display the preview.
            return CameraPreview(_controller);
          } else {
            // Otherwise, display a loading indicator.
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      
      floatingActionButton:  Center(
          child:  FloatingActionButton(
        // Provide an onPressed callback.
        onPressed: () async {
          // Take the Picture in a try / catch block. If anything goes wrong,
          // catch the error.
          try {
            // Ensure that the camera is initialized.
            await _initializeControllerFuture;
            setState(() {
              loading = true;
            });
     
            late dynamic image = "";
            await _controller.takePicture().then((value) => {
                  image = value,
                  setState(() {
                    loading = false;
                  })
                });

            Navigator.pop(context, image);
          } catch (e) {
            print(e);
          }
        },
        child: const Icon(Icons.camera_alt),
      )),
    );
  }
}
