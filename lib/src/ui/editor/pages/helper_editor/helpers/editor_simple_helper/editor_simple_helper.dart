import 'package:flutter/material.dart';
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
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_textfield.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import '../../../../../../router.dart';
import 'editor_simple_helper_presenter.dart';
import 'editor_simple_helper_viewmodel.dart';

abstract class EditorSimpleHelperView {
  void closeColorPickerDialog();

  Future showLoadingScreen(ValueNotifier<SendingStatus> status);

  Future closeEditor(bool list, bool bubble);

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
          @required String helperId}) =>
      EditorSimpleHelperPage._(
        key: key,
        helperService: helperService,
        palEditModeStateService: palEditModeStateService,
        baseviewModel: SimpleHelperViewModel.fromHelperEntity(
            HelperEntity(id: helperId, helperTexts: [])),
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
              null,
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
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: true,
      body: viewModel.loading
          ? Center(child: CircularProgressIndicator(value: null))
          : EditorToolboxPage(
              // TODO : Helper background
              // boxViewHandler: BoxViewHandler(
              //     callback: presenter.updateBackgroundColor,
              //     selectedColor: viewModel.bodyBox?.backgroundColor
              //     ),
              currentEditableItemNotifier:
                  viewModel.currentSelectedEditableNotifier,
              // PICKER CALLBACK
              onTextPickerDone: presenter.onTextPickerDone,
              onFontPickerDone: presenter.onFontPickerDone,
              onTextColorPickerDone: presenter.onTextColorPickerDone,
              // ACTION BAR FUNCTIONS
              onValidate: (viewModel.canValidate?.value == true)
                  ? presenter.onValidate
                  : null,
              onPreview: presenter.onPreview,
              onCloseEditor: presenter.onCancel,

              child: LayoutBuilder(
                builder: (context, constraints) {
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
                                Expanded(
                                  child: Container(),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      bottom: MediaQuery.of(context)
                                              .padding
                                              .bottom +
                                          55),
                                  child: Container(
                                    width: constraints.maxWidth * 0.8,
                                    decoration: BoxDecoration(
                                      color: PalTheme.of(context).colors.black,
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(12),
                                      ),
                                    ),
                                    padding: EdgeInsets.all(15),
                                    child: EditableTextField(
                                      key: _textKey,
                                      data: viewModel.contentTextForm,
                                      onTap: presenter.onNewEditableSelect,
                                      isSelected: viewModel
                                              .contentTextForm?.key ==
                                          viewModel
                                              .currentSelectedEditableNotifier
                                              ?.value
                                              ?.key,
                                      backgroundColor: PalTheme.of(context)
                                          .colors
                                          .black, // Currently we can't change background
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
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
  Future showPreviewOfHelper(SimpleHelperViewModel model) async {
    SimpleHelperPage page = SimpleHelperPage(
      // helperBoxViewModel: HelperSharedFactory.parseBoxNotifier(model.bodyBox),
      descriptionLabel:
          HelperSharedFactory.parseTextNotifier(model.contentTextForm),
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
