import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';

class EditorMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 12),
      height: 56,
      decoration: BoxDecoration(
        gradient: PalTheme.of(context).bottomNavEditorGradient
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildItem(context, "helper", Icons.add_box, () => _showHelperModal(context)),
          _buildItem(context, "Background", Icons.check_box_outline_blank, null),
          _buildItem(context, "Text", Icons.text_fields, null),
          _buildItem(context, "Graphics", Icons.image, null),
          _buildItem(context, "Settings", Icons.settings, null),
        ],
      ),
    );
  }

  Widget _buildItem(BuildContext context, String title, IconData icon, Function onTap) {
    return InkWell(
      onTap: onTap,
      child: Column(
        children: [
          Icon(icon, color: PalTheme.of(context).editorMenuIconColor, size: 24,),
          Text(
            title,
            style: TextStyle(
              color: PalTheme.of(context).editorMenuIconColor,
              fontSize: 11
            )
          )
        ],
      ),
    );
  }

  _showHelperModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      backgroundColor: PalTheme.of(context).buildTheme().backgroundColor,
      builder: (context) => HelpersListMenu()
    );
  }

}


class HelpersListMenu extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
        children: [
          ListTile(
            title: Text("Simple"),
          ),
          ListTile(
            title: Text("Fullscreen"),
          )
        ],
      ),
    );
  }
}
