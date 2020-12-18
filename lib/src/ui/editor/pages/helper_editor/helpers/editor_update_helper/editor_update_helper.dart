import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/theme.dart';
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
import 'package:pal/src/ui/shared/widgets/circle_button.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import '../../../../../../router.dart';
import 'editor_update_helper_presenter.dart';
import 'editor_update_helper_viewmodel.dart';

abstract class EditorUpdateHelperView {

  void showColorPickerDialog(Color color, OnColorSelected onColorSelected, OnCancelPicker onCancel);

  void closeColorPickerDialog();

  void hidePalBubble();

  Future<void> scrollToBottomChangelogList();

  Future<GraphicEntity> pushToMediaGallery(final String mediaId);

  Future showLoadingScreen(ValueNotifier<SendingStatus> status);

  Future closeEditor();

  void closeLoadingScreen();

}

class EditorUpdateHelperPage extends StatelessWidget {

  // required params
  final UpdateHelperViewModel baseviewModel;
  final HelperEditorPageArguments arguments;
  final EditorHelperService helperService;
  final PalEditModeStateService palEditModeStateService;

  // inner page widgets
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final ScrollController scrollController = ScrollController();

  EditorUpdateHelperPage._({
    Key key,
    this.helperService,
    this.palEditModeStateService,
    @required this.baseviewModel,
    @required this.arguments,
  }) : super(key: key);

  factory EditorUpdateHelperPage.create({
    Key key,
    HelperEditorPageArguments parameters,
    EditorHelperService helperService,
    PalEditModeStateService palEditModeStateService,
    @required HelperViewModel helperViewModel
  }) => EditorUpdateHelperPage._(
    key: key,
    helperService: helperService,
    palEditModeStateService: palEditModeStateService,
    baseviewModel: UpdateHelperViewModel.fromHelperViewModel(helperViewModel),
    arguments: parameters,
  );

  factory EditorUpdateHelperPage.edit({
    Key key,
    HelperEditorPageArguments parameters,
    PalEditModeStateService palEditModeStateService,
    EditorHelperService helperService,
    @required HelperEntity helperEntity //FIXME should be an id and not entire entity
  }) => EditorUpdateHelperPage._(
    key: key,
    helperService: helperService,
    palEditModeStateService: palEditModeStateService,
    baseviewModel: UpdateHelperViewModel.fromHelperEntity(helperEntity),
    arguments: parameters,
  );


  @override
  Widget build(BuildContext context) {
    return MVVMPageBuilder<EditorUpdateHelperPresenter, UpdateHelperViewModel>().build(
      key: ValueKey('pal_EditorUpdateHelperWidget_Builder'),
      context: context,
      presenterBuilder: (context) {
        var presenter = EditorUpdateHelperPresenter(
          _EditorUpdateHelperPage(
            context, _scaffoldKey, scrollController,
            palEditModeStateService ?? EditorInjector.of(context).palEditModeStateService
          ),
          baseviewModel,
          helperService ?? EditorInjector.of(context).helperService,
          arguments
        );
        KeyboardVisibilityNotification()
          .addNewListener(onChange: presenter.onKeyboardVisibilityChange);
        return presenter;
      },
      builder: (context, presenter, model) => this._buildPage(context.buildContext, presenter, model),
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final UpdateHelperViewModel viewModel,
  ) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.transparent,
      body: EditorActionsBar(
        onCancel: presenter.onCancel,
        onValidate: presenter.onValidate,
        canValidate: viewModel.canValidate,
        child: GestureDetector(
          onTap: presenter.onOutsideTap,
          child: SafeArea(
            bottom: false,
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.always,
              child: EditableBackground(
                backgroundColor: viewModel.bodyBox?.backgroundColor?.value,
                circleIconKey: 'pal_EditorUpdateHelperWidget_BackgroundColorPicker',
                onColorChange: presenter.changeBackgroundColor,
                widget: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    width: double.infinity,
                    color: viewModel.bodyBox?.backgroundColor?.value,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: _buildEditableContent(presenter, viewModel, context),
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

  List<Widget> _buildEditableContent(
    final EditorUpdateHelperPresenter presenter,
    final UpdateHelperViewModel viewModel,
    final BuildContext context)
    => [
      Expanded(
        child: Center(
          child: SingleChildScrollView(
            reverse: false,
            controller: scrollController,
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
                    editKey: 'pal_EditorUpdateHelperWidget_EditableMedia_EditButton',
                    mediaSize: 123.0,
                    onEdit: presenter.editMedia,
                    url: viewModel.media?.url?.value,
                  ),
                  SizedBox(height: 40),
                  EditableTextField.fromNotifier(
                    presenter.editableTextFieldController.stream, 
                    viewModel.titleField, 
                    presenter.onTitleFieldChanged, 
                    presenter.onTitleTextStyleChanged
                  ),
                  SizedBox(height: 25.0),
                  _buildChangelogFields(context, presenter, viewModel),
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
        child: _buildThanksButton(context, presenter, viewModel),
      ),
    ];

  Widget _buildChangelogFields(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final UpdateHelperViewModel viewmodel,
  ) {
    List<Widget> changelogsTextfieldWidgets = List();
    viewmodel.changelogsFields.forEach((key, field) {
      changelogsTextfieldWidgets.add(
        EditableTextField.fromNotifier(
          presenter.editableTextFieldController.stream,
          field,
          presenter.onChangelogTextChanged,
          presenter.onChangelogTextStyleFieldChanged,
          id: key,
        )
      );
    });
    return Column(
      children: [
        Wrap(
          children: changelogsTextfieldWidgets,
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
              color: Colors.white.withAlpha(170),
              size: 35.0,
            ),
            displayShadow: false,
            onTapCallback: () {
              HapticFeedback.selectionClick();
              presenter.addChangelogNote();
            },
          ),
        ),
      ],
    );
  }

  Widget _buildThanksButton(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final UpdateHelperViewModel viewModel,
  ) {
    return SizedBox(
      width: double.infinity,
      child: EditableTextField.text(
        helperToolbarKey: ValueKey('pal_EditorUpdateHelperWidget_ThanksButtonToolbar',),
        textFormFieldKey: ValueKey('pal_EditorUpdateHelperWidget_ThanksButtonField',),
        outsideTapStream: presenter.editableTextFieldController.stream,
        onChanged: presenter.onThanksFieldChanged,
        onTextStyleChanged: presenter.onThanksTextStyleFieldChanged,
        hintText: viewModel.thanksButton?.hintText,
        maximumCharacterLength: 25,
        toolbarVisibility: viewModel?.thanksButton?.toolbarVisibility,
        fontFamilyKey: viewModel?.thanksButton?.fontFamily?.value,
        initialValue: viewModel?.thanksButton?.text?.value,
        backgroundBoxDecoration: BoxDecoration(
          color: PalTheme.of(context).colors.dark,
          borderRadius: BorderRadius.circular(10.0),
        ),
        textStyle: TextStyle(
          color: viewModel.thanksButton?.fontColor?.value ?? Colors.white,
          fontSize: viewModel.thanksButton?.fontSize?.value?.toDouble() ?? 22.0,
          fontWeight: FontWeightMapper.toFontWeight(viewModel.thanksButton?.fontWeight?.value) ?? FontWeight.w400,
        ).merge(googleCustomFont(viewModel.thanksButton?.fontFamily?.value)),
      ),
    );
  }

  EditableTextField editableField(
    Stream<bool> outsideTapStream,
    TextFormFieldNotifier textNotifier,
    OnFieldChanged onFieldValueChange,
    OnTextStyleChanged onTextStyleChanged,
    { String id,
      Key helperToolbarKey,
      Key textFormFieldKey,
      TextStyle baseStyle,
      int minimumCharacterLength = 1,
      int maximumCharacterLength = 255,
      int maxLines = 5,
      BoxDecoration backgroundDecoration})
  => EditableTextField.text(
    id: id,
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


  //FIXME CONsider extension
  TextStyle googleCustomFont(String fontFamily) {
    return (fontFamily != null && fontFamily.length > 0)
        ? GoogleFonts.getFont(fontFamily)
        : null;
  }
}

class _EditorUpdateHelperPage with EditorSendingOverlayMixin, EditorNavigationMixin implements EditorUpdateHelperView {

  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ScrollController scrollController;
  final PalEditModeStateService palEditModeStateService;

  _EditorUpdateHelperPage(this.context, this.scaffoldKey, this.scrollController, this.palEditModeStateService);

  BuildContext get overlayContext => context;

  @override
  void showColorPickerDialog(Color color, OnColorSelected onColorSelected, OnCancelPicker onCancel) {
    HapticFeedback.selectionClick();
    showOverlayedInContext(
      (context) => ColorPickerDialog(
        placeholderColor: color,
        onColorSelected: onColorSelected,
        onCancel: onCancel
      ),
      key: OverlayKeys.PAGE_OVERLAY_KEY
    );
  }

  @override
  void closeColorPickerDialog() => closeOverlayed(OverlayKeys.PAGE_OVERLAY_KEY);

  @override
  Future<GraphicEntity> pushToMediaGallery(final String mediaId) async {
    final media = await Navigator.pushNamed(
      scaffoldKey.currentContext,
      '/editor/media-gallery',
      arguments: MediaGalleryPageArguments(
        mediaId,
      ),
    ) as GraphicEntity;
    return media;
  }

  Future scrollToBottomChangelogList() async {
    if (scrollController.hasClients) {
      await scrollController.animateTo(
        scrollController.position.maxScrollExtent,
        curve: Curves.easeOut,
        duration: const Duration(milliseconds: 500),
      );
    }
  }

  @override
  void hidePalBubble() => this.palEditModeStateService.showBubble(context, false);

}