import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/group_details/widgets/group_details_helpers.dart';
import 'package:pal/src/ui/editor/pages/group_details/widgets/group_details_infos.dart';
import 'package:pal/src/ui/editor/pages/group_details/widgets/group_details_tabs.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_router.dart';
import 'package:pal/src/ui/editor/widgets/snackbar_mixin.dart';

import 'group_details_model.dart';
import 'group_details_presenter.dart';

abstract class GroupDetailsView {
  void showError();

  void showSucess(String text);

  void showEditor(
      String? routeName, String helperId, String? groupId, HelperType type);

  void pop();

  void previewHelper(String id) {}
}

class GroupDetailsPage extends StatelessWidget
    with SnackbarMixin
    implements GroupDetailsView {
  final String? groupId;
  final String? routeName;
  final PageStep? page;

  GroupDetailsPage(
      {Key? key, required this.groupId, required this.routeName, this.page})
      : super(key: key);

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
          GroupDetailsPageModel(
              this.groupId, GlobalKey<FormState>(), this.routeName, page),
          this,
          helperService: EditorInjector.of(context)!.helperService,
          groupService: EditorInjector.of(context)!.helperGroupService,
          versionService: EditorInjector.of(context)!.versionEditorService),
      builder: (context, presenter, model) =>
          _buildPage(context, presenter, model),
    );
  }

  _buildPage(
    MvvmContext context,
    GroupDetailsPresenter presenter,
    GroupDetailsPageModel model,
  ) =>
      WillPopScope(
        onWillPop: () async {
          this.pop();
          return true;
        },
        child: Theme(
          data: PalTheme.of(context.buildContext)!.buildTheme().copyWith(
                dividerTheme: DividerThemeData(color: Colors.transparent),
                accentColor: PalTheme.of(context.buildContext)!.colors.color1,
              ),
          child: Scaffold(
            key: _scaffoldKey,
            backgroundColor: Color(0xFFFAFEFF),
            // ## APP BAR
            appBar: AppBar(
              iconTheme: IconThemeData(color: Colors.black),
              backgroundColor: Color.fromRGBO(231, 241, 247, 1),
              leading: GestureDetector(
                onTap: () {
                  Navigator.pop(context.buildContext);
                  EditorInjector.of(context.buildContext)!
                      .palEditModeStateService
                      .showHelpersList(EditorInjector.of(context.buildContext)!
                          .hostedAppNavigatorKey!
                          .currentContext);
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
                        key: ValueKey('HelpersList'),
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
                  key: ValueKey('MenuButton'),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      key: ValueKey('DeleteGroupButton'),
                      child: Text('Delete'),
                      value: '',
                    )
                  ],
                  icon: Icon(Icons.more_horiz),
                  offset: Offset(0, 24),
                  onSelected: (dynamic val) => presenter.deleteGroup(),
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
                  loading: model.loading,
                  onPreview: presenter.previewHelper,
                  onDelete: presenter.deleteHelper,
                  onEdit: presenter.editHelper,
                  helpersList: model.helpers,
                  key: ValueKey('GroupHelpers'),
                ),
              ],
            ),
          ),
        ),
      );

  @override
  void showError() {
    showSnackbarMessage(_scaffoldKey, 'Erreur lors de la mise à jour.', false);
  }

  @override
  void showSucess(String text) {
    showSnackbarMessage(_scaffoldKey, text, true);
  }

  @override
  void showEditor(
      String? routeName, String helperId, String? groupId, HelperType type) {
    // POP CURRENT ROUTE, THE OVERLAY MUST BE ON TOP OF CLIENT ROUTE
    Navigator.pop(_scaffoldKey.currentContext!);
    var navKey = EditorInjector.of(this._scaffoldKey.currentContext!)!
        .hostedAppNavigatorKey;
    EditorRouter router = EditorRouter(navKey);
    // SHOWING EDITOR HELPER WITH PAL CONTEXT IN ORDER TO RETURN TO THIS PAGE
    router.editHelper(routeName, helperId, type, groupId,
        con: EditorInjector.of(this._scaffoldKey.currentContext!)!
            .palNavigatorKey!
            .currentContext);
  }

  @override
  void pop() {
    Navigator.pop(_scaffoldKey.currentContext!);
    EditorInjector.of(_scaffoldKey.currentContext!)!
        .palEditModeStateService
        .showHelpersList(EditorInjector.of(_scaffoldKey.currentContext!)!
            .hostedAppNavigatorKey!
            .currentContext);
  }

  @override
  void previewHelper(String id) async {
    Navigator.pop(_scaffoldKey.currentContext!);
    var navKey =
        EditorInjector.of(this._scaffoldKey.currentContext!)!.palNavigatorKey!;
    EditorPreviewArguments arguments = EditorPreviewArguments(
        (context) => Navigator.of(context).pushReplacementNamed(
              '/editor/group/details',
              arguments: {
                "id": groupId,
                "route": this.routeName,
                "page": PageStep.HELPERS
              },
            ),
        helperId: id);
    await Navigator.pushNamed(
      navKey.currentContext!,
      '/editor/preview',
      arguments: arguments,
    );
  }
}
