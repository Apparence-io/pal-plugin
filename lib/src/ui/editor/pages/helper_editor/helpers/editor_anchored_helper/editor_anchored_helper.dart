import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/finder/finder_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helpers/user_anchored_helper/anchored_helper_widget.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_preview/editor_preview.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_button.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/editable/editable_textfield.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_tutorial.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import '../../../../../../router.dart';
import '../../helper_editor.dart';
import '../../helper_editor_viewmodel.dart';
import 'editor_anchored_helper_presenter.dart';
import 'editor_anchored_helper_viewmodel.dart';

/// ------------------------------------------------------------
/// Interface for presenter view contract
/// ------------------------------------------------------------
abstract class EditorAnchoredFullscreenHelperView {
  // void showColorPickerDialog(Color defaultColor,
  //     OnColorSelected onColorSelected, OnCancelPicker onCancel);

  void closeColorPickerDialog();

  Future showLoadingScreen(ValueNotifier<SendingStatus> status);

  void closeLoadingScreen();

  Future closeEditor();

  void showErrorMessage(String message);

  void showTutorial(String title, String content);

  Future showPreviewOfHelper(AnchoredFullscreenHelperViewModel model,
      FinderService finderService, bool isTestingMode);
}

/// ------------------------------------------------------------
/// [EditorAnchoredFullscreenHelper] editor page
/// ------------------------------------------------------------
class EditorAnchoredFullscreenHelper extends StatelessWidget {
  // ignore: close_sinks
  final StreamController<bool> editableTextFieldController =
      StreamController<bool>.broadcast();

  final PresenterBuilder<EditorAnchoredFullscreenPresenter> presenterBuilder;
  final FinderService finderService;
  final bool isTestingMode;

  EditorAnchoredFullscreenHelper._({
    Key key,
    @required this.presenterBuilder,
    this.finderService,
    this.isTestingMode = false,
  }) : super(key: key);

  factory EditorAnchoredFullscreenHelper.create(
          {Key key,
          HelperEditorPageArguments parameters,
          EditorHelperService helperService,
          FinderService finderService,
          bool isTestingMode,
          @required HelperViewModel helperViewModel}) =>
      EditorAnchoredFullscreenHelper._(
        key: key,
        presenterBuilder: (context) => EditorAnchoredFullscreenPresenter(
          AnchoredFullscreenHelperViewModel.fromModel(helperViewModel),
          _EditorAnchoredFullscreenHelperView(
              context, EditorInjector.of(context).palEditModeStateService),
          finderService ?? EditorInjector.of(context).finderService,
          isTestingMode,
          helperService ?? EditorInjector.of(context).helperService,
          parameters,
        ),
      );

  factory EditorAnchoredFullscreenHelper.edit(
          {Key key,
          HelperEditorPageArguments parameters,
          EditorHelperService helperService,
          PalEditModeStateService palEditModeStateService,
          FinderService finderService,
          bool isTestingMode,
          @required
              HelperEntity
                  helperEntity //FIXME should be an id and not entire entity
          }) =>
      EditorAnchoredFullscreenHelper._(
          key: key,
          presenterBuilder: (context) => EditorAnchoredFullscreenPresenter(
                AnchoredFullscreenHelperViewModel.fromEntity(helperEntity),
                _EditorAnchoredFullscreenHelperView(context,
                    EditorInjector.of(context).palEditModeStateService),
                finderService ?? EditorInjector.of(context).finderService,
                isTestingMode,
                helperService ?? EditorInjector.of(context).helperService,
                parameters,
              ));

