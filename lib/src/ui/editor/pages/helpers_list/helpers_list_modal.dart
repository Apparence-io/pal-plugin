import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/services/pal/pal_state_service.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_modal_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_modal_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/widgets/helper_tile_widget.dart';
import 'package:palplugin/src/ui/shared/widgets/overlayed.dart';

abstract class HelpersListModalView {
  void lookupHostedAppStruct(GlobalKey<NavigatorState> hostedAppNavigatorKey);
  void processElement(Element element, {int n = 0});
  Future<void> capturePng(
    final HelpersListModalPresenter presenter,
    final HelpersListModalModel model,
  );
}

class HelpersListModal extends StatelessWidget implements HelpersListModalView {
  final GlobalKey<NavigatorState>
      hostedAppNavigatorKey; //FIXME remove this from here
  final GlobalKey repaintBoundaryKey;
  final HelpersListModalLoader loader;
  final PalEditModeStateService palEditModeStateService;

  final _mvvmPageBuilder =
      MVVMPageBuilder<HelpersListModalPresenter, HelpersListModalModel>();
  HelpersListModal({
    Key key,
    this.loader,
    this.hostedAppNavigatorKey,
    this.repaintBoundaryKey,
    this.palEditModeStateService,
  });

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => HelpersListModalPresenter(
        this,
        loader: this.loader ??
            HelpersListModalLoader(
              EditorInjector.of(context).pageService,
              EditorInjector.of(context).helperService,
            ),
        palEditModeStateService: this.palEditModeStateService ??
            EditorInjector.of(context).palEditModeStateService,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          key: ValueKey('palHelpersListModal'),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildHeader(context, model, presenter),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 20.0),
              child: _buildList(context, presenter, model),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: _buildFooter(context),
          )
        ],
      ),
    );
  }

  Widget _buildFooter(
    final BuildContext context,
  ) {
    return SizedBox(
      width: double.infinity,
      child: OutlineButton(
        key: ValueKey('palHelpersListModalClose'),
        child: Text(
          'Close',
          style: TextStyle(
            fontWeight: FontWeight.w300,
            color: Theme.of(context).accentColor,
          ),
        ),
        onPressed: () {
          HapticFeedback.selectionClick();
          Navigator.pop(context);
        },
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
    return (model.helpers != null)
        ? ListView.separated(
            padding: const EdgeInsets.only(bottom: 20.0),
            key: ValueKey('palHelpersListModalContent'),
            separatorBuilder: (context, index) => SizedBox(
              height: 12,
            ),
            itemCount: model.helpers.length,
            itemBuilder: (context, index) {
              HelperEntity helperEntity = model.helpers[index];

              return HelperTileWidget(
                key: ValueKey('palHelpersListModalTile$index'),
                name: helperEntity?.name,
                trigger: helperTriggerTypeToString(helperEntity?.triggerType),
                versionMin: helperEntity?.versionMin,
                versionMax: helperEntity?.versionMax,
                isDisabled: false,
                onTapCallback: () {
                  // TODO: Send params
                  Navigator.pushNamed(context, '/editor/${helperEntity.id}');
                },
              );
            },
          )
        : Center(
            key: ValueKey('palHelpersListModalNoHelpers'),
            child: (model.isLoading)
                ? CircularProgressIndicator()
                : Text('No helpers on this page.'),
          );
  }

  Widget _buildHeader(
    final BuildContext context,
    final HelpersListModalModel model,
    final HelpersListModalPresenter presenter,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'PAL editor',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 3.0,
            ),
            Text(
              'List of available helpers on this page',
              style: TextStyle(fontSize: 10.0, fontWeight: FontWeight.w300),
            )
          ],
        ),
        Row(
          children: [
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: FloatingActionButton(
                heroTag: 'palHelpersListModalNew',
                key: ValueKey('palHelpersListModalNew'),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.pushNamed(context, '/editor/new');
                },
                child: Icon(
                  Icons.add,
                  size: 18.0,
                ),
                shape: CircleBorder(),
              ),
            ),
            // FIXME: This icon button is temporaly available
            SizedBox(
              width: 20.0,
            ),
            SizedBox(
              height: 30.0,
              width: 30.0,
              child: FloatingActionButton(
                heroTag: 'palHelpersListModalEditor',
                key: ValueKey('palHelpersListModalEditor'),
                onPressed: () {
                  HapticFeedback.selectionClick();
                  Navigator.of(context).pop();
                  // FIXME: This will be moved to new page
                  OverlayEntry helperOverlay = OverlayEntry(
                    opaque: false,
                    builder: HelperEditorPageBuilder(
                      model.pageId,
                      hostedAppNavigatorKey,
                    ).build,
                  );
                  Overlayed.of(context).entries.putIfAbsent(
                        OverlayKeys.EDITOR_OVERLAY_KEY,
                        () => helperOverlay,
                      );
                  hostedAppNavigatorKey.currentState.overlay
                      .insert(helperOverlay);
                  presenter.hidePalBubble();
                },
                child: Icon(
                  Icons.format_paint,
                  size: 18.0,
                ),
                shape: CircleBorder(),
              ),
            )
          ],
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

  // TODO: Move this to an utils file
  @override
  processElement(Element element, {int n = 0}) {
    if (element.widget.key != null) {
      var parentObject = repaintBoundaryKey.currentContext.findRenderObject();
      if (element.widget is Scaffold) {
        print("SCAFFOLD");
      }
      var translation =
          element.renderObject.getTransformTo(parentObject).getTranslation();
      print("$n - key " +
          element.widget.key.toString() +
          " " +
          element.size.toString());
      print("translation ${translation.t} ${translation.r} ${translation.s}");
      print(
          "::bounds ${element.renderObject.paintBounds.shift(Offset(translation.x, translation.y))}");
      print("::bounds ${parentObject.paintBounds}");
    }
    element.visitChildElements((visitor) => processElement(visitor, n: n + 1));
  }

  // TODO: Move this to an utils file
  @override
  Future<void> capturePng(
    final HelpersListModalPresenter presenter,
    final HelpersListModalModel model,
  ) async {
    try {
      RenderRepaintBoundary boundary =
          repaintBoundaryKey.currentContext.findRenderObject();
      ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      ByteData byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      presenter.setImage(byteData);
    } catch (e) {
      print('error while catching screenshot');
      print(e);
    }
  }
}
