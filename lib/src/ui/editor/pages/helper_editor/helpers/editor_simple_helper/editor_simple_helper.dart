import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/simple_helper.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/widget/simple_helper_layout.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_textfield.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import '../../../../../../router.dart';
import 'editor_simple_helper_presenter.dart';
import 'editor_simple_helper_viewmodel.dart';

abstract class EditorSimpleHelperView {
  // void showColorPickerDialog(SimpleHelperViewModel viewModel,
  //     OnColorSelected updateBackgroundColor, OnCancelPicker onCancelPicker);

  void closeColorPickerDialog();

  Future showLoadingScreen(ValueNotifier<SendingStatus> status);

  Future closeEditor();

  void closeLoadingScreen();

  Future showPreviewOfHelper(SimpleHelperViewModel model);
}

class EditorSimpleHelperPage extends StatelessWidget {
  final SimpleHelperViewModel baseviewModel;

  final HelperEditorPageArguments arguments;

  final EditorHelperService helperService;

  final PalEditModeStateService palEditModeStateService;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final GlobalKey _textKey = GlobalKey();

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
      key: UniqueKey(),
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: EditorToolboxPage(
        boxViewHandler: BoxViewHandler(
            callback: presenter.updateBackgroundColor,
            selectedColor: viewModel.bodyBox?.backgroundColor),
        currentEditableItemNotifier: viewModel.currentEditableItemNotifier,
        onTextPickerDone: presenter.onTextPickerDone,
        // onCancel: presenter.onCancel,
        onValidate: (viewModel.canValidate?.value == true)
            ? presenter.onValidate
            : null,
        onPreview: presenter.onPreview,
        onCloseEditor: presenter.onCancel,
        child: LayoutBuilder(builder: (context, constraints) {
          return Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // TODO: Blur background here
                SingleChildScrollView(
                  child: Container(
                    color: Colors.black38,
                    height: constraints.maxHeight,
                    width: constraints.maxWidth,
                    child: Column(
                      children: [
                        Expanded(child: Container()),
                        Padding(
                          padding: EdgeInsets.only(
                              bottom:
                                  MediaQuery.of(context).padding.bottom + 55),
                          child: Container(
                              width: constraints.maxWidth * 0.8,
                              decoration: BoxDecoration(
                                color: PalTheme.of(context).colors.black,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(12)),
                              ),
                              padding: EdgeInsets.all(15),
                              child: EditableTextField(
                                key: _textKey,
                                textNotifier: viewModel.detailsField,
                                currentEditableItemNotifier:
                                    viewModel.currentEditableItemNotifier,
                              )
                              // child: EditableTextField.text(
                              //   outsideTapStream:
                              //       presenter.editableTextFieldController.stream,
                              //   helperToolbarKey: ValueKey(
                              //       'palEditorSimpleHelperWidgetToolbar'),
                              //   textFormFieldKey:
                              //       ValueKey('palSimpleHelperDetailField'),
                              //   onChanged: presenter.onDetailsFieldChanged,
                              //   onFieldSubmitted:
                              //       presenter.onDetailsFieldSubmitted,
                              //   onTextStyleChanged:
                              //       presenter.onDetailsTextStyleChanged,
                              //   maxLines: 3,
                              //   maximumCharacterLength: 150,
                              //   minimumCharacterLength: 1,
                              //   // toolbarVisibility:
                              //   //     viewModel?.detailsField?.toolbarVisibility,
                              //   fontFamilyKey:
                              //       viewModel?.detailsField?.fontFamily?.value,
                              //   initialValue:
                              //       viewModel?.detailsField?.text?.value,
                              //   inputFormatters: [
                              //     FilteringTextInputFormatter.allow(
                              //       new RegExp('^(.*(\n.*){0,2})'),
                              //     ),
                              //   ],
                              //   backgroundBoxDecoration: BoxDecoration(
                              //     color: viewModel
                              //             ?.bodyBox?.backgroundColor?.value ??
                              //         PalTheme.of(context).colors.light,
                              //     borderRadius: BorderRadius.circular(6.0),
                              //   ),
                              //   backgroundPadding: EdgeInsets.only(
                              //     bottom: MediaQuery.of(context)
                              //                 .viewInsets
                              //                 .bottom >
                              //             0
                              //         ? MediaQuery.of(context).viewInsets.bottom +
                              //             20.0
                              //         : 50.0 +
                              //             MediaQuery.of(context).padding.bottom,
                              //   ),
                              //   textFormFieldPadding: const EdgeInsets.symmetric(
                              //     vertical: 16.0,
                              //     horizontal: 33.0,
                              //   ),
                              //   textStyle: TextStyle(
                              //     color: viewModel.detailsField?.fontColor?.value,
                              //     fontSize: viewModel
                              //         .detailsField?.fontSize?.value
                              //         ?.toDouble(),
                              //     fontWeight: FontWeightMapper.toFontWeight(
                              //       viewModel.detailsField?.fontWeight?.value,
                              //     ),
                              //   ).merge(
                              //     _googleCustomFont(
                              //       viewModel.detailsField?.fontFamily?.value,
                              //     ),
                              //   ),
                              // ),
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Positioned(
                //   top: 20.0,
                //   left: 20.0,
                //   child: SafeArea(
                //     child: CircleIconButton(
                //       key: ValueKey(
                //           'pal_EditorSimpleHelperWidget_CircleBackground'),
                //       icon: Icon(Icons.invert_colors),
                //       backgroundColor: PalTheme.of(context).colors.light,
                //       // onTapCallback: presenter.onChangeColorRequest,
                //     ),
                //   ),
                // ),
              ],
            ),
          );
        }),
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

  // @override
  // void showColorPickerDialog(
  //     final SimpleHelperViewModel viewModel,
  //     final OnColorSelected updateBackgroundColor,
  //     final OnCancelPicker onCancelPicker) {
  //   HapticFeedback.selectionClick();
  //   showOverlayedInContext(
  //       (context) => ColorPickerDialog(
  //           placeholderColor: viewModel.bodyBox.backgroundColor?.value,
  //           onColorSelected: updateBackgroundColor,
  //           onCancel: onCancelPicker),
  //       key: OverlayKeys.PAGE_OVERLAY_KEY);
  // }

  @override
  Future showPreviewOfHelper(SimpleHelperViewModel model) async {
    SimpleHelperPage page = SimpleHelperPage(
      helperBoxViewModel: HelperSharedFactory.parseBoxNotifier(model.bodyBox),
      descriptionLabel:
          HelperSharedFactory.parseTextNotifier(model.detailsField),
    );
    SimpleHelperLayout layout = SimpleHelperLayout(
      toaster: page,
      onDismissed: (res) => Navigator.of(context).pop(),
    );

    EditorPreviewArguments arguments = EditorPreviewArguments(
      previewHelper: layout,
    );
    await Navigator.pushNamed(
      context,
      '/editor/preview',
      arguments: arguments,
    );
  }

  void closeColorPickerDialog() => closeOverlayed(OverlayKeys.PAGE_OVERLAY_KEY);
}