  @override
  Widget build(BuildContext context) {
    return MVVMPageBuilder<EditorAnchoredFullscreenPresenter,
            AnchoredFullscreenHelperViewModel>()
        .build(
      context: context,
      key: ValueKey("EditorAnchoredFullscreenHelperPage"),
      presenterBuilder: presenterBuilder,
      multipleAnimControllerBuilder: (tickerProvider) => [
        // AnchoredWidget repeating animation
        AnimationController(
            vsync: tickerProvider, duration: Duration(seconds: 1))
          ..repeat(reverse: true),
        // AnchoredWidget opacity animation
        AnimationController(
            vsync: tickerProvider, duration: Duration(milliseconds: 500))
      ],
      animListener: (context, presenter, model) {
        if (model.selectedAnchorKey != null) {
          context.animationsControllers[1].forward(from: 0);
        }
      },
      builder: (context, presenter, model) => Material(
          color: Colors.black.withOpacity(0.3),
          child: EditorToolboxPage(
            boxViewHandler: BoxViewHandler(
                callback: presenter.updateBackgroundColor,
                selectedColor: model.backgroundBox?.backgroundColor?.value),
            // onCancel: presenter.onCancel,
            onValidate: (model.canValidate?.value == true)
                ? presenter.onValidate
                : null,
            currentEditableItemNotifier: model.currentEditableItemNotifier,
            // onPreview: presenter.onPreview,
            child: Stack(
              children: [
                _createAnchoredWidget(model, context.animationsControllers[0],
                    context.animationsControllers[1]),
                _buildEditableTexts(presenter, model),
                ..._createSelectableElements(presenter, model),
                _buildRefreshButton(presenter),
                _buildConfirmSelectionButton(
                    context.buildContext, presenter, model),
                _buildBackgroundSelectButton(
                    context.buildContext, model.anchorValidated, presenter),
              ],
            ),
          )),
    );
  }

  _createSelectableElements(EditorAnchoredFullscreenPresenter presenter,
      AnchoredFullscreenHelperViewModel model) {
    if (model.anchorValidated) return [];
    return model.userPageSelectableElements
        .map((key, model) => new MapEntry(
            key,
            _WidgetElementModelTransformer()
                .apply(key, model, presenter.onTapElement)))
        .values
        .toList();
  }

  _createAnchoredWidget(
      AnchoredFullscreenHelperViewModel model,
      AnimationController animationController,
      AnimationController fadeinAnimController) {
    final element = model.selectedAnchor;
    return Positioned.fill(
        child: FadeTransition(
      opacity: fadeinAnimController,
      child: Visibility(
        visible: model.selectedAnchor != null,
        child: AnimatedAnchoredFullscreenCircle(
            listenable: animationController,
            currentPos: element?.value?.offset,
            anchorSize: element?.value?.rect?.size,
            bgColor: model.backgroundBox.backgroundColor.value,
            padding: 4),
      ),
    ));
  }

  _buildBackgroundSelectButton(BuildContext context, bool show,
      EditorAnchoredFullscreenPresenter presenter) {
    if (!show) return Container();
    return Positioned(
      top: 20.0,
      left: 20.0,
      child: SafeArea(
        child: CircleIconButton(
          key: ValueKey("bgColorPicker"),
          icon: Icon(Icons.invert_colors),
          backgroundColor: PalTheme.of(context).colors.light,
          onTapCallback: presenter.onCallChangeBackground,
        ),
      ),
    );
  }

  _buildConfirmSelectionButton(
      BuildContext context,
      EditorAnchoredFullscreenPresenter presenter,
      AnchoredFullscreenHelperViewModel model) {
    if (model.selectedAnchor == null || model.anchorValidated)
      return Container();
    return Positioned(
        left: model.selectedAnchor.value.offset.dx,
        top: model.selectedAnchor.value.offset.dy,
        child: EditorButton.validate(
            PalTheme.of(context), presenter.validateSelection,
            key: ValueKey("validateSelectionBtn")));
  }

  _buildRefreshButton(EditorAnchoredFullscreenPresenter presenter) {
    return Positioned(
      top: 32,
      right: 16,
      child: FlatButton.icon(
          key: ValueKey("refreshButton"),
          onPressed: presenter.resetSelection,
          color: Colors.black,
          icon: Icon(
            Icons.refresh,
            color: Colors.white,
          ),
          label: Text(
            "reset",
            style: TextStyle(color: Colors.white),
          )),
    );
  }

