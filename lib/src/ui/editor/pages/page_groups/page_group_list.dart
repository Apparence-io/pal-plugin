import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/pal.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:pal/src/ui/editor/pages/page_groups/widgets/page_group_list_item.dart';
import 'package:pal/src/ui/editor/pages/page_groups/widgets/page_overlay.dart';

import 'page_group_list_model.dart';
import 'page_group_list_presenter.dart';
import 'widgets/create_helper_button.dart';

abstract class PageGroupsListView {
  Future closePage();

  Future<bool> navigateCreateHelper(final String? pageId);

  void changeBubbleState(bool state);

  Future openAppSettingsPage();
}

class PageGroupsListPage extends StatelessWidget {
  final _PageGroupsListView _viewInterface = _PageGroupsListView();

  @override
  Widget build(BuildContext context) {
    return MVVMPage<PageGroupsListPresenter, PageGroupsListViewModel>(
      key: ValueKey('presenter'),
      presenter: PageGroupsListPresenter(
        editorInjector: EditorInjector.of(context)!,
        viewInterface: _viewInterface..context = context,
        navigatorObserver: PalNavigatorObserver.instance(),
      ),
      builder: (context, presenter, model) => PartialOverlayedPage(
        key: _viewInterface.overlayedPageState,
        child: WillPopScope(
          onWillPop: () async {
            this._viewInterface.changeBubbleState(true);
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 16, 0, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildHeader(context.buildContext, presenter),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Text("List of available helper groups on this page",
                      style:
                          _descrTextStyle(PalTheme.of(context.buildContext)!)),
                ),
                SizedBox(height: 12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: CreateHelperButton(
                      palTheme: PalTheme.of(context.buildContext),
                      onTap: presenter.onClickAddHelper),
                ),
                model.isLoading ?? true
                    ? Expanded(
                        child: Center(
                            child: CircularProgressIndicator(value: null)))
                    : _buildItemList(presenter, model),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: _buildCloseButton(PalTheme.of(context.buildContext)!,
                      presenter.onClickClose),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(
          BuildContext context, PageGroupsListPresenter presenter) =>
      Row(
        children: [
          Image.asset(
            'packages/pal/assets/images/logo.png',
            height: 56.0,
          ),
          SizedBox(width: 12),
          Expanded(
            child: RichText(
              text: TextSpan(children: <TextSpan>[
                TextSpan(
                    text: 'PAL',
                    style: TextStyle(
                        fontSize: 26, color: PalTheme.of(context)!.colors.dark)),
                TextSpan(
                    text: '\nEDITOR',
                    style: TextStyle(
                        fontSize: 10, color: PalTheme.of(context)!.colors.dark)),
              ]),
            ),
          ),
          // currently disabled because not supported for desktop & web for now
          // https://github.com/ueman/application_icon/issues/9 
          // _buildCircleButton(
          //   'pal_HelpersListModal_Settings',
          //   Icon(Icons.settings, size: 24),
          //   presenter.onClickSettings,
          // ),
        ],
      );

  Widget _buildItemList(PageGroupsListPresenter presenter, PageGroupsListViewModel model) {
    if (model.errorMessage != null) {
      return Expanded(
        child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal:16.0),
              child: Text(model.errorMessage!,
                key: ValueKey("ErrorMessage"),
                style: TextStyle(),
                textAlign: TextAlign.center,
      ),
            )));
    }
    if(model.groups.isEmpty) {
      return Expanded(
        child: Center(child: Text("You haven't created anything on this page yet")),
      );
    }
    return Expanded(
      child: ListView.builder(
          itemCount: model.groups.keys.length,
          itemBuilder: (context, index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 24),
                    Text(model.groups.keys.elementAt(index).toText()!,
                        style: _triggerTypetextStyle(PalTheme.of(context)!)),
                    SizedBox(height: 8),
                    ListView.separated(
                        physics: const NeverScrollableScrollPhysics(),
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8),
                        shrinkWrap: true,
                        itemCount: model
                            .groups[model.groups.keys.elementAt(index)]!.length,
                        itemBuilder: (context2, itemIndex) {
                          GroupItemViewModel item =
                              model.groups[model.groups.keys.elementAt(index)]!
                                  [itemIndex];
                          return InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              Navigator.of(context).pushNamed(
                                  '/editor/group/details',
                                  arguments: {
                                    "id": item.id,
                                    "route": model.route
                                  });
                            },
                            child: PageGroupsListItem(
                              key: ValueKey(item.id),
                              title: item.title,
                              subtitle: item.date,
                              version: item.version,
                              palTheme: PalTheme.of(context),
                            ),
                          );
                        })
                  ],
                ),
              )),
    );
  }

  Widget _buildCircleButton(
      final String key, final Icon icon, final Function callback) {
    return SizedBox(
      height: 40.0,
      width: 40.0,
      child: FloatingActionButton(
        heroTag: key,
        key: ValueKey(key),
        onPressed: callback as void Function()?,
        child: icon,
        shape: CircleBorder(),
      ),
    );
  }

  Widget _buildCloseButton(PalThemeData palThemeData, Function onClose) =>
      SizedBox(
        width: double.infinity,
        child: OutlineButton(
          child: Text(
            'Close',
            style: TextStyle(
              fontWeight: FontWeight.w300,
              color: palThemeData.colors.dark,
            ),
          ),
          onPressed: onClose as void Function()?,
          borderSide: BorderSide(color: palThemeData.colors.dark!, width: 1),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
      );

  TextStyle _triggerTypetextStyle(PalThemeData palTheme) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w500,
        color: palTheme.colors.dark,
      );

  TextStyle _descrTextStyle(PalThemeData palTheme) => TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w200,
        color: palTheme.colors.dark,
      );
}

class _PageGroupsListView implements PageGroupsListView {
  late BuildContext context;
  GlobalKey<PartialOverlayedPageState> overlayedPageState = GlobalKey();

  @override
  Future closePage() async {
    HapticFeedback.selectionClick();
    await overlayedPageState.currentState!.closePage();
    Navigator.of(context).pop();
  }

  @override
  Future<bool> navigateCreateHelper(final String? pageId) async {
    HapticFeedback.selectionClick();
    // Display the helper creation view
    final shouldOpenEditor = await Navigator.pushNamed<dynamic>(
      EditorInjector.of(context)!.palNavigatorKey!.currentContext!,
      '/editor/new',
      arguments: CreateHelperPageArguments(
        EditorInjector.of(context)!.hostedAppNavigatorKey,
        pageId,
      ),
    );
    if (shouldOpenEditor != null && shouldOpenEditor) {
      // Dismiss the bottom modal when next was tapped
      Navigator.pop(context);
    }
    return shouldOpenEditor;
  }

  @override
  void changeBubbleState(bool state) {
    EditorInjector.of(context)!.palEditModeStateService.showBubble(
        EditorInjector.of(context)!.hostedAppNavigatorKey!.currentContext, state);
    Navigator.pop(context);
  }

  @override
  Future openAppSettingsPage() {
    HapticFeedback.selectionClick();
    return Navigator.pushNamed(
      context,
      '/settings',
    );
  }
}
