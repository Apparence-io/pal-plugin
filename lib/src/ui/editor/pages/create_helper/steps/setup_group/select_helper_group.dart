import 'package:flutter/material.dart';
import 'package:pal/src/theme.dart';

import '../../create_helper_viewmodel.dart';

typedef HelperGroupLoader = Future<List<HelperGroupViewModel>> Function();

typedef OnTapHelperGroup = void Function(HelperGroupViewModel tapedElement);

/// ---------------------------------------------------------
/// HelperGroupSelection page for [CreateHelperPage]
/// ---------------------------------------------------------
class SelectHelperGroupPage extends StatelessWidget {

  final HelperGroupLoader helperGroupLoader;

  final Function onTapAdd;
  
  final OnTapHelperGroup onTapElement;

  SelectHelperGroupPage({this.helperGroupLoader, this.onTapAdd, this.onTapElement});

  @override
  Widget build(BuildContext context)
    => Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        _AddGroupButton(onTapAdd: onTapAdd),
        Expanded(
          child: FutureBuilder<List<HelperGroupViewModel>>(
            future: helperGroupLoader(),
            builder: (ctx, snapshot) => snapshot.connectionState == ConnectionState.done
              ? !snapshot.hasData || snapshot.data.length == 0 ? _buildEmptyList() : _buildItems(snapshot.data)
              : _buildLoading(),
          ),
        ),
      ],
    );

  _buildLoading() => Center(child: CircularProgressIndicator());

  _buildEmptyList() => Center(child: Text("No helper group found on this page"));

  _buildItems(List<HelperGroupViewModel> data) => ListView.separated(
    separatorBuilder: (context, index) => Divider(),
    itemBuilder: (context, index) => HelperGroupItemLine(data[index], onTapElement),
    itemCount: data.length,
  );

}

/// ---------------------------------------------------------
/// StatefullWidget of items shown in [SelectHelperGroupPage]
/// ---------------------------------------------------------
class HelperGroupItemLine extends StatelessWidget {

  final HelperGroupViewModel model;
  
  final OnTapHelperGroup onTapElement;
  
  HelperGroupItemLine(this.model, this.onTapElement);

  @override
  Widget build(BuildContext context) => ValueListenableBuilder(
    valueListenable: model,
    builder: (ctx, value, child) => ListTile(
      onTap: () => onTapElement(value),
      selected: value.selected,
      selectedTileColor: PalTheme.of(context).colors.color4.withOpacity(.6),
      title: Text(value?.title ?? "",
        style: TextStyle(
          fontSize: 16,
          color: PalTheme.of(context).colors.dark,
          fontFamily: 'Montserrat',
          fontWeight: FontWeight.w500
        ),
      ),
    )
  );
}



/// ---------------------------------------------------------
/// AddButton
/// ---------------------------------------------------------
class _AddGroupButton extends StatelessWidget {

  final Function onTapAdd;
  
  _AddGroupButton({@required this.onTapAdd});

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: this.onTapAdd,
    child: Container(
      color: PalTheme.of(context).colors.color3,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16),
        child: Row(
          children: [
            Icon(Icons.add, color: PalTheme.of(context).colors.light),
            SizedBox(width: 8),
            Text("Create new group",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w500,
                color: PalTheme.of(context).colors.light))
          ],
        ),
      ),
    ),
  );
}

