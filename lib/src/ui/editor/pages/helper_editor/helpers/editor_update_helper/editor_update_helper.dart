import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/graphic_entity.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/user_update_helper.dart';
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
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

import 'editor_update_helper_presenter.dart';
import 'editor_update_helper_viewmodel.dart';

abstract class EditorUpdateHelperView {
  void hidePalBubble();
  Future<void> scrollToBottomChangelogList();
  Future<GraphicEntity> pushToMediaGallery(final String mediaId);
  Future showLoadingScreen(ValueNotifier<SendingStatus> status);
  Future closeEditor();
  void closeLoadingScreen();
  Future showPreviewOfHelper(UpdateHelperViewModel model);
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
  final PackageVersionReader packageVersionReader;

  // final GlobalKey _titleKey = GlobalKey();
  // final GlobalKey _thanksButtonKey = GlobalKey();

  EditorUpdateHelperPage._({
    Key key,
    this.helperService,
    this.palEditModeStateService,
    this.packageVersionReader,
    @required this.baseviewModel,
    @required this.arguments,
  }) : super(key: key);

  factory EditorUpdateHelperPage.create(
          {Key key,
          HelperEditorPageArguments parameters,
          EditorHelperService helperService,
          PalEditModeStateService palEditModeStateService,
          PackageVersionReader packageVersionReader,
          @required HelperViewModel helperViewModel}) =>
      EditorUpdateHelperPage._(
        key: key,
        helperService: helperService,
        palEditModeStateService: palEditModeStateService,
        baseviewModel:
            UpdateHelperViewModel.fromHelperViewModel(helperViewModel),
        arguments: parameters,
        packageVersionReader: packageVersionReader,
      );

  factory EditorUpdateHelperPage.edit(
          {Key key,
          HelperEditorPageArguments parameters,
          PalEditModeStateService palEditModeStateService,
          EditorHelperService helperService,
          PackageVersionReader packageVersionReader,
          @required
              HelperEntity
                  helperEntity //FIXME should be an id and not entire entity
          }) =>
      EditorUpdateHelperPage._(
        key: key,
        helperService: helperService,
        palEditModeStateService: palEditModeStateService,
        baseviewModel: UpdateHelperViewModel.fromHelperEntity(helperEntity),
        arguments: parameters,
        packageVersionReader: packageVersionReader,
      );

  @override
  Widget build(BuildContext context) {
    return MVVMPageBuilder<EditorUpdateHelperPresenter, UpdateHelperViewModel>()
        .build(
      context: context,
      presenterBuilder: (context) {
        var presenter = EditorUpdateHelperPresenter(
          _EditorUpdateHelperPage(
              context,
              _scaffoldKey,
              scrollController,
              palEditModeStateService ??
                  EditorInjector.of(context).palEditModeStateService,
              packageVersionReader ??
                  EditorInjector.of(context).packageVersionReader),
          baseviewModel,
          helperService ?? EditorInjector.of(context).helperService,
          arguments,
        );
        KeyboardVisibilityNotification()
            .addNewListener(onChange: presenter.onKeyboardVisibilityChange);
        return presenter;
      },
      builder: (context, presenter, model) =>
          this._buildPage(context.buildContext, presenter, model),
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final UpdateHelperViewModel viewModel,
  ) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: true,
      backgroundColor: Colors.transparent,
      body: EditorToolboxPage(
        boxViewHandler: BoxViewHandler(
          callback: presenter.updateBackgroundColor,
          selectedColor: viewModel.backgroundBoxForm?.backgroundColor,
        ),
        onValidate: (viewModel.canValidate?.value == true)
            ? presenter.onValidate
            : null,
        currentEditableItemNotifier: viewModel.currentEditableItemNotifier,
        onTextPickerDone: presenter.onTextPickerDone,
        onFontPickerDone: presenter.onFontPickerDone,
        onMediaPickerDone: presenter.onMediaPickerDone,
        onTextColorPickerDone: presenter.onTextColorPickerDone,
        onCloseEditor: presenter.onCancel,
        onPreview: presenter.onPreview,
        child: Form(
          key: formKey,
          autovalidateMode: AutovalidateMode.always,
          child: EditableBackground(
            backgroundColor: viewModel.backgroundBoxForm?.backgroundColor,
            widget: Padding(
              padding: const EdgeInsets.all(2.0),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:
                      _buildEditableContent(presenter, viewModel, context),
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
          final BuildContext context) =>
      [
        Expanded(
          child: SafeArea(
            bottom: false,
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
                      // FIXME: This is a POC, Need to wrap all editable item to
                      // gesture detector & change notifier value
                      EditableMedia(
                        key: ValueKey(
                            'pal_EditorUpdateHelperWidget_EditableMedia'),
                        size: 123.0,
                        data: viewModel.headerMediaForm,
                        onTap: presenter.onNewEditableSelect,
                      ),
                      SizedBox(height: 40),
                      EditableTextField(
                        data: viewModel.titleTextForm,
                        onTap: presenter.onNewEditableSelect,
                      ),
                      SizedBox(height: 25.0),
                      _buildChangelogFields(context, presenter, viewModel),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            bottom: 45.0,
            left: 10.0,
            right: 10.0,
            top: 5.0,
          ),
          child: _buildThanksButton(context, presenter, viewModel),
        ),
      ];

  Widget _buildChangelogFields(
    final BuildContext context,
    final EditorUpdateHelperPresenter presenter,
    final UpdateHelperViewModel viewmodel,
  ) {
    List<Widget> changelogsTextfieldWidgets = [];
    viewmodel.changelogsTextsForm.forEach((key, field) {
      changelogsTextfieldWidgets.add(EditableTextField(
        data: field,
        key: ValueKey(key),
        onTap: presenter.onNewEditableSelect,
      ));
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
            onTapCallback: presenter.addChangelogNote,
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
      child: EditableButton(
        data: viewModel.positivButtonForm,
        onTap: presenter.onNewEditableSelect,
      ),
    );
  }

  //FIXME CONsider extension
  TextStyle googleCustomFont(String fontFamily) {
    return (fontFamily != null && fontFamily.length > 0)
        ? GoogleFonts.getFont(fontFamily)
        : null;
  }
}

class _EditorUpdateHelperPage
    with EditorSendingOverlayMixin, EditorNavigationMixin
    implements EditorUpdateHelperView {
  final BuildContext context;
  final GlobalKey<ScaffoldState> scaffoldKey;
  final ScrollController scrollController;
  final PalEditModeStateService palEditModeStateService;
  final PackageVersionReader packageVersionReader;

  _EditorUpdateHelperPage(
    this.context,
    this.scaffoldKey,
    this.scrollController,
    this.palEditModeStateService,
    this.packageVersionReader,
  );

  BuildContext get overlayContext => context;

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
  Future showPreviewOfHelper(UpdateHelperViewModel model) async {
    UserUpdateHelperPage page = UserUpdateHelperPage(
      helperBoxViewModel:
          HelperSharedFactory.parseBoxNotifier(model.backgroundBoxForm),
      titleLabel: HelperSharedFactory.parseTextNotifier(model.titleTextForm),
      changelogLabels: model.changelogsTextsForm.entries
          .map((e) => HelperSharedFactory.parseTextNotifier(e.value))
          .toList(),
      helperImageViewModel:
          HelperSharedFactory.parseMediaNotifier(model.headerMediaForm),
      onPositivButtonTap: () => Navigator.pop(context),
      packageVersionReader: this.packageVersionReader,
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

  @override
  void hidePalBubble() =>
      this.palEditModeStateService.showBubble(context, false);
}
