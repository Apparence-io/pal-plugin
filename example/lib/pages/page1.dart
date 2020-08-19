import 'package:flutter/material.dart';

class Page1 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Page 1'),
      ),
      body: Center(
        child: RaisedButton(
          child: Text('Open route'),
          onPressed: () {
            Navigator.pushNamed(context, '/page2');
          },
        ),
      ),
    );
  }
}