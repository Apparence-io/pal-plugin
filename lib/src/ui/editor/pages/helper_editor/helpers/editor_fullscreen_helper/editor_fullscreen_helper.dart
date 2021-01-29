import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
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
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import '../../../../../../router.dart';
import 'editor_fullscreen_helper_presenter.dart';
import 'editor_fullscreen_helper_viewmodel.dart';

abstract class EditorFullScreenHelperView {
  Future<GraphicEntity> pushToMediaGallery(final String mediaId);

  TextStyle googleCustomFont(String fontFamily);

  Future showLoadingScreen(ValueNotifier<SendingStatus> status);

  Future closeEditor();

  void closeLoadingScreen();

  Future showPreviewOfHelper(FullscreenHelperViewModel model);
}

class EditorFullScreenHelper
    with EditorSendingOverlayMixin, EditorNavigationMixin
    implements EditorFullScreenHelperView {
  BuildContext context;

  final PalEditModeStateService palEditModeStateService;

  EditorSendingOverlay sendingOverlay;

  EditorFullScreenHelper(this.context, this.palEditModeStateService) {
    overlayContext = context;
  }

  void closeColorPickerDialog() => closeOverlayed(OverlayKeys.PAGE_OVERLAY_KEY);

  @override
  Future<GraphicEntity> pushToMediaGallery(final String mediaId) async {
    final media = await Navigator.of(context).pushNamed(
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
  Future showPreviewOfHelper(FullscreenHelperViewModel model) async {
    UserFullScreenHelperPage page = UserFullScreenHelperPage(
      helperBoxViewModel:
          HelperSharedFactory.parseBoxNotifier(model.backgroundBoxForm),
      titleLabel: HelperSharedFactory.parseTextNotifier(model.titleTextForm),
      headerImageViewModel:
          HelperSharedFactory.parseMediaNotifier(model.headerMediaForm),
      negativLabel:
          HelperSharedFactory.parseButtonNotifier(model.negativButtonForm),
      positivLabel:
          HelperSharedFactory.parseButtonNotifier(model.positivButtonForm),
      onNegativButtonTap: () => Navigator.pop(context),
      onPositivButtonTap: () => Navigator.pop(context),
    );

    EditorPreviewArguments arguments = EditorPreviewArguments(
      previewHelper: page,
    );
    await Navigator.pushNamed(
      context,
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
    Key key,
    @required this.presenterBuilder,
  }) : super(key: key);

  factory EditorFullScreenHelperPage.create(
          {Key key,
          HelperEditorPageArguments parameters,
          EditorHelperService helperService,
          PalEditModeStateService palEditModeStateService,
          @required HelperViewModel helperViewModel}) =>
      EditorFullScreenHelperPage._(
        key: key,
        presenterBuilder: (context) => EditorFullScreenHelperPresenter(
            new EditorFullScreenHelper(
                context,
                palEditModeStateService ??
                    EditorInjector.of(context).palEditModeStateService),
            FullscreenHelperViewModel.fromHelperViewModel(helperViewModel),
            helperService ?? EditorInjector.of(context).helperService,
            parameters),
      );

  factory EditorFullScreenHelperPage.edit(
          {Key key,
          HelperEditorPageArguments parameters,
          EditorHelperService helperService,
          PalEditModeStateService palEditModeStateService,
          @required
              HelperEntity
                  helperEntity //FIXME should be an id and not entire entity
          }) =>
      EditorFullScreenHelperPage._(
        key: key,
        presenterBuilder: (context) => EditorFullScreenHelperPresenter(
            new EditorFullScreenHelper(
                context,
                palEditModeStateService ??
                    EditorInjector.of(context).palEditModeStateService),
            FullscreenHelperViewModel.fromHelperEntity(helperEntity),
            helperService ?? EditorInjector.of(context).helperService,
            parameters),
      );

  @override
  Widget build(BuildContext context) {
    return MVVMPageBuilder<EditorFullScreenHelperPresenter,
            FullscreenHelperViewModel>()
        .build(
      key: ValueKey('palEditorFullscreenHelperWidgetBuilder'),
      context: context,
      presenterBuilder: presenterBuilder,
      builder: (context, presenter, model) =>
          _buildPage(context.buildContext, presenter, model),
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
      body: EditorToolboxPage(
        boxViewHandler: BoxViewHandler(
            callback: presenter.updateBackgroundColor,
            selectedColor: model.backgroundBoxForm?.backgroundColor),
        onTextPickerDone: presenter.onTextPickerDone,
        onFontPickerDone: presenter.onFontPickerDone,
        onMediaPickerDone: presenter.onMediaPickerDone,
        onTextColorPickerDone: presenter.onTextColorPickerDone,
        currentEditableItemNotifier: model.currentEditableItemNotifier,
        onValidate:
            (model.canValidate?.value == true) ? presenter.onValidate : null,
        onPreview: presenter.onPreview,
        onCloseEditor: presenter.onCancel,
        child: AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          curve: Curves.fastOutSlowIn,
          opacity: model.helperOpacity,
          child: Form(
            key: formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            child: EditableBackground(
              backgroundColor: model.backgroundBoxForm.backgroundColor,
              widget: Center(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: SafeArea(
                    bottom: false,
                    child: SingleChildScrollView(
                      padding: EdgeInsets.only(top: 25.0, bottom: 50.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          EditableMedia(
                            size: 150.0,
                            data: model.headerMediaForm,
                            onTap: presenter.onNewEditableSelect,
                          ),
                          SizedBox(height: 24),
                          EditableTextField(
                            data: model.titleTextForm,
                            onTap: presenter.onNewEditableSelect,
                          ),
                          SizedBox(height: 24),
                          EditableTextField(
                            data: model.descriptionTextForm,
                            onTap: presenter.onNewEditableSelect,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 40.0),
                          ),
                          EditableButton(
                            data: model.positivButtonForm,
                            onTap: presenter.onNewEditableSelect,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                          ),
                          EditableButton(
                            data: model.negativButtonForm,
                            onTap: presenter.onNewEditableSelect,
                          )
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
