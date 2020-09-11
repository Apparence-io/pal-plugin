import 'package:flutter/material.dart';

class EditorAnchoredFullscreenHelper extends StatelessWidget {

  List<Rect> bounds;

  @override
  Widget build(BuildContext context) {
    print("EditorAnchoredFullscreenHelper");
    return Material(
      color: Colors.redAccent,
      child: Stack(
        children: [
          Text("test"),
          Text("test"),
          Text("test"),
          Text("test"),
          Text("test"),
          Text("test"),
          Text("test"),
          Text("test"),
        ],
      ),
    );
  }
}
