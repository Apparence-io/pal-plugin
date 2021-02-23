import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

import 'group_details_model.dart';
import 'group_details_presenter.dart';

class GroupDetailsView {}

class GroupDetailsPage extends StatelessWidget implements GroupDetailsView {
  final String groupId;

  GroupDetailsPage({Key key, @required this.groupId}) : super(key: key);

  final _mvvmBuilder =
      MVVMPageBuilder<GroupDetailsPresenter, GroupDetailsModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  GroupDetailsPresenter get pagePresenter => _mvvmBuilder.presenter;

  @override
  Widget build(BuildContext context) {
    return _mvvmBuilder.build(
      context: context,
      key: ValueKey('GroupDetailsPage'),
      presenterBuilder: (context) => GroupDetailsPresenter(
        GroupDetailsModel(),
        this,
      ),
      builder: (context, presenter, model) =>
          _buildPage(context, presenter, model),
    );
  }

  _buildPage(
    MvvmContext context,
    GroupDetailsPresenter presenter,
    GroupDetailsModel model,
  ) =>
      Scaffold(
        key: _scaffoldKey,
      );
}
