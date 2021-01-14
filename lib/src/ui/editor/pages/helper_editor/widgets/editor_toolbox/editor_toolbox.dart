import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_action_bar/editor_action_bar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_save_floating_button.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/text_field_picker/dialog_editable_textfield.dart';

import 'editor_toolbox_presenter.dart';
import 'editor_toolbox_viewmodel.dart';

abstract class EditorToolboxView {
  Future<EditedTextData> openTextPicker();
  Future<EditedFontData> openFontPicker();
  Future<EditedColorData> openColorPicker();
  Future<EditedMediaData> openMediaPicker();
}

class EditorToolboxPage extends StatelessWidget implements EditorToolboxView {
  /// the editor helper
  final Widget child;
  // Save button function
  final Function onValidate;

  // Pickers
  final Function(EditedTextData) onTextPickerDone;
  final Function(EditedColorData) onTextColorPickerDone;
  final Function(EditedFontData) onFontPickerDone;
  final Function(EditedBorderData) onBorderPickerDone;
  final Function(EditedMediaData) onMediaPickerDone;

  final ValueNotifier<CurrentEditableItem> currentEditableItemNotifier;
  final GlobalKey scaffoldKey;

  EditorToolboxPage({
    Key key,
    @required this.child,
    @required this.currentEditableItemNotifier,
    this.scaffoldKey,
    this.onValidate,
    this.onBorderPickerDone,
    this.onFontPickerDone,
    this.onTextColorPickerDone,
    this.onTextPickerDone,
    this.onMediaPickerDone,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<EditorToolboxPresenter, EditorToolboxModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      // TODO: Update MVVM_Builder to get non unique key
      key: UniqueKey(),
      context: context,
      multipleAnimControllerBuilder: (ticker) => [
        AnimationController(
          vsync: ticker,
          duration: Duration(milliseconds: 500),
          value: 0,
          lowerBound: 0,
          upperBound: 1,
        ),
        AnimationController(
          vsync: ticker,
          duration: Duration(milliseconds: 5000),
          value: 1,
          lowerBound: 0,
          upperBound: 2,
        ),
      ],
      animListener: (context, presenter, model) {
        context.animationsControllers[0]
            .animateTo(model.animationTarget, curve: Curves.easeOut);
        if (model.animateIcons) {
          context.animationsControllers[1].value = 1;
          context.animationsControllers[1]
              .animateTo(0, curve: Curves.easeOutBack);
          model.animateIcons = false;
        }
      },
      presenterBuilder: (context) => EditorToolboxPresenter(
        this,
        currentEditableItemNotifier: currentEditableItemNotifier,
        onBorderPickerDone: onBorderPickerDone,
        onFontPickerDone: onFontPickerDone,
        onTextColorPickerDone: onTextColorPickerDone,
        onTextPickerDone: onTextPickerDone,
        onMediaPickerDone: onMediaPickerDone,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          key: _scaffoldKey,
          body: this._buildPage(context, presenter, model),
          extendBody: true,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton:
              model.isActionBarVisible && model.animationTarget == 1
                  ? EditorSaveFloatingButton(onTap: this.onValidate)
                  : null,
          bottomNavigationBar: model.isActionBarVisible
              ? EditorActionBar(
                  animation: context.animationsControllers[0],
                )
              : null,
        );
      },
    );
  }

  Widget _buildPage(
    final MvvmContext context,
    final EditorToolboxPresenter presenter,
    final EditorToolboxModel model,
  ) {
    return Stack(
      children: [
        // the editor helper
        GestureDetector(
          child: child,
          onTap: presenter.onOutsideTap,
        ),
        // vertical editor toolbar
        EditorToolBar(
          editableElementActions: model.editableElementActions,
          globalActions: model.globalActions,
          isBottomBarVisibleNotifier: model.isBottomVisible,
          drawerAnimation: context.animationsControllers[0],
          iconsAnimation: context.animationsControllers[1],
          onActionTap: presenter.openPicker,
          onGlobalActionTap: null,
        ),
      ],
    );
  }

  @override
  Future<EditedColorData> openColorPicker() {
    // showOverlayedInContext(
    //   (context) => ColorPickerDialog(
    //     placeholderColor: viewModel.bodyBox.backgroundColor?.value,
    //     onColorSelected: presenter.updateBackgroundColor,
    //     onCancel: presenter.cancelUpdateBackgroundColor,
    //   ),
    //   key: OverlayKeys.PAGE_OVERLAY_KEY,
    // );
  }

  @override
  Future<EditedFontData> openFontPicker() {
    // TODO: implement openFontPicker
    throw UnimplementedError();
  }

  @override
  Future<EditedTextData> openTextPicker() async {
    String newText = await showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) => EditableTextDialog(''),
    );

    return EditedTextData(
      this.currentEditableItemNotifier?.value?.itemKey,
      text: newText,
    );

    // return showOverlayedInContext(
    //   (context) => EditableTextDialog('Test'),
    //   key: OverlayKeys.PAGE_OVERLAY_KEY,
    // );
  }

  @override
  Future<EditedMediaData> openMediaPicker() {
    // TODO: implement openMediaPicker
    throw UnimplementedError();
  }
}
