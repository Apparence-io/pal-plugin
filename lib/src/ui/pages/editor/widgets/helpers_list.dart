import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';

class HelpersListMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    var color = PalTheme.of(context).colors.dark;
    return Stack(
      children: [
        Positioned(
          bottom: 16, left: 16, right: 16,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Cancel",
                  key: ValueKey("cancel"),
                ),
                Opacity(
                  opacity: .5,
                  child: Text(
                    "Validate",
                    style: TextStyle(fontWeight: FontWeight.bold),
                    key: ValueKey("validate"),
                  ),
                )
              ],
            ),
          ),
        ),
        Positioned(
          bottom: 32, left: 16, right: 16, top: 16,
          child: ListView(
            children: [
              ListTile(
                key: ValueKey("option"),
                leading: Icon(Icons.border_outer, color: color),
                title: Text("Simple helper box"),
              ),
              ListTile(
                key: ValueKey("option"),
                leading: Icon(Icons.border_outer, color: color),
                title: Text("Fullscreen helper"),
              ),
            ],
          ),
        )
      ],
    );
  }
}