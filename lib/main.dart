import 'package:example_finished/tabs/list.dart';
import 'package:example_finished/tabs/sensor_state.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

Future<void> main() async {

  WidgetsFlutterBinding.ensureInitialized();

  // Obtain a list of the available cameras on the device.
  final cameras = await availableCameras();

  debugPrint('cameras: $cameras');

  final CameraDescription firstCamera = cameras[0];

  // Get a specific camera from the list of available cameras.

  runApp(MyApp(camera: firstCamera));
}

class MyApp extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  MyApp({Key? key,  this.camera}) : super(key: key);

  final CameraDescription? camera;
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              bottom: const TabBar(
                tabs: [
                  Tab(icon: Icon(Icons.list)),
                  Tab(icon: Icon(Icons.sensors)),
                ],
              ),
              title: const Text('Flutter Demo'),
            ),
            body: TabBarView(children: [
              ListTab(),
              SensorTabScreen(
                camera: camera,
              ),
            ])),
      ),
    );
  }
}
