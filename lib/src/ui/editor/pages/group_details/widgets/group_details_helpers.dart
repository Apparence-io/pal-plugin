import 'package:flutter/material.dart';

class GroupDetailsHelpersList extends StatelessWidget {
  const GroupDetailsHelpersList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        GroupDetailsHelperTile(),
        GroupDetailsHelperTile(),
        GroupDetailsHelperTile(),
      ],
    );
  }
}

class GroupDetailsHelperTile extends StatefulWidget {
  @override
  _GroupDetailsHelperTileState createState() => _GroupDetailsHelperTileState();
}

class _GroupDetailsHelperTileState extends State<GroupDetailsHelperTile> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