  _buildEditableTexts(EditorAnchoredFullscreenPresenter presenter,
      AnchoredFullscreenHelperViewModel model) {
    if (model.writeArea == null ||
        model.selectedAnchor == null ||
        !model.anchorValidated) return Container();
    return Positioned.fromRect(
      rect: model.writeArea ?? Rect.largest,
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(top: 8.0, bottom: 12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8),
                  child: EditableTextField(
                    textNotifier: model.titleField,
                    currentEditableItemNotifier:
                        model.currentEditableItemNotifier,
                  )
                  // child: EditableTextField.fromNotifier(
                  //   editableTextFieldController.stream,
                  //   model.titleField,
                  //   presenter.onTitleChanged,
                  //   presenter.onTitleSubmit,
                  //   presenter.onTitleTextStyleChanged,
                  // ),
                  ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: EditableTextField(
                  textNotifier: model.descriptionField,
                  currentEditableItemNotifier:
                      model.currentEditableItemNotifier,
                ),
              ),
              SizedBox(height: 16),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: EditableButton(
                      buttonFormFieldNotifier: model.negativBtnField,
                      currentEditableItemNotifier:
                          model.currentEditableItemNotifier,
                    ),
                  ),
                  Flexible(
                    child: EditableButton(
                      buttonFormFieldNotifier: model.positivBtnField,
                      currentEditableItemNotifier:
                          model.currentEditableItemNotifier,
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class _EditorAnchoredFullscreenHelperView
    with EditorSendingOverlayMixin, EditorNavigationMixin
    implements EditorAnchoredFullscreenHelperView {
  BuildContext context;

  final PalEditModeStateService palEditModeStateService;

  EditorSendingOverlay sendingOverlay;

  _EditorAnchoredFullscreenHelperView(
      this.context, this.palEditModeStateService) {
    overlayContext = context;
  }

  // @override
  // void showColorPickerDialog(Color defaultColor,
  //     OnColorSelected onColorSelected, OnCancelPicker onCancel) {
  //   HapticFeedback.selectionClick();
  //   showOverlayedInContext(
  //       (context) => ColorPickerDialog(
  //           placeholderColor: defaultColor,
  //           onColorSelected: onColorSelected,
  //           onCancel: onCancel),
  //       key: OverlayKeys.PAGE_OVERLAY_KEY);
  // }

  void closeColorPickerDialog() => closeOverlayed(OverlayKeys.PAGE_OVERLAY_KEY);

  @override
  void showErrorMessage(String message) {
    showOverlayedInContext(
        (context) => EditorTutorialOverlay(
              onPressDismiss: () =>
                  closeOverlayed(OverlayKeys.PAGE_OVERLAY_KEY),
              title: "Error",
              content: "$message",
            ),
        key: OverlayKeys.PAGE_OVERLAY_KEY);
  }

  @override
  void showTutorial(String title, String content) {
    showOverlayedInContext(
        (context) => EditorTutorialOverlay(
              onPressDismiss: () =>
                  closeOverlayed(OverlayKeys.PAGE_OVERLAY_KEY),
              title: title,
              content: content,
            ),
        key: OverlayKeys.PAGE_OVERLAY_KEY);
  }

  @override
  Future showPreviewOfHelper(AnchoredFullscreenHelperViewModel model,
      FinderService finderService, bool isTestingMode) async {
    AnchoredHelper page = AnchoredHelper.fromEntity(
      finderService: finderService,
      positivButtonLabel:
          HelperSharedFactory.parseButtonNotifier(model.positivBtnField),
      titleLabel: HelperSharedFactory.parseTextNotifier(model.titleField),
      descriptionLabel:
          HelperSharedFactory.parseTextNotifier(model.descriptionField),
      negativButtonLabel:
          HelperSharedFactory.parseButtonNotifier(model.negativBtnField),
      helperBoxViewModel:
          HelperSharedFactory.parseBoxNotifier(model.backgroundBox),
      anchorKey: model.selectedAnchorKey,
      isTestingMode: isTestingMode,
      onNegativButtonTap: () => Navigator.of(context).pop(),
      onPositivButtonTap: () => Navigator.of(context).pop(),
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

typedef OnTapElement = void Function(String key);

class _WidgetElementModelTransformer {
  Widget apply(String key, WidgetElementModel model, OnTapElement onTap) {
    // debugPrint("$key: w:${model.rect.width} h:${model.rect.height} => ${model.offset.dx} ${model.offset.dy}");
    return Positioned(
        left: model.offset.dx,
        top: model.offset.dy,
        child: InkWell(
          key: ValueKey("elementContainer"),
          onTap: () => onTap(key),
          child: Container(
            width: model.rect.width,
            height: model.rect.height,
            decoration: BoxDecoration(
              border: Border.all(
                color: Colors.white.withOpacity(model.selected ? 1 : .5),
                width: model.selected ? 4 : 2,
              ),
            ),
            child: Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                // child: Text("$key",
                //   style: TextStyle(color: Colors.white)
                // ),
              ),
            ),
          ),
        ));
  }
}
