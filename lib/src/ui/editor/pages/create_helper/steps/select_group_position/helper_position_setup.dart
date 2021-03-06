import 'package:flutter/material.dart';
import '../../../../../../theme.dart';
import '../../create_helper_viewmodel.dart';

typedef OnValidate = void Function(int? models);

class HelperPositionPage extends StatefulWidget {
  final Future<List<GroupHelperViewModel>>? helpersLoader;
  final OnValidate? onValidate;

  HelperPositionPage({this.helpersLoader, this.onValidate, Key? key})
      : super(key: key);

  @override
  _HelperPositionPageState createState() => _HelperPositionPageState();
}

class _HelperPositionPageState extends State<HelperPositionPage> {
  List<GroupHelperViewModel>? reorderableList;
  int? selectedRank;

  _HelperPositionPageState();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: ValueKey("helper_position_page"),
      appBar: AppBar(title: Text("Position inside your group")),
      body: FutureBuilder<List<GroupHelperViewModel>>(
        future: widget.helpersLoader,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done ||
              !snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            reorderableList = snapshot.data;
          }
          return Stack(
            children: [
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 70,
                child: LayoutBuilder(
                    builder: (context, constraints) =>
                        _buildReorderebleList(constraints)),
              ),
              Positioned(
                bottom: 8.0,
                left: 16.0,
                right: 16.0,
                child: Column(
                  children: [
                    Text(
                      'You can change the position by long dragging item',
                      style:
                          TextStyle(fontSize: 10, fontWeight: FontWeight.w200),
                    ),
                    _buildValidateButton(context)
                  ],
                ),
              )
            ],
          );
        },
      ),
    );
  }

  Widget _buildReorderebleList(BoxConstraints constraints) {
    return SizedBox(
      key: ValueKey("container_listreorder"),
      height: constraints.maxHeight == double.infinity
          ? 500
          : constraints.maxHeight,
      child: ReorderableListView(
        children:
            (reorderableList!.map((element) => _buildItem(element)).toList()),
        onReorder: (oldIndex, newIndex) {
          setState(() {
            if (oldIndex < newIndex) {
              newIndex -= 1;
            }
            if (reorderableList![oldIndex].id == "NEW_HELPER") {
              var element = reorderableList!.removeAt(oldIndex);
              reorderableList!.insert(newIndex, element);
              this.selectedRank = newIndex;
            }
          });
        },
      ),
    );
  }

  Widget _buildItem(GroupHelperViewModel element) {
    return Padding(
      key: ValueKey(element.id),
      padding: const EdgeInsets.symmetric(vertical: 1.0),
      child: ListTile(
        title: Text(element.title!.isEmpty ? "[No name]" : element.title!),
        tileColor: element.id != "NEW_HELPER"
            ? Colors.grey.withOpacity(.2)
            : PalTheme.of(context)!.colors.color1!.withOpacity(.2),
      ),
    );
  }

  _buildValidateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: RaisedButton(
        key: ValueKey('palHelperPositionNextButton'),
        disabledColor: PalTheme.of(context)!.colors.color4,
        child: Text(
          'Validate position',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        color: PalTheme.of(context)!.colors.color1,
        onPressed: () {
          widget.onValidate!(this.selectedRank);
          Navigator.of(context).pop();
        },
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }
}
