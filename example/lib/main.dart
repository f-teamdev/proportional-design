import 'package:flutter/material.dart';
import 'package:proportional_design/proportional_design.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Dimensions Example',
      home: ExampleScreen(),
    );
  }
}

class ExampleScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dimensions Example')),
      body: Column(
        children: [
          Text('Screen Width: ${context.screenWidth}'),
          Text('Screen Height: ${context.screenHeight}'),
          Container(
            width: context.getProportionalWidth(200),
            height: context.getProportionalHeight(100),
            color: Colors.blue,
          ),
        ],
      ),
    );
  }
}
