import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/theme.dart';

import 'group_details_model.dart';
import 'group_details_presenter.dart';

class GroupDetailsView {}

class GroupDetailsPage extends StatelessWidget implements GroupDetailsView {
  final String groupId;

  GroupDetailsPage({Key key, @required this.groupId}) : super(key: key);

  final _mvvmBuilder =
      MVVMPageBuilder<GroupDetailsPresenter, GroupDetailsModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  MVVMPageBuilder<GroupDetailsPresenter, GroupDetailsModel>
      get getPageBuilder => _mvvmBuilder;

  @override
  Widget build(BuildContext context) {
    return _mvvmBuilder.build(
      context: context,
      key: ValueKey('GroupDetailsPage'),
      presenterBuilder: (context) => GroupDetailsPresenter(
          GroupDetailsModel(this.groupId), this,
          groupService: EditorInjector.of(context).helperGroupService),
      builder: (context, presenter, model) =>
          _buildPage(context, presenter, model),
    );
  }

  _buildPage(
    MvvmContext context,
    GroupDetailsPresenter presenter,
    GroupDetailsModel model,
  ) =>
      Theme(
        data: PalTheme.of(context.buildContext).buildTheme(),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            leading: Icon(Icons.arrow_back_ios_rounded,size: 24,),
            title: Text('Group details'),
            titleSpacing: 0,
            bottom: PreferredSize(
              child: Row(
                children: [
                  Text('Group info'),
                  Text('Helpers'),
                ],
              ),
              preferredSize: Size.fromHeight(50),
            )
          ),
          body: AnimatedSwitcher(
            duration: Duration(milliseconds: 500),
            child: model.page == PageStep.DETAILS
                ? GroupDetailsInfo(
                    key: ValueKey('GroupInfo'),
                  )
                : GroupDetailsHelpersList(
                    key: ValueKey('GroupHelpers'),
                  ),
          ),
        ),
      );
}

class GroupDetailsInfo extends StatelessWidget {
  const GroupDetailsInfo({
    Key key,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

class GroupDetailsHelpersList extends StatelessWidget {
  const GroupDetailsHelpersList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
