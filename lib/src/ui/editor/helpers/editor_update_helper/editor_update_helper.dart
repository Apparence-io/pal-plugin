import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper_presenter.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery.dart';
import 'package:pal/src/ui/editor/widgets/editable_background.dart';
import 'package:pal/src/ui/editor/widgets/editable_media.dart';
import 'package:pal/src/ui/editor/widgets/editable_textfield.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

abstract class EditorUpdateHelperView {
  void showColorPickerDialog(
    BuildContext context,
    EditorUpdateHelperPresenter presenter,
  );
  void scrollToBottomChangelogList(
    EditorUpdateHelperModel model,
  );
  Future<GraphicEntity> pushToMediaGallery(final String mediaId);

  void callOnFormChanged(EditorUpdateHelperModel model);
}

class EditorUpdateHelperPage extends StatelessWidget
    implements EditorUpdateHelperView {
  final UpdateHelperViewModel viewModel;
  final Function(bool) onFormChanged;

  EditorUpdateHelperPage({
    Key key,
    @required this.viewModel,
    this.onFormChanged,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<EditorUpdateHelperPresenter, EditorUpdateHelperModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('pal_EditorUpdateHelperWidget_Builder'),
      context: context,
      presenterBuilder: (context) => EditorUpdateHelperPresenter(
        this,
        viewModel,
      ),
      builder: (context, presenter, model) {
        return this._buildPage(context.buildContext, presenter, model);
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final EditorUpdateHelperModel model,
  ) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.transparent,
      body: GestureDetector(
        onTap: presenter.onOutsideTap,
        child: SafeArea(
          bottom: false,
          child: Padding(
            padding:
                EdgeInsets.only(bottom: (model.isKeyboardVisible ? 0.0 : 90.0)),
            child: Form(
              key: model.formKey,
              autovalidateMode: AutovalidateMode.always,
              onChanged: () {
                presenter.callonFormChanged();
              },
              child: EditableBackground(
                backgroundColor: viewModel.backgroundColor?.value,
                circleIconKey:
                    'pal_EditorUpdateHelperWidget_BackgroundColorPicker',
                onColorChange: () =>
                    presenter.changeBackgroundColor(context, presenter),
                widget: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: double.infinity,
                    color: viewModel.backgroundColor?.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Center(
                            child: SingleChildScrollView(
                              reverse: false,
                              controller: model.scrollController,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                  left: 10.0,
                                  right: 10.0,
                                  top: 25.0,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    EditableMedia(
                                      editKey:
                                          'pal_EditorUpdateHelperWidget_EditableMedia_EditButton',
                                      mediaSize: 123.0,
                                      onEdit: presenter.editMedia,
                                      url: viewModel.media?.url?.value,
                                    ),
                                    SizedBox(height: 40),
                                    _buildTitleField(context, presenter, model),
                                    SizedBox(height: 25.0),
                                    _buildChangelogFields(
                                        context, presenter, model),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                            bottom: 15.0,
                            left: 10.0,
                            right: 10.0,
                          ),
                          child: _buildThanksButton(context, presenter, model),
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
    );
  }

  _buildTitleField(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final EditorUpdateHelperModel model,
  ) {
    return EditableTextField.text(
      helperToolbarKey: ValueKey(
        'pal_EditorUpdateHelperWidget_TitleToolbar',
      ),
      textFormFieldKey: ValueKey(
        'pal_EditorUpdateHelperWidget_TitleField',
      ),
      hintText: viewModel.titleField?.hintText,
      onChanged: presenter.onTitleFieldChanged,
      onTextStyleChanged: presenter.onTitleTextStyleChanged,
      validator: presenter.validateTitleTextField,
      autovalidate: AutovalidateMode.disabled,
      maximumCharacterLength: 60,
      minimumCharacterLength: 1,
      outsideTapStream: model.editableTextFieldController.stream,
      textStyle: TextStyle(
        color: viewModel.titleField?.fontColor?.value,
        fontSize: viewModel.titleField?.fontSize?.value?.toDouble(),
        fontWeight: FontWeightMapper.toFontWeight(
            viewModel.titleField?.fontWeight?.value),
      ),
    );
  }

  _buildChangelogFields(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final EditorUpdateHelperModel model,
  ) {
    return Column(
      children: [
        Wrap(
          children: model.changelogsTextfieldWidgets,
          spacing: 5.0,
          runSpacing: 5.0,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 5.0, bottom: 16.0),
          child: CircleIconButton(
            key: ValueKey('pal_EditorUpdateHelperWidget_AddNote'),
            backgroundColor: Colors.transparent,
            icon: Icon(
              Icons.add,
              color: Colors.grey.withAlpha(170),
              size: 35.0,
            ),
            displayShadow: false,
            onTapCallback: () {
              HapticFeedback.selectionClick();
              presenter.addChangelogNote();
              this.scrollToBottomChangelogList(model);
            },
          ),
        ),
      ],
    );
  }

  _buildThanksButton(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final EditorUpdateHelperModel model,
  ) {
    return SizedBox(
      width: double.infinity,
      child: EditableTextField.text(
        helperToolbarKey: ValueKey(
          'pal_EditorUpdateHelperWidget_ThanksButtonToolbar',
        ),
        textFormFieldKey: ValueKey(
          'pal_EditorUpdateHelperWidget_ThanksButtonField',
        ),
        outsideTapStream: model.editableTextFieldController.stream,
        onChanged: presenter.onThanksFieldChanged,
        onTextStyleChanged: presenter.onThanksTextStyleFieldChanged,
        hintText: viewModel.thanksButton?.hintText,
        maximumCharacterLength: 25,
        backgroundBoxDecoration: BoxDecoration(
          color: PalTheme.of(context).colors.dark,
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: TextStyle(
          color: viewModel.thanksButton?.fontColor?.value ?? Colors.white,
          fontSize: viewModel.thanksButton?.fontSize?.value?.toDouble() ?? 22.0,
          fontWeight: FontWeightMapper.toFontWeight(
                viewModel.thanksButton?.fontWeight?.value,
              ) ??
              FontWeight.w400,
        ),
      ),
    );
  }

  @override
  void showColorPickerDialog(
    BuildContext context,
    EditorUpdateHelperPresenter presenter,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: context,
      child: ColorPickerDialog(
        placeholderColor: this.viewModel?.backgroundColor?.value,
        onColorSelected: presenter.updateBackgroundColor,
      ),
    );
  }

  @override
  Future<GraphicEntity> pushToMediaGallery(
    final String mediaId,
  ) async {
    final media = await Navigator.pushNamed(
      _scaffoldKey.currentContext,
      '/editor/media-gallery',
      arguments: MediaGalleryPageArguments(
        mediaId,
      ),
    ) as GraphicEntity;

    return media;
  }

  scrollToBottomChangelogList(
    EditorUpdateHelperModel model,
  ) {
    if (model.scrollController.hasClients) {
      model.scrollController.animateTo(
        model.scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  @override
  void callOnFormChanged(EditorUpdateHelperModel model) {
    if (onFormChanged != null) {
      onFormChanged(model.formKey?.currentState?.validate());
    }
  }
}
