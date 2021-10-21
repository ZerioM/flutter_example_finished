import 'package:camera/camera.dart';
import 'package:flutter/cupertino.dart';
import '../state/take_pictures_state.dart';

class TakePictureScreen extends StatefulWidget{
   const TakePictureScreen({
    Key? key,
    required this.camera,
  }) : super(key: key);

  final CameraDescription camera;

  @override
  TakePictureScreenState createState() => TakePictureScreenState();

}