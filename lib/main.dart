import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Movies App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Movies App'),
        ),
        body: Center(
          child: Container(
            child: Text('Movies App'),
          ),
        ),
      ),
    );
  }
}
