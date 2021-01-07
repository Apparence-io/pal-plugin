import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/color_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_actionsbar/editor_actionsbar.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';
import 'package:pal/src/ui/editor/widgets/editable_textfield.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import '../../../../../../router.dart';
import 'editor_simple_helper_presenter.dart';
import 'editor_simple_helper_viewmodel.dart';

abstract class EditorSimpleHelperView {
  void showColorPickerDialog(SimpleHelperViewModel viewModel,
      OnColorSelected updateBackgroundColor, OnCancelPicker onCancelPicker);

  void closeColorPickerDialog();

  Future showLoadingScreen(ValueNotifier<SendingStatus> status);

  Future closeEditor();

  void closeLoadingScreen();
}

class EditorSimpleHelperPage extends StatelessWidget {
  final SimpleHelperViewModel baseviewModel;

  final HelperEditorPageArguments arguments;

  final EditorHelperService helperService;

  final PalEditModeStateService palEditModeStateService;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  EditorSimpleHelperPage._(
      {Key key,
      this.helperService,
      @required this.baseviewModel,
      @required this.arguments,
      this.palEditModeStateService})
      : super(key: key);

  factory EditorSimpleHelperPage.create(
          {Key key,
          HelperEditorPageArguments parameters,
          EditorHelperService helperService,
          PalEditModeStateService palEditModeStateService,
          @required HelperViewModel helperViewModel}) =>
      EditorSimpleHelperPage._(
        key: key,
        helperService: helperService,
        palEditModeStateService: palEditModeStateService,
        baseviewModel:
            SimpleHelperViewModel.fromHelperViewModel(helperViewModel),
        arguments: parameters,
      );

  factory EditorSimpleHelperPage.edit(
          {Key key,
          HelperEditorPageArguments parameters,
          EditorHelperService helperService,
          PalEditModeStateService palEditModeStateService,
          @required
              HelperEntity
                  helperEntity //FIXME should be an id and not entire entity
          }) =>
      EditorSimpleHelperPage._(
        key: key,
        helperService: helperService,
        palEditModeStateService: palEditModeStateService,
        baseviewModel: SimpleHelperViewModel.fromHelperEntity(helperEntity),
        arguments: parameters,
      );

  @override
  Widget build(BuildContext context) {
    return MVVMPageBuilder<EditorSimpleHelperPresenter, SimpleHelperViewModel>()
        .build(
      key: ValueKey('palEditorSimpleHelperWidgetBuilder'),
      context: context,
      presenterBuilder: (context) => EditorSimpleHelperPresenter(
          new _EditorSimpleHelperPage(
              context,
              _scaffoldKey,
              palEditModeStateService ??
                  EditorInjector.of(context).palEditModeStateService),
          baseviewModel,
          helperService ?? EditorInjector.of(context).helperService,
          arguments),
      builder: (context, presenter, model) =>
          _buildPage(context.buildContext, presenter, model),
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorSimpleHelperPresenter presenter,
    final SimpleHelperViewModel viewModel,
  ) {
    print(viewModel.canValidate);
    print(viewModel.canValidate?.value);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: EditorActionsBar(
        onCancel: presenter.onCancel,
        onValidate: (viewModel.canValidate?.value == true)
            ? presenter.onValidate
            : null,
        child: GestureDetector(
          key: ValueKey('palEditorSimpleHelperWidget'),
          onTap: presenter.onOutsideTap,
          child: LayoutBuilder(builder: (context, constraints) {
            return Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  SingleChildScrollView(
                    child: Container(
                      height: constraints.maxHeight,
                      width: constraints.maxWidth,
                      child: Column(
                        children: [
                          Expanded(child: Container()),
                          Container(
                            width: constraints.maxWidth * 0.8,
                            child: EditableTextField.text(
                              outsideTapStream:
                                  presenter.editableTextFieldController.stream,
                              helperToolbarKey: ValueKey(
                                  'palEditorSimpleHelperWidgetToolbar'),
                              textFormFieldKey:
                                  ValueKey('palSimpleHelperDetailField'),
                                  
                              onChanged: presenter.onDetailsFieldChanged,
                              onFieldSubmitted: presenter.onDetailsFieldSubmitted,
                              onTextStyleChanged:
                                  presenter.onDetailsTextStyleChanged,
                              maxLines: 3,
                              maximumCharacterLength: 150,
                              minimumCharacterLength: 1,
                              toolbarVisibility:
                                  viewModel?.detailsField?.toolbarVisibility,
                              fontFamilyKey:
                                  viewModel?.detailsField?.fontFamily?.value,
                              initialValue:
                                  viewModel?.detailsField?.text?.value,
                              inputFormatters: [
                                FilteringTextInputFormatter.allow(
                                  new RegExp('^(.*(\n.*){0,2})'),
                                ),
                              ],
                              backgroundBoxDecoration: BoxDecoration(
                                color: viewModel
                                        ?.bodyBox?.backgroundColor?.value ??
                                    PalTheme.of(context).colors.light,
                                borderRadius: BorderRadius.circular(6.0),
                              ),
                              backgroundPadding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom > 0
                                        ? MediaQuery.of(context)
                                                .viewInsets
                                                .bottom +
                                            20.0
                                        : 50.0 + MediaQuery.of(context).padding.bottom,
                              ),
                              textFormFieldPadding: const EdgeInsets.symmetric(
                                vertical: 16.0,
                                horizontal: 33.0,
                              ),
                              textStyle: TextStyle(
                                color: viewModel.detailsField?.fontColor?.value,
                                fontSize: viewModel
                                    .detailsField?.fontSize?.value
                                    ?.toDouble(),
                                fontWeight: FontWeightMapper.toFontWeight(
                                  viewModel.detailsField?.fontWeight?.value,
                                ),
                              ).merge(
                                _googleCustomFont(
                                  viewModel.detailsField?.fontFamily?.value,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    top: 20.0,
                    left: 20.0,
                    child: SafeArea(
                      child: CircleIconButton(
                        key: ValueKey(
                            'pal_EditorSimpleHelperWidget_CircleBackground'),
                        icon: Icon(Icons.invert_colors),
                        backgroundColor: PalTheme.of(context).colors.light,
                        onTapCallback: presenter.onChangeColorRequest,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  //TODO
  // maybe extension for this as it is used widely
  TextStyle _googleCustomFont(String fontFamily) {
    return (fontFamily != null && fontFamily.length > 0)
        ? GoogleFonts.getFont(fontFamily)
        : null;
  }
}

class _EditorSimpleHelperPage
    with EditorSendingOverlayMixin, EditorNavigationMixin
    implements EditorSimpleHelperView {
  final BuildContext context;

  final GlobalKey<ScaffoldState> scaffoldKey;

  final PalEditModeStateService palEditModeStateService;

  _EditorSimpleHelperPage(
      this.context, this.scaffoldKey, this.palEditModeStateService);

  BuildContext get overlayContext => context;

  @override
  void showColorPickerDialog(
      final SimpleHelperViewModel viewModel,
      final OnColorSelected updateBackgroundColor,
      final OnCancelPicker onCancelPicker) {
    HapticFeedback.selectionClick();
    showOverlayedInContext(
        (context) => ColorPickerDialog(
            placeholderColor: viewModel.bodyBox.backgroundColor?.value,
            onColorSelected: updateBackgroundColor,
            onCancel: onCancelPicker),
        key: OverlayKeys.PAGE_OVERLAY_KEY);
  }

  void closeColorPickerDialog() => closeOverlayed(OverlayKeys.PAGE_OVERLAY_KEY);
}
