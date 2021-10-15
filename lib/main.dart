import 'package:example_finished/tabs/list.dart';
import 'package:example_finished/tabs/sensors.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: DefaultTabController(
        length: 2, 
        child: 
        Scaffold(
          appBar: 
          AppBar(
            bottom: 
            const TabBar(
              tabs: [
                Tab(icon: Icon(Icons.list)),
                Tab(icon: Icon(Icons.sensors)),
              ],
            ),
            title: const Text('Flutter Demo'),
          ),
          body: TabBarView(
            children: [
              ListTab(),
              SensorsTab(),
            ]
          )
        ),
      ),
    );
  }
}
