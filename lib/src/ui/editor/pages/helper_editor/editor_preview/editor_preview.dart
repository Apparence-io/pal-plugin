import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

import 'editor_preview_presenter.dart';
import 'editor_preview_viewmodel.dart';

class EditorPreviewArguments {
  final Widget previewHelper;

  EditorPreviewArguments({
    @required this.previewHelper,
  });
}

abstract class EditorPreviewView {}

class EditorPreviewPage extends StatelessWidget implements EditorPreviewView {
  final Widget previewHelper;

  EditorPreviewPage({
    Key key,
    @required this.previewHelper,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<EditorPreviewPresenter, EditorPreviewModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('EditorPreviewPage_Builder'),
      context: context,
      presenterBuilder: (context) => EditorPreviewPresenter(
        this,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorPreviewPresenter presenter,
    final EditorPreviewModel model,
  ) {
    return Stack(
      fit: StackFit.expand,
      children: [
        this.previewHelper,
      ],
    );
  }
}
