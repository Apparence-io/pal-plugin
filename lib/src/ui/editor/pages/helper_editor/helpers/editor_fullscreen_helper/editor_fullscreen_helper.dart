import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_actionsbar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery.dart';
import 'package:pal/src/ui/editor/widgets/editable_background.dart';
import 'package:pal/src/ui/editor/widgets/editable_media.dart';
import 'package:pal/src/ui/editor/widgets/editable_textfield.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import 'editor_fullscreen_helper_presenter.dart';
import 'editor_fullscreen_helper_viewmodel.dart';

abstract class EditorFullScreenHelperView {

  void showColorPickerDialog(
    FullscreenHelperViewModel viewModel,
    EditorFullScreenHelperPresenter presenter,
  );

  Future<GraphicEntity> pushToMediaGallery(final String mediaId);

  TextStyle googleCustomFont(String fontFamily);

  Future showLoadingScreen(ValueNotifier<SendingStatus> status);

  Future closeEditor();

  void closeLoadingScreen();
}

class EditorFullScreenHelper with EditorSendingOverlayMixin implements EditorFullScreenHelperView {

  BuildContext context;

  final PalEditModeStateService palEditModeStateService;

  EditorSendingOverlay sendingOverlay;

  EditorFullScreenHelper(this.context, this.palEditModeStateService){
    overlayContext = context;
  }

  @override
  void showColorPickerDialog(
    FullscreenHelperViewModel viewModel,
    EditorFullScreenHelperPresenter presenter,
  ) {
    HapticFeedback.selectionClick();
    showDialog(
      context: this.context,
      child: ColorPickerDialog(
        placeholderColor: viewModel.bodyBox.backgroundColor?.value,
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

  @override
  TextStyle googleCustomFont(String fontFamily) {
    return (fontFamily != null && fontFamily.length > 0)
        ? GoogleFonts.getFont(fontFamily)
        : null;
  }

  @override
  closeEditor() async {
    Overlayed.removeOverlay(context, OverlayKeys.EDITOR_OVERLAY_KEY,);
    palEditModeStateService.showBubble(context, true);
    palEditModeStateService.showHelpersList(context);
  }
}

typedef OnFormChanged(bool isValid);

/// [EditorFullScreenHelperPage]
/// can be created from entity or nothing
/// use [EditorHelperService] to create a fullscreen helper
class EditorFullScreenHelperPage extends StatelessWidget {

  final PresenterBuilder<EditorFullScreenHelperPresenter> presenterBuilder;

  final GlobalKey<FormState> formKey = GlobalKey();

  EditorFullScreenHelperPage._({
    Key key,
    @required this.presenterBuilder,
  }) : super(key: key);

  factory EditorFullScreenHelperPage.create({
    Key key,
    HelperEditorPageArguments parameters,
    EditorHelperService helperService,
    PalEditModeStateService palEditModeStateService,
    @required HelperViewModel helperViewModel
  }) => EditorFullScreenHelperPage._(
    key: key,
    presenterBuilder: (context) => EditorFullScreenHelperPresenter(
      new EditorFullScreenHelper(
        context,
        palEditModeStateService ?? EditorInjector.of(context).palEditModeStateService),
      FullscreenHelperViewModel.fromHelperViewModel(helperViewModel),
      helperService ?? EditorInjector.of(context).helperService,
      parameters
    ),
  );

  factory EditorFullScreenHelperPage.edit({
    Key key,
    HelperEditorPageArguments parameters,
    EditorHelperService helperService,
    PalEditModeStateService palEditModeStateService,
    @required HelperEntity helperEntity //FIXME should be an id and not entire entity
  }) => EditorFullScreenHelperPage._(
    key: key,
    presenterBuilder: (context)
    => EditorFullScreenHelperPresenter(
      new EditorFullScreenHelper(
        context,
        palEditModeStateService ?? EditorInjector.of(context).palEditModeStateService),
      FullscreenHelperViewModel.fromHelperEntity(helperEntity),
      helperService ?? EditorInjector.of(context).helperService,
      parameters
    ),
  );

  @override
  Widget build(BuildContext context) {
    return MVVMPageBuilder<EditorFullScreenHelperPresenter, FullscreenHelperViewModel>()
      .build(
        key: ValueKey('palEditorFullscreenHelperWidgetBuilder'),
        context: context,
        presenterBuilder: presenterBuilder,
        builder: (context, presenter, model) => _buildPage(context.buildContext, presenter, model),
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorFullScreenHelperPresenter presenter,
    final FullscreenHelperViewModel model,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomPadding: true,
      body: EditorActionsBar(
        canValidate: model.canValidate,
        onCancel: presenter.onCancel,
        onValidate: presenter.onValidate,
        child: GestureDetector(
          key: ValueKey('palEditorFullscreenHelperWidget'),
          onTap: presenter.onOutsideTap,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            curve: Curves.fastOutSlowIn,
            opacity: model.helperOpacity,
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: EditableBackground(
                backgroundColor: model.bodyBox.backgroundColor?.value,
                circleIconKey: 'pal_EditorFullScreenHelperPage_BackgroundColorPicker',
                onColorChange: () => presenter.changeBackgroundColor(),
                widget: Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: SafeArea(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(top: 25.0, bottom: 32.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            EditableMedia(
                              mediaSize: 240.0,
                              onEdit: presenter.editMedia,
                              url: model.media?.url?.value,
                              editKey: 'pal_EditorFullScreenHelperPage_EditableMedia_EditButton',
                            ),
                            SizedBox(height: 24),
                            editableField(
                              model.editableTextFieldController.stream,
                              model?.titleField,
                              presenter.onTitleChanged,
                              presenter.onTitleTextStyleChanged,
                              baseStyle: presenter.googleCustomFont(model?.titleField?.fontFamily?.value),
                              helperToolbarKey:  ValueKey('palEditorFullscreenHelperWidgetToolbar'),
                              textFormFieldKey: ValueKey('palFullscreenHelperTitleField'),
                            ),
                            SizedBox(height: 24),
                            editableField(
                              model.editableTextFieldController.stream,
                              model?.descriptionField,
                              presenter.onDescriptionChanged,
                              presenter.onDescriptionTextStyleChanged,
                              baseStyle: presenter.googleCustomFont(model?.titleField?.fontFamily?.value),
                              helperToolbarKey:  ValueKey('palEditorFullscreenHelperWidgetToolbar'),
                              textFormFieldKey: ValueKey('palFullscreenHelperDescriptionField'),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 40.0),
                              child: editableButton(
                                model.editableTextFieldController.stream,
                                model.positivButtonField,
                                presenter.onPositivTextChanged,
                                presenter.onPositivTextStyleChanged
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 12.0),
                              child: editableButton(
                                model.editableTextFieldController.stream,
                                model.negativButtonField,
                                presenter.onNegativTextChanged,
                                presenter.onNegativTextStyleChanged
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
      ),
    );
  }

  EditableTextField editableField(
      Stream<bool> outsideTapStream,
      TextFormFieldNotifier textNotifier,
      OnFieldChanged onFieldValueChange,
      OnTextStyleChanged onTextStyleChanged,
      { Key helperToolbarKey,
        Key textFormFieldKey,
        TextStyle baseStyle,
        int minimumCharacterLength = 1,
        int maximumCharacterLength = 255,
        int maxLines = 5,
        BoxDecoration backgroundDecoration})
  => EditableTextField.text(
      backgroundBoxDecoration: backgroundDecoration,
      outsideTapStream: outsideTapStream,
      helperToolbarKey: helperToolbarKey,
      textFormFieldKey: textFormFieldKey,
      onChanged: onFieldValueChange,
      onTextStyleChanged: onTextStyleChanged,
      maximumCharacterLength: maximumCharacterLength,
      minimumCharacterLength: minimumCharacterLength,
      maxLines: maxLines,
      fontFamilyKey: textNotifier?.fontFamily?.value,
      initialValue: textNotifier?.text?.value,
      textStyle: TextStyle(
          color: textNotifier?.fontColor?.value,
          decoration: TextDecoration.none,
          fontSize: textNotifier?.fontSize?.value?.toDouble(),
          fontWeight: FontWeightMapper.toFontWeight(textNotifier?.fontWeight?.value),
        )
        .merge(baseStyle),
    );


  Widget editableButton(
    Stream<bool> outsideTapStream,
    TextFormFieldNotifier textNotifier,
    OnFieldChanged onFieldValueChange,
    OnTextStyleChanged onTextStyleChanged,
    { int minimumCharacterLength = 1,
      int maximumCharacterLength = 255,
      int maxLines = 1})
  =>  InkWell(
        child: editableField(
          outsideTapStream,
          textNotifier,
          onFieldValueChange,
          onTextStyleChanged,
          minimumCharacterLength: minimumCharacterLength,
          maximumCharacterLength: maximumCharacterLength,
          maxLines: maxLines,
          backgroundDecoration: BoxDecoration(
            border: Border.all(
              color: Colors.white,
              width: 2
            ),
            // color: Colors.redAccent.withOpacity(0.8),
            borderRadius: BorderRadius.circular(10.0),
        )
      ),
  );

}
