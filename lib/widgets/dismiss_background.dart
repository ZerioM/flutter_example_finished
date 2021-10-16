import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DismissBackground extends StatelessWidget {

  final String text;
  final Color color;
  final bool isLeft;

  const DismissBackground({Key? key, required this.text, required this.color, required this.isLeft}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container( 
                      color: color,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          Expanded(child: 
                            Stack(
                              children: [
                                if(isLeft)...[
                                  Positioned(
                                    left: 8,
                                    child: Text(text, style: const TextStyle(color: Colors.white))
                                  )
                                 ],
                                if(!isLeft)...[
                                  Positioned(
                                      right: 8, 
                                      child: Text(text, style: const TextStyle(color: Colors.white))
                                  )
                                ]
                              ],)
                          )
                        ]
                      )
                    );
  }
  
}