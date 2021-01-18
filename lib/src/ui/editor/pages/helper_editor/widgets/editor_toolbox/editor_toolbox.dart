import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_action_bar/editor_action_bar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_save_floating_button.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editor_tool_bar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/color_picker/color_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/dialog_editable_textfield.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery.dart';

import 'editor_toolbox_presenter.dart';
import 'editor_toolbox_viewmodel.dart';

abstract class EditorToolboxView {
  Future<String> openTextPicker(String currentText);
  Future<EditedFontModel> openFontPicker(
      String family, int size, String weight);
  Future<Color> openColorPicker(Color selectedColor);
  Future<GraphicEntity> openMediaPicker(String mediaId);
}

class EditorToolboxPage extends StatelessWidget implements EditorToolboxView {
  /// the editor helper
  final Widget child;
  // Save button function
  final Function onValidate;
  final Function onPreview;
  final Function onCloseEditor;
  final BoxViewHandler boxViewHandler;

  // Pickers
  final Function(String) onTextPickerDone;
  final Function(Color) onTextColorPickerDone;
  final Function(dynamic) onFontPickerDone;
  final Function(dynamic) onBorderPickerDone;
  final Function(dynamic) onMediaPickerDone;

  final ValueNotifier<EditableData> currentEditableItemNotifier;
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
    this.onPreview,
    this.onCloseEditor,
    @required this.boxViewHandler,
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
          duration: Duration(milliseconds: 1500),
          value: 0,
          lowerBound: 0,
          upperBound: 2,
        ),
      ],
      animListener: (context, presenter, model) {
        if (model.animateActionBar) {
          context.animationsControllers[0]
              .animateTo(model.animationTarget, curve: Curves.easeOut);
          model.animateActionBar = false;
        }
        if (model.animateIcons) {
          context.animationsControllers[1].value = 0;
          context.animationsControllers[1]
              .animateTo(1, curve: Curves.elasticOut);
          model.animateIcons = false;
        }
      },
      presenterBuilder: (context) => EditorToolboxPresenter(
        this,
        boxViewHandler: boxViewHandler,
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
          resizeToAvoidBottomInset: false,
          body: this._buildPage(context, presenter, model),
          extendBody: true,
          backgroundColor: Colors.transparent,
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton:
              model.isActionBarVisible && model.animationTarget == 1
                  ? EditorSaveFloatingButton(onTap: this.onValidate)
                  : null,
          bottomNavigationBar: model.isActionBarVisible
              ? EditorActionBar(
                  animation: context.animationsControllers[0],
                  iconsColor: Colors.white,
                  onPreview: onPreview,
                  onCancel: () => this.onCloseEditor?.call(),
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
          onGlobalActionTap: presenter.openGlobalPicker,
        ),
      ],
    );
  }

  @override
  Future<Color> openColorPicker(Color selectedColor) async {
    return await showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) => ColorPickerDialog(
        placeholderColor: selectedColor,
      ),
    );
  }

  @override
  Future<EditedFontModel> openFontPicker(
      String family, int size, String weight) async {
    TextStyle style = TextStyle(
        fontSize: size.toDouble(),
        fontWeight: FontWeightMapper.toFontWeight(weight));
    return await showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) => FontEditorDialogPage(
        actualTextStyle: style,
        fontFamilyKey: family,
      ),
    );
  }

  @override
  Future<String> openTextPicker(String currentText) async {
    return await showDialog(
      context: _scaffoldKey.currentContext,
      builder: (context) => EditableTextDialog(currentText),
    );
  }

  @override
  Future<GraphicEntity> openMediaPicker(String currentMediaId) async {
    GraphicEntity graphicEntity =
        await Navigator.of(_scaffoldKey.currentContext).pushNamed(
      '/editor/media-gallery',
      arguments: MediaGalleryPageArguments(
        currentMediaId,
      ),
    ) as GraphicEntity;

    return graphicEntity;
  }
}
