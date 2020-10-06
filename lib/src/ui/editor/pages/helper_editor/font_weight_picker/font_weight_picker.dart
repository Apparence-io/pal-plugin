import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_weight_picker/font_weight_picker_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_weight_picker/font_weight_picker_viewmodel.dart';

abstract class FontWeightPickerView { }

class FontWeightPickerPage extends StatelessWidget implements FontWeightPickerView {
  FontWeightPickerPage({Key key});

  final _mvvmPageBuilder = MVVMPageBuilder<FontWeightPickerPresenter, FontWeightPickerModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => FontWeightPickerPresenter(
        this,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          key: ValueKey('FontWeightPicker'),
          appBar: AppBar(
            title: Text('FontWeightPickerPage'),
          ),
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final FontWeightPickerPresenter presenter,
    final FontWeightPickerModel model,
  ) {
    return Text('FontWeightPickerPage');
  }
}