import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/injectors/user_app/user_app_injector.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_loader.dart';
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
  final HelpersListModalLoader loader;

  HelpersListModal({
    Key key,
    this.loader,
    this.hostedAppNavigatorKey,
    this.repaintBoundaryKey,
  });

  @override
  Widget build(BuildContext context) {
    return MVVMPage<HelpersListModalPresenter, HelpersListModalModel>(
      key: ValueKey('palHelpersListModal'),
      presenter: HelpersListModalPresenter(
        this,
        loader: this.loader ??
            HelpersListModalLoader(
              EditorInjector.of(context).pageService,
              EditorInjector.of(context).helperService,
            ),
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
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 15.0,
        horizontal: 24.0,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        children: [
          _buildHeader(context),
          Expanded(
            child: _buildList(context, presenter, model),
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
        onPressed: () => Navigator.pop(context),
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
    return Row(
      key: ValueKey('palHelpersListModalContent'),
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
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
    );
  }

  Widget _buildHeader(
    final BuildContext context,
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
        SizedBox(
          height: 30.0,
          width: 30.0,
          child: FloatingActionButton(
            key: ValueKey('palHelpersListModalNew'),
            onPressed: () => Navigator.pushNamed(context, '/editor/new'),
            child: Icon(
              Icons.add,
              size: 18.0,
            ),
            shape: CircleBorder(),
          ),
        )
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
