import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class BottomProgressBar extends StatelessWidget {

  BoxConstraints constraints;

  BottomProgressBar({Key? key, required this.constraints}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
                  left: 0,
                  bottom: 0,
                  child: SizedBox(
                    width: constraints.maxWidth,
                    height: 80,
                    child: const Center(
                      child: CircularProgressIndicator(),
                    )
                  )
                  );
  }
  
}