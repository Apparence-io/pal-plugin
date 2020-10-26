import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/graphic_entity.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:palplugin/src/ui/editor/pages/media_gallery/media_gallery.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_background.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_media.dart';
import 'package:palplugin/src/ui/editor/widgets/editable_textfield.dart';

abstract class EditorFullScreenHelperView {
  void showColorPickerDialog(
    FullscreenHelperViewModel viewModel,
    EditorFullScreenHelperPresenter presenter,
  );
  Future<GraphicEntity> pushToMediaGallery(final String mediaId);
}

class EditorFullScreenHelper implements EditorFullScreenHelperView {
  BuildContext context;

  EditorFullScreenHelper(this.context);

  @override
  void showColorPickerDialog(
    FullscreenHelperViewModel viewModel,
    EditorFullScreenHelperPresenter presenter,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: this.context,
      child: ColorPickerDialog(
        placeholderColor: viewModel.backgroundColor?.value,
        onColorSelected: presenter.updateBackgroundColor,
      ),
    );
  }

  @override
  Future<GraphicEntity> pushToMediaGallery(final String mediaId) async {
    final media = await Navigator.pushNamed(
      this.context,
      '/editor/media-gallery',
      arguments: MediaGalleryPageArguments(
        mediaId,
      ),
    ) as GraphicEntity;

    return media;
  }
}

class EditorFullScreenHelperPage extends StatelessWidget {
  final FullscreenHelperViewModel viewModel;
  final Function(bool) onFormChanged;

  EditorFullScreenHelperPage({
    Key key,
    @required this.viewModel,
    this.onFormChanged,
  });

  final _mvvmPageBuilder = MVVMPageBuilder<EditorFullScreenHelperPresenter,
      EditorFullScreenHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('palEditorFullscreenHelperWidgetBuilder'),
      context: context,
      presenterBuilder: (context) => EditorFullScreenHelperPresenter(
        new EditorFullScreenHelper(context),
        viewModel,
      ),
      builder: (context, presenter, model) {
        return this._buildPage(context.buildContext, presenter, model);
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorFullScreenHelperPresenter presenter,
    final EditorFullScreenHelperModel model,
  ) {
    return Scaffold(
      resizeToAvoidBottomPadding: true,
      body: GestureDetector(
        key: ValueKey('palEditorFullscreenHelperWidget'),
        onTap: presenter.onOutsideTap,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          opacity: model.helperOpacity,
          child: Form(
            key: model.formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              if (onFormChanged != null) {
                onFormChanged(model.formKey?.currentState?.validate());
              }
            },
            child: SafeArea(
              child: EditableBackground(
                backgroundColor: viewModel.backgroundColor?.value,
                circleIconKey:
                    'pal_EditorFullScreenHelperPage_BackgroundColorPicker',
                onColorChange: () =>
                    presenter.changeBackgroundColor(viewModel, presenter),
                widget: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SingleChildScrollView(
                      padding: EdgeInsets.symmetric(vertical: 25.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EditableMedia(
                            mediaSize: 123.0,
                            onEdit: presenter.editMedia,
                            url: viewModel.media?.url?.value,
                            editKey:
                                'pal_EditorFullScreenHelperPage_EditableMedia_EditButton',
                          ),
                          SizedBox(height: 20),
                          EditableTextField.text(
                            outsideTapStream:
                                model.editableTextFieldController.stream,
                            helperToolbarKey: ValueKey(
                                'palEditorFullscreenHelperWidgetToolbar'),
                            textFormFieldKey:
                                ValueKey('palFullscreenHelperTitleField'),
                            onChanged: presenter.onTitleChanged,
                            maximumCharacterLength: 55,
                            minimumCharacterLength: 1,
                            maxLines: 3,
                            textStyle: TextStyle(
                              color: viewModel.titleField?.fontColor?.value,
                              decoration: TextDecoration.none,
                              fontSize: viewModel.titleField?.fontSize?.value
                                  ?.toDouble(),
                              fontWeight: FontWeightMapper.toFontWeight(
                                  viewModel.titleField?.fontWeight?.value),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 24.0),
                            child: InkWell(
                              key: ValueKey(
                                  'pal_EditorFullScreenHelper_ThanksButton'),
                              child: EditableTextField.text(
                                helperToolbarKey: ValueKey(
                                  'pal_EditorFullScreenHelper_ThanksButtonToolbar',
                                ),
                                textFormFieldKey: ValueKey(
                                  'pal_EditorFullScreenHelper_ThanksButtonField',
                                ),
                                outsideTapStream:
                                    model.editableTextFieldController.stream,
                                onChanged: presenter.onPositivTextChanged,
                                onTextStyleChanged:
                                    presenter.onPositivTextStyleChanged,
                                hintText:
                                    viewModel.positivButtonField?.hintText,
                                maximumCharacterLength: 25,
                                textStyle: TextStyle(
                                  color: viewModel
                                      .positivButtonField?.fontColor?.value,
                                  decoration: TextDecoration.underline,
                                  fontSize: viewModel
                                      .positivButtonField?.fontSize?.value
                                      ?.toDouble(),
                                  fontWeight: FontWeightMapper.toFontWeight(
                                    viewModel
                                        .positivButtonField?.fontWeight?.value,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 16.0),
                            child: InkWell(
                              key: ValueKey(
                                  'pal_EditorFullScreenHelper_NegativButton'),
                              child: EditableTextField.text(
                                helperToolbarKey: ValueKey(
                                  'pal_EditorFullScreenHelper_ThanksButtonToolbar',
                                ),
                                textFormFieldKey: ValueKey(
                                  'pal_EditorFullScreenHelper_ThanksButtonField',
                                ),
                                outsideTapStream:
                                    model.editableTextFieldController.stream,
                                onChanged: presenter.onPositivTextChanged,
                                onTextStyleChanged:
                                    presenter.onPositivTextStyleChanged,
                                hintText:
                                    viewModel.negativButtonField?.hintText,
                                maximumCharacterLength: 25,
                                textStyle: TextStyle(
                                  color: viewModel
                                      .negativButtonField?.fontColor?.value,
                                  decoration: TextDecoration.underline,
                                  fontSize: viewModel
                                      .negativButtonField?.fontSize?.value
                                      ?.toDouble(),
                                  fontWeight: FontWeightMapper.toFontWeight(
                                    viewModel
                                        .negativButtonField?.fontWeight?.value,
                                  ),
                                ),
                              ),

                              // Text(
                              //   "This is not helping",
                              //   style: TextStyle(
                              //     color: Colors.white,
                              //     fontSize: 13,
                              //     fontWeight: FontWeight.bold,
                              //   ),
                              //   textAlign: TextAlign.center,
                              // ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
