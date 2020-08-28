import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';

class EditorModeBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 4),
      color: PalTheme.of(context).colors.accent,
      child: Text(
        "Pal Editor mode",
        style: TextStyle(
          color: PalTheme.of(context).colors.light,
          fontSize: 8
        ),
      ),
    );
  }
}