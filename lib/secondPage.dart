import 'package:flutter/material.dart';

class MySecondPage extends StatefulWidget {
  MySecondPage({Key? key}) : super(key: key);

  @override
  _MySecondPageState createState() => _MySecondPageState();
}

class _MySecondPageState extends State<MySecondPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('This is the second page!'),
            FlatButton(onPressed: () {Navigator.pop(context);}, child: Text('Go back'),),
          ],
        ),
      ),
    );
  }
}