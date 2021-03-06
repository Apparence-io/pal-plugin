import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_background.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_button.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_media.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_textfield.dart';
import 'package:pal/src/ui/editor/pages/media_gallery/media_gallery.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import '../../../../../../router.dart';
import 'editor_fullscreen_helper_presenter.dart';
import 'editor_fullscreen_helper_viewmodel.dart';

abstract class EditorFullScreenHelperView {
  Future<GraphicEntity?> pushToMediaGallery(final String? mediaId);

  TextStyle? googleCustomFont(String fontFamily);

  Future showLoadingScreen(ValueNotifier<SendingStatus> status);

  Future closeEditor(bool list, bool bubble);

  void closeLoadingScreen();

  Future showPreviewOfHelper(FullscreenHelperViewModel model);
}

class EditorFullScreenHelper
    with EditorSendingOverlayMixin, EditorNavigationMixin
    implements EditorFullScreenHelperView {
  BuildContext? context;

  final PalEditModeStateService palEditModeStateService;

  EditorSendingOverlay? sendingOverlay;

  EditorFullScreenHelper(this.context, this.palEditModeStateService) {
    overlayContext = context;
  }

  void closeColorPickerDialog() => closeOverlayed(OverlayKeys.PAGE_OVERLAY_KEY);

  @override
  Future<GraphicEntity?> pushToMediaGallery(final String? mediaId) async {
    final media = await Navigator.of(context!).pushNamed(
      '/editor/media-gallery',
      arguments: MediaGalleryPageArguments(
        mediaId,
      ),
    ) as GraphicEntity?;
    return media;
  }

  @override
  TextStyle? googleCustomFont(String fontFamily) {
    return (fontFamily != null && fontFamily.length > 0)
        ? GoogleFonts.getFont(fontFamily)
        : null;
  }

  @override
  Future showPreviewOfHelper(FullscreenHelperViewModel model) async {
    UserFullScreenHelperPage page = UserFullScreenHelperPage(
      group: GroupViewModel(index: 0, steps: 1),
      helperBoxViewModel:
          HelperSharedFactory.parseBoxNotifier(model.backgroundBoxForm!),
      titleLabel: HelperSharedFactory.parseTextNotifier(model.titleTextForm!),
      descriptionLabel:
          HelperSharedFactory.parseTextNotifier(model.descriptionTextForm!),
      headerImageViewModel:
          HelperSharedFactory.parseMediaNotifier(model.headerMediaForm!),
      negativLabel:
          HelperSharedFactory.parseButtonNotifier(model.negativButtonForm!),
      positivLabel:
          HelperSharedFactory.parseButtonNotifier(model.positivButtonForm!),
      onNegativButtonTap: () => Navigator.pop(context!),
      onPositivButtonTap: () => Navigator.pop(context!),
    );

    EditorPreviewArguments arguments = EditorPreviewArguments(
      (context) => Navigator.pop(context),
      preBuiltHelper: page,
    );
    await Navigator.pushNamed(
      context!,
      '/editor/preview',
      arguments: arguments,
    );
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
    Key? key,
    required this.presenterBuilder,
  }) : super(key: key);

  factory EditorFullScreenHelperPage.create(
          {Key? key,
          HelperEditorPageArguments? parameters,
          EditorHelperService? helperService,
          PalEditModeStateService? palEditModeStateService,
          required HelperViewModel helperViewModel}) =>
      EditorFullScreenHelperPage._(
        key: key,
        presenterBuilder: (context) => EditorFullScreenHelperPresenter(
            new EditorFullScreenHelper(
                context,
                palEditModeStateService ??
                    EditorInjector.of(context)!.palEditModeStateService),
            FullscreenHelperViewModel.fromHelperViewModel(helperViewModel),
            helperService ?? EditorInjector.of(context)!.helperService,
            parameters),
      );

  factory EditorFullScreenHelperPage.edit(
          {Key? key,
          HelperEditorPageArguments? parameters,
          EditorHelperService? helperService,
          PalEditModeStateService? palEditModeStateService,
          required String? helperId}) =>
      EditorFullScreenHelperPage._(
        key: key,
        presenterBuilder: (context) => EditorFullScreenHelperPresenter(
            new EditorFullScreenHelper(
                context,
                palEditModeStateService ??
                    EditorInjector.of(context)!.palEditModeStateService),
            FullscreenHelperViewModel(id: helperId),
            helperService ?? EditorInjector.of(context)!.helperService,
            parameters),
      );

  final MVVMPageBuilder builder = MVVMPageBuilder<
      EditorFullScreenHelperPresenter, FullscreenHelperViewModel>();

  @override
  Widget build(BuildContext context) {
    return builder.build(
      key: ValueKey('palEditorFullscreenHelperWidgetBuilder'),
      context: context,
      presenterBuilder: presenterBuilder,
      builder: (context, presenter, model) =>
          _buildPage(context.buildContext, presenter as EditorFullScreenHelperPresenter, model as FullscreenHelperViewModel),
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorFullScreenHelperPresenter presenter,
    final FullscreenHelperViewModel model,
  ) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      resizeToAvoidBottomInset: false,
      body: (model.loading ?? false)
          ? Center(child: CircularProgressIndicator(value: null))
          : EditorToolboxPage(
              boxViewHandler: BoxViewHandler(
                  callback: presenter.updateBackgroundColor,
                  selectedColor: model.backgroundBoxForm?.backgroundColor),
              onTextPickerDone: presenter.onTextPickerDone,
              onFontPickerDone: presenter.onFontPickerDone,
              onMediaPickerDone: presenter.onMediaPickerDone,
              onTextColorPickerDone: presenter.onTextColorPickerDone,
              currentEditableItemNotifier: model.currentEditableItemNotifier,
              onValidate: (model.canValidate?.value == true)
                  ? presenter.onValidate
                  : null,
              onPreview: presenter.onPreview,
              onCloseEditor: presenter.onCancel,
              child: AnimatedOpacity(
                duration: Duration(milliseconds: 500),
                curve: Curves.fastOutSlowIn,
                opacity: model.helperOpacity ?? 1.0,
                child: Form(
                  key: formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: EditableBackground(
                    backgroundColor: model.backgroundBoxForm!.backgroundColor,
                    widget: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: SafeArea(
                        bottom: false,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              flex: 0,
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  EditableButton(
                                    data: model.negativButtonForm,
                                    onTap: presenter.onNewEditableSelect,
                                    isSelected: model.currentEditableItemNotifier?.value?.key == model.negativButtonForm!.key,
                                    backgroundColor: model.backgroundBoxForm?.backgroundColor,
                                 ),
                                ]
                              ),
                            ),
                            Flexible(
                              flex: 2,
                              fit: FlexFit.tight,
                              child: Column(
                                children: [
                                  Flexible(
                                    flex: 1,
                                    fit: FlexFit.loose,
                                    child: EditableMedia(
                                      size: double.infinity,
                                      data: model.headerMediaForm,
                                      onTap: presenter.onNewEditableSelect,
                                      backgroundColor:
                                          model.backgroundBoxForm?.backgroundColor,
                                      isSelected: model.currentEditableItemNotifier
                                              ?.value?.key ==
                                          model.headerMediaForm!.key,
                                    ),
                                  ),
                                  SizedBox(height: 32),
                                  EditableTextField(
                                    data: model.titleTextForm,
                                    onTap: presenter.onNewEditableSelect,
                                    backgroundColor:
                                        model.backgroundBoxForm?.backgroundColor,
                                    isSelected: model.currentEditableItemNotifier
                                            ?.value?.key ==
                                        model.titleTextForm!.key,
                                  ),
                                  SizedBox(height: 8),
                                  EditableTextField(
                                    data: model.descriptionTextForm,
                                    onTap: presenter.onNewEditableSelect,
                                    backgroundColor:
                                        model.backgroundBoxForm?.backgroundColor,
                                    isSelected: model.currentEditableItemNotifier
                                            ?.value?.key ==
                                        model.descriptionTextForm!.key,
                                  ),
                                ],
                              ),
                            ),
                            Flexible(
                              flex: 0,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  SizedBox(height: 24),
                                  EditableButton(
                                    width: double.infinity,
                                    data: model.positivButtonForm,
                                    onTap: presenter.onNewEditableSelect,
                                    isSelected: model.currentEditableItemNotifier
                                            ?.value?.key ==
                                        model.positivButtonForm!.key,
                                    backgroundColor:
                                        model.backgroundBoxForm?.backgroundColor,
                                  ),
                                  SizedBox(height: 40),
                                ],
                              ),
                            )
                          ],
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
