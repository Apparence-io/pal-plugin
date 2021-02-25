import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/group_details/widgets/group_details_helpers.dart';
import 'package:pal/src/ui/editor/pages/group_details/widgets/group_details_infos.dart';
import 'package:pal/src/ui/editor/pages/group_details/widgets/group_details_tabs.dart';

import 'group_details_model.dart';
import 'group_details_presenter.dart';

class GroupDetailsView {}

class GroupDetailsPage extends StatelessWidget implements GroupDetailsView {
  final String groupId;

  GroupDetailsPage({Key key, @required this.groupId}) : super(key: key);

  final _mvvmBuilder =
      MVVMPageBuilder<GroupDetailsPresenter, GroupDetailsPageModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  MVVMPageBuilder<GroupDetailsPresenter, GroupDetailsPageModel>
      get getPageBuilder => _mvvmBuilder;

  @override
  Widget build(BuildContext context) {
    return _mvvmBuilder.build(
      context: context,
      key: ValueKey('GroupDetailsPage'),
      presenterBuilder: (context) => GroupDetailsPresenter(
          GroupDetailsPageModel(this.groupId, GlobalKey<FormState>()), this,
          groupService: EditorInjector.of(context).helperGroupService),
      builder: (context, presenter, model) =>
          _buildPage(context, presenter, model),
    );
  }

  _buildPage(
    MvvmContext context,
    GroupDetailsPresenter presenter,
    GroupDetailsPageModel model,
  ) =>
      Theme(
        data: PalTheme.of(context.buildContext).buildTheme().copyWith(
              dividerTheme: DividerThemeData(color: Colors.transparent),
              accentColor: PalTheme.of(context.buildContext).colors.color1,
            ),
        child: Scaffold(
          key: _scaffoldKey,
          // resizeToAvoidBottomInset: false,
          backgroundColor: Color(0xFFFAFEFF),

          // ## APP BAR
          appBar: AppBar(
            iconTheme: IconThemeData(color: Colors.black),
            backgroundColor: Color.fromRGBO(231, 241, 247, 1),
            leading: GestureDetector(
              onTap: () {
                Navigator.pop(context.buildContext);
              },
              child: Icon(
                Icons.arrow_back_ios_rounded,
                size: 28,
              ),
            ),
            title: Text(
              'Group details',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w300),
            ),
            titleSpacing: 0,

            // *****TABS
            bottom: PreferredSize(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Row(
                  children: [
                    GroupDetailsTabWidget(
                      label: 'Group details',
                      active: model.page == PageStep.DETAILS ? true : false,
                      onTap: model.page == PageStep.DETAILS
                          ? null
                          : () => presenter.goToGroupDetails(),
                    ),
                    VerticalDivider(
                      width: 24,
                    ),
                    GroupDetailsTabWidget(
                      label: 'Helpers',
                      active: model.page == PageStep.HELPERS ? true : false,
                      onTap: model.page == PageStep.HELPERS
                          ? null
                          : () {
                              FocusScope.of(context.buildContext).unfocus();
                              presenter.goToHelpersList();
                            },
                    )
                  ],
                ),
              ),
              preferredSize: Size.fromHeight(50),
            ),
            // *****TABS

            // *****MENU BUTTON
            actions: [
              PopupMenuButton(
                itemBuilder: (context) =>
                    [PopupMenuItem(child: Text('Delete'))],
                icon: Icon(Icons.more_horiz),
                offset: Offset(0, 24),
              )
            ],
            // *******MENU BUTTON
          ),
          // ## APP BAR

          body: PageView(
            controller: model.pageController,
            physics: NeverScrollableScrollPhysics(),
            children: [
              Form(
                key: model.formKey,
                child: GroupDetailsInfo(
                  presenter,
                  model,
                  key: ValueKey('GroupInfo'),
                ),
              ),
              GroupDetailsHelpersList(
                onPreview: presenter.previewHelper,
                onDelete: presenter.deleteHelper,
                onEdit: presenter.editHelper,
                helpersList: model.helpers,
                key: ValueKey('GroupHelpers'),
              ),
            ],
          ),
        ),
      );
}
