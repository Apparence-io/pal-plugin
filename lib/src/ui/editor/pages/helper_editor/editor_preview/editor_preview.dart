import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/ui/client/helper_factory.dart';

import 'editor_preview_presenter.dart';
import 'editor_preview_viewmodel.dart';

class EditorPreviewArguments {
  final String? helperId;
  final Widget? preBuiltHelper;
  final Function(BuildContext) onDismiss;

  EditorPreviewArguments(
    this.onDismiss, {
    this.preBuiltHelper,
    this.helperId,
  });
}

abstract class EditorPreviewView {}

class EditorPreviewPage extends StatelessWidget implements EditorPreviewView {
  final EditorPreviewArguments? args;

  EditorPreviewPage({
    Key? key,
    required this.args,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<EditorPreviewPresenter, EditorPreviewModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('EditorPreviewPage_Builder'),
      context: context,
      presenterBuilder: (context) => EditorPreviewPresenter(this,
          args: this.args!,
          helperService: EditorInjector.of(context)!.helperService),
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
    return model.loading
        ? Center(child: CircularProgressIndicator(value: null))
        : Stack(
            fit: StackFit.expand,
            children: [
              getHelper(context, model)!,
            ],
          );
  }

  Widget? getHelper(BuildContext context, EditorPreviewModel viewModel) {
    if (viewModel.preBuiltHelper != null)
      return viewModel.preBuiltHelper;
    // PARSING AND CREATING HELPER ENTITY
    return HelperFactory.build(
      viewModel.helperEntity!,
      onTrigger: (_) async {
        viewModel.onDismiss(context);
      },
      onError: (_) async {
        viewModel.onDismiss(context);
      });
  }

}
