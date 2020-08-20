import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_presenter.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_viewmodel.dart';

abstract class HelpersListModalView {
  void lookupHostedAppStruct(GlobalKey<NavigatorState> hostedAppNavigatorKey);
  void processElement(Element element, {int n = 0});
  Future<void> capturePng(
    final HelpersListModalPresenter presenter,
    final HelpersListModalModel model,
  );
}

class HelpersListModal extends StatelessWidget implements HelpersListModalView {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final GlobalKey repaintBoundaryKey;

  HelpersListModal({
    Key key,
    this.hostedAppNavigatorKey,
    this.repaintBoundaryKey,
  });

  @override
  Widget build(BuildContext context) {
    return MVVMPage<HelpersListModalPresenter, HelpersListModalModel>(
      key: ValueKey('palHelpersListModal'),
      presenter: HelpersListModalPresenter(this),
      builder: (context, presenter, model) {
        return Scaffold(
          appBar: AppBar(
            titleSpacing: 40.0,
            automaticallyImplyLeading: false,
            title: Text('Pal editor'),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20.0),
                child: IconButton(
                  key: ValueKey('palHelpersListModalClose'),
                  icon: Icon(
                    Icons.close,
                    size: 30.0,
                  ),
                  onPressed: () => Navigator.pop(context.buildContext),
                ),
              ),
            ],
          ),
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
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Helpers list here'),
                SizedBox(
                  height: 30.0,
                ),
                RaisedButton.icon(
                  key: ValueKey('palHelpersListModalNew'),
                  onPressed: () => Navigator.pushNamed(context, '/editor/new'),
                  icon: Icon(Icons.add_circle_outline),
                  label: Text('New'),
                ),
                RaisedButton.icon(
                  key: ValueKey('palLookupAllChildrens'),
                  onPressed: () => lookupHostedAppStruct(hostedAppNavigatorKey),
                  icon: Icon(Icons.search),
                  label: Text('Host struct'),
                ),
                RaisedButton.icon(
                  key: ValueKey('palScreenshot'),
                  onPressed: () => capturePng(presenter, model),
                  icon: Icon(Icons.mobile_screen_share),
                  label: Text('Capture host screen'),
                )
              ],
            ),
            if (model.imageBs != null)
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                ),
                child: Image.memory(model.imageBs, height: 210),
              ),
          ],
        ),
      ),
    );
  }

  @override
  void lookupHostedAppStruct(GlobalKey<NavigatorState> hostedAppNavigatorKey) {
    if (hostedAppNavigatorKey == null) {
      return;
    }

    hostedAppNavigatorKey.currentContext.visitChildElements(processElement);
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
