import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/editor/pages/helper_details/helper_details_view.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_loader.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_modal_presenter.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_modal_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/widgets/helper_tile_widget.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_details/helper_details_model.dart';

abstract class HelpersListModalView {

  void lookupHostedAppStruct(GlobalKey<NavigatorState> hostedAppNavigatorKey);

  Future<bool> openHelperCreationPage(
    final String pageId,
  );

  Future<void> openAppSettingsPage();

  Future<HelperDetailsPopState> openHelperDetailPage(
    final HelperEntity helperEntity,
    final String pageId,
    final String pageRouteName,
  );

  void reorganizeHelper(
    final int oldIndex,
    final int newIndex,
    final HelpersListModalPresenter presenter,
    final List<HelperEntity> helpers,
  );

  void onCloseButton();

  void popModalDialog();
}

class HelpersListModal extends StatefulWidget {
  final GlobalKey<NavigatorState>
      hostedAppNavigatorKey; //FIXME remove this from here

  final GlobalKey repaintBoundaryKey;
  final BuildContext bottomModalContext;
  final HelpersListModalLoader loader;
  final PalEditModeStateService palEditModeStateService;
  final EditorHelperService helperService;

  HelpersListModal({
    Key key,
    this.loader,
    this.helperService,
    this.hostedAppNavigatorKey,
    this.repaintBoundaryKey,
    this.bottomModalContext,
    this.palEditModeStateService,
  });

  @override
  _HelpersListModalState createState() => _HelpersListModalState();
}

