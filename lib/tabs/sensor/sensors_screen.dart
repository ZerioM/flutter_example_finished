import 'dart:io';

import 'package:camera/camera.dart';
import 'package:example_finished/modules/camera/screens/take_picture_screen.dart';
import 'package:example_finished/tabs/sensor/sensor_state.dart';
import 'package:flutter/material.dart';

class SensorTabScreen extends StatefulWidget {
 const SensorTabScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);
  final CameraDescription camera;
  @override
  SensorTabScreenState createState() => SensorTabScreenState();
}
