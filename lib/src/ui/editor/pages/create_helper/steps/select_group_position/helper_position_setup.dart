import 'package:flutter/material.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_actionsbar/editor_actionsbar.dart';

import '../../../../../../theme.dart';
import '../../create_helper_viewmodel.dart';

typedef OnValidate = void Function(List<GroupHelperViewModel> models);

class HelperPositionPage extends StatefulWidget {

  final Future<List<GroupHelperViewModel>> helpersLoader;
  final OnValidate onValidate;

  HelperPositionPage({
    this.helpersLoader, this.onValidate, Key key
  }) : super(key: key);

  @override
  _HelperPositionPageState createState() => _HelperPositionPageState();
}

class _HelperPositionPageState extends State<HelperPositionPage> {

  List<GroupHelperViewModel> reorderableList;

  _HelperPositionPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Position inside your group")),
      body: FutureBuilder(
        future: widget.helpersLoader,
        builder: (context, snapshot) {
          if(snapshot.connectionState != ConnectionState.done) {
            return CircularProgressIndicator();
          }
          if(snapshot.hasData) {
            reorderableList = snapshot.data;
          }
          return Container(
            child: Column(
              children: [
                Expanded(
                  child: ReorderableListView(
                    children: reorderableList.map((element) => _buildItem(element)).toList(),
                    onReorder: (oldIndex, newIndex) {
                      setState(() {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        var element = reorderableList.removeAt(oldIndex);
                        reorderableList.insert(newIndex, element);
                      });
                    },
                  )
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 8.0,
                    bottom: 8.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Container(
                    width: double.infinity,
                    child: _buildValidateButton(context),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildItem(GroupHelperViewModel element) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      key: ValueKey(element.id),
      children: [
        ListTile(
          title: Text(element.title)),
        Divider()
      ],
    );
  }

  _buildValidateButton(BuildContext context) {
    return RaisedButton(
      key: ValueKey('palHelperPositionNextButton'),
      disabledColor: PalTheme.of(context).colors.color4,
      child: Text(
        'Validate position',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      color: PalTheme.of(context).colors.color1,
      onPressed: () {
        widget.onValidate(this.reorderableList);
        Navigator.of(context).pop();
      },
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}