class _HelpersListModalState extends State<HelpersListModal>
    implements HelpersListModalView {
  final ScrollController _listController = ScrollController();

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey(); // ignore: unused_field
  final _mvvmPageBuilder =
      MVVMPageBuilder<HelpersListModalPresenter, HelpersListModalModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('pal_HelpersListModal_MvvmBuilder'),
      context: context,
      presenterBuilder: (context) => HelpersListModalPresenter(
        this,
        loader: this.widget.loader ??
            HelpersListModalLoader(
                EditorInjector.of(context).pageEditorService,
                EditorInjector.of(context).helperService,
                EditorInjector.of(context).routeObserver),
        palEditModeStateService: this.widget.palEditModeStateService ??
            EditorInjector.of(context).palEditModeStateService,
        helperService: this.widget.helperService ??
            EditorInjector.of(context).helperService,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          body: this._buildPage(
            context.buildContext,
            presenter,
            model,
          ),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final HelpersListModalPresenter presenter,
    final HelpersListModalModel model,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 15.0, bottom: 5.0),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: _buildHeader(context, model, presenter),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: _buildList(context, presenter, model),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                bottom: 5.0,
                top: 2.0,
              ),
              child: !model.isLoading && model.helpers != null && model.helpers.isNotEmpty
                  ? Text(
                      '💡 You can re-order helpers by long tap on them.',
                      key: ValueKey('pal_HelpersListModal_ReorderTip'),
                      style: TextStyle(
                        fontSize: 12.0,
                      ),
                    )
                  : Container(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Align(
                alignment: Alignment.bottomCenter,
                child: _buildCloseButton(context),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildCloseButton(
    final BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        key: ValueKey('pal_HelpersListModal_Close'),
        child: Text(
          'Close',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).accentColor,
          ),
        ),
        onPressed: onCloseButton,
        borderSide: BorderSide(
          color: Theme.of(context).accentColor,
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  Widget _buildList(
    final BuildContext context,
    final HelpersListModalPresenter presenter,
    final HelpersListModalModel model,
  ) {
    return (model.helpers != null && model.helpers.length > 0)
        ? ReorderableListView(
            onReorder: (oldIndex, newIndex) => this.reorganizeHelper(
              oldIndex,
              newIndex,
              presenter,
              model.helpers,
            ),
            padding: const EdgeInsets.only(top: 8.0),
            key: ValueKey('palHelpersListModalContent'),
            scrollController: _listController
              ..addListener(() {
                if (_listController.position.extentAfter <= 100) {
                  presenter.loadMore();
                }
              }),
            children: _buildHelpersList(model, presenter),
          )
        : Center(
            key: ValueKey('palHelpersListModalNoHelpers'),
            child: (model.isLoading || model.loadingMore)
                ? CircularProgressIndicator()
                : Text('No helpers on this page.'),
          );
  }

  List<Widget> _buildHelpersList(
      HelpersListModalModel model, HelpersListModalPresenter presenter) {
    List<Widget> helpers = [];

    int index = 0;
    for (HelperEntity anHelper in model.helpers) {
      Widget cell = Padding(
        key: ValueKey('pal_HelpersListModal_Tile${index++}'),
        padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 24.0),
        child: HelperTileWidget(
          name: anHelper?.name,
          trigger: getHelperTriggerTypeDescription(anHelper?.triggerType),
          versionMin: anHelper?.versionMin,
          versionMax: anHelper?.versionMax,
          isDisabled: false,
          type: getHelperTypeDescription(anHelper?.type),
          onTapCallback: () {
            HapticFeedback.selectionClick();
            presenter.onClickHelper(anHelper);
          },
          // onTapCallback: () =>
          //     this.openHelperDetailPage(anHelper, model.pageId, presenter),
        ),
      );
      helpers.add(cell);
    }
    return helpers;
  }

  Widget _buildHeader(
    final BuildContext context,
    final HelpersListModalModel model,
    final HelpersListModalPresenter presenter,
  ) {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          'packages/pal/assets/images/logo.png',
          height: 36.0,
        ),
        SizedBox(width: 12),
        Expanded(
          flex: 3,
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'PAL editor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 3.0),
            Text(
              'Helpers on this page',
              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w300),
            )
          ],
        )),
        Flexible(
          flex: 1,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildCircleButton(
                'pal_HelpersListModal_Settings',
                Icon(
                  Icons.settings,
                  size: 20,
                ),
                presenter.onClickSettings,
              ),
              SizedBox(width: 14.0),
              _buildCircleButton(
                'pal_HelpersListModal_New',
                Icon(
                  Icons.add,
                  size: 25,
                ),
                presenter.onClickAdd,
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void lookupHostedAppStruct(GlobalKey<NavigatorState> hostedAppNavigatorKey) {
    if (hostedAppNavigatorKey == null) {
      return;
    }
  }

  // @override
  // processElement(Element element, {int n = 0}) {
  //   if (element.widget.key != null) {
  //     var parentObject =
  //         widget.repaintBoundaryKey.currentContext.findRenderObject();
  //     if (element.widget is Scaffold) {
  //       print("SCAFFOLD");
  //     }
  //     var translation =
  //         element.renderObject.getTransformTo(parentObject).getTranslation();
  //     print("$n - key " +
  //         element.widget.key.toString() +
  //         " " +
  //         element.size.toString());
  //     print("translation ${translation.t} ${translation.r} ${translation.s}");
  //     print(
  //         "::bounds ${element.renderObject.paintBounds.shift(Offset(translation.x, translation.y))}");
  //     print("::bounds ${parentObject.paintBounds}");
  //   }
  //   element.visitChildElements((visitor) => processElement(visitor, n: n + 1));
  // }

  // @override
  // Future<void> capturePng(
  //   final HelpersListModalPresenter presenter,
  //   final HelpersListModalModel model,
  // ) async {
  //   try {
  //     RenderRepaintBoundary boundary =
  //         widget.repaintBoundaryKey.currentContext.findRenderObject();
  //     ui.Image image = await boundary.toImage(pixelRatio: 3.0);
  //     ByteData byteData =
  //         await image.toByteData(format: ui.ImageByteFormat.png);

  //     presenter.setImage(byteData);
  //   } catch (e) {
  //     print('error while catching screenshot');
  //     print(e);
  //   }
  // }

  @override
  Future<bool> openHelperCreationPage(
    final String pageId,
  ) async {
    HapticFeedback.selectionClick();
    // Display the helper creation view
    final shouldOpenEditor = await Navigator.pushNamed(
      context,
      '/editor/new',
      arguments: CreateHelperPageArguments(
        widget.hostedAppNavigatorKey,
        pageId,
      ),
    );

    if (shouldOpenEditor != null && shouldOpenEditor) {
      // Dismiss the bottom modal when next was tapped
      Navigator.pop(widget.bottomModalContext);
    }
    return shouldOpenEditor;
  }

  @override
  Future<HelperDetailsPopState> openHelperDetailPage(
    final HelperEntity helperEntity,
    final String pageId,
    final String pageRouteName,
  ) async {
    // Display the helper detail view
    final helperDetailsPopState = await Navigator.pushNamed(
      context,
      '/editor/helper',
      arguments: HelperDetailsComponentArguments(
        widget.hostedAppNavigatorKey,
        helperEntity,
        pageId,
        pageRouteName
      ),
    ) as HelperDetailsPopState;
    return helperDetailsPopState;
  }

  @override
  Future openAppSettingsPage() async {
    HapticFeedback.selectionClick();
    // Display the helper creation view
    final shouldOpenEditor = await Navigator.pushNamed(
      context,
      '/settings',
    );

    if (shouldOpenEditor != null && shouldOpenEditor) {
      // Dismiss the bottom modal when next was tapped
      Navigator.pop(widget.bottomModalContext);
    }
  }

  Widget _buildCircleButton(
    final String key,
    final Icon icon,
    final Function callback,
  ) {
    return SizedBox(
      height: 32.0,
      width: 32.0,
      child: FloatingActionButton(
        heroTag: key,
        key: ValueKey(key),
        onPressed: callback,
        child: icon,
        shape: CircleBorder(),
      ),
    );
  }

  @override
  void reorganizeHelper(
    int oldIndex,
    int newIndex,
    HelpersListModalPresenter presenter,
    List<HelperEntity> helpers,
  ) {
    // First backup list before re-organize
    presenter.backupHelpersList();

    // Change on Front
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    final HelperEntity helperEntity = helpers.removeAt(oldIndex);
    helpers.insert(newIndex, helperEntity);
    presenter.refreshView();

    // Then submit change on back
    presenter.sendNewHelpersOrder(oldIndex, newIndex);
  }

  @override
  void onCloseButton() {
    HapticFeedback.selectionClick();
    Navigator.pop(context);
  }

  @override
  void popModalDialog() {
    Navigator.pop(widget.bottomModalContext);
  }
}
