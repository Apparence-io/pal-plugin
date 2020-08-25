import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/pages/editor/widgets/editor_button.dart';
import 'package:palplugin/src/ui/pages/editor/widgets/helpers_list.dart';


class EditorViewModel extends MVVMModel {
  bool enableSave;
}

abstract class EditorView {

}


class EditorPageBuilder implements EditorView {

  final mvvmPageBuilder = MVVMPageBuilder<EditorPresenter, EditorViewModel>();

  Widget build(BuildContext context) {
    return mvvmPageBuilder.build(
      key: ValueKey("EditorPage"),
      context: context,
      presenterBuilder: (context) => EditorPresenter(this),
      builder: (mContext, presenter, model) => _buildEditorPage(mContext.buildContext)
    );
  }

  _buildEditorPage(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shadowColor: Colors.transparent,
      child: Container(
        color: Colors.black.withOpacity(.2),
        child: Stack(
          children: [
            _buildAddButton(context),
            _buildValidationActions(context)
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton(BuildContext context) {
    return Positioned(
        bottom: 16,
        right: 16,
        child: EditorButton.editMode(
            PalTheme.of(context),
            () => _showHelperModal(context),
            key: ValueKey("editModeButton"),
        ),
      );
  }

  Widget _buildValidationActions(BuildContext context) {
    return Positioned(
      bottom: 32,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EditorButton.cancel(
            PalTheme.of(context),
            () => _showHelperModal(context),
            key: ValueKey("editModeCancel"),
          ),
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: EditorButton.validate(
              PalTheme.of(context),
              () => _showHelperModal(context),
              key: ValueKey("editModeValidate"),
            ),
          ),
        ],
      )
    );
  }

  _showHelperModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      useRootNavigator: true,
      isDismissible: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25),
          topRight: Radius.circular(25),
        ),
      ),
      backgroundColor: PalTheme.of(context).buildTheme().backgroundColor,
      builder: (context) => HelpersListMenu()
    );
  }

}


class EditorPresenter extends Presenter<EditorViewModel, EditorView> {

  EditorPresenter(EditorView viewInterface) : super(EditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
  }


}