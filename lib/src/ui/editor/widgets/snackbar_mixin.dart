import 'package:flutter/material.dart';
import 'package:pal/src/theme.dart';

class SnackbarMixin {
  showSnackbarMessage(
      GlobalKey<ScaffoldState> _scaffoldKey, String message, bool success) {
    if (_scaffoldKey.currentContext == null) {
      return;
    }
    ScaffoldMessenger.of(_scaffoldKey.currentContext!).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            success
                ? Icon(Icons.check, color: Colors.lightGreenAccent)
                : Icon(Icons.warning,
                    color:
                        PalTheme.of(_scaffoldKey.currentContext!)!.colors.light),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: success
            ? PalTheme.of(_scaffoldKey.currentContext!)!.colors.dark
            : Colors.redAccent,
        duration: Duration(milliseconds: 1500),
      ),
    );
  }
}
