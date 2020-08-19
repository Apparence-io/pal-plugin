library palplugin;

import 'package:flutter/material.dart';

class Pal extends StatefulWidget {
  /// application child to display Pal over it.
  final Widget child;

  // reference to the Navigator state of the child app
  final GlobalKey<NavigatorState> navigatorKey;

  /// disable or enable the plugin.
  final bool enabled;

  Pal({
    Key key,
    @required this.child,
    @required this.navigatorKey,
    this.enabled = true,
  }) : super(key: key);

  @override
  _PalState createState() => _PalState();
}

class _PalState extends State<Pal> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Stack(
        children: [
          widget.child,
          Center(
            child: Container(
              width: 100,
              height: 100,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}
