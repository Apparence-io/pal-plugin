import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_theme.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_service.dart';
import 'package:palplugin/src/services/editor/page/page_editor_service.dart';
import 'package:palplugin/src/services/editor/versions/version_editor_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_anchored_helper/editor_anchored_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/editor_banner.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';
import 'package:palplugin/src/ui/shared/widgets/overlayed.dart';

import 'helper_editor_presenter.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPageArguments {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;

  final String helperName;
  final String helperMinVersion;
  final int priority;
  final HelperTriggerType triggerType;
  final HelperTheme helperTheme;
  final HelperType helperType;
  final int versionMinId;
  final int versionMaxId;

  HelperEditorPageArguments(
    this.hostedAppNavigatorKey,
    this.pageId, {
    @required this.helperName,
    @required this.helperMinVersion,
    this.priority,
    @required this.triggerType,
    @required this.helperTheme,
    @required this.helperType,
    this.versionMinId,
    this.versionMaxId,
  });
}

abstract class HelperEditorView {
  addFullscreenHelperEditor(FullscreenHelperViewModel model, Function isValid);

  addSimpleHelperEditor(SimpleHelperViewModel model, Function isValid);

  addUpdateHelperEditor(UpdateHelperViewModel model, Function isValid);

  addAnchoredFullscreenEditor(HelperEditorPresenter presenter);

  unFocusCurrentTextField(final BuildContext context);

  removeOverlay();
}

class HelperEditorPageBuilder implements HelperEditorView {
  final ElementFinder elementFinder;
  final HelperEditorPageArguments helperEditorPageArguments;
  final EditorHelperService helperService;
  final VersionEditorService versionEditorService;
  final PalRouteObserver routeObserver;
  final PageEditorService pageService;

  final _mvvmPageBuilder =
      MVVMPageBuilder<HelperEditorPresenter, HelperEditorViewModel>();

  Widget _helperToEdit;

  HelperEditorPageBuilder(
    this.helperEditorPageArguments, {
    this.helperService,
    this.routeObserver,
    this.pageService,
    this.versionEditorService,
    this.elementFinder,
  });

  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey("EditorPage"),
      context: context,
      presenterBuilder: (context) => HelperEditorPresenter(
        this,
        basicArguments: helperEditorPageArguments,
        helperService:
            helperService ?? EditorInjector.of(context).helperService,
        pageService:
            pageService ?? EditorInjector.of(context).pageEditorService,
        versionEditorService: versionEditorService ??
            EditorInjector.of(context).versionEditorService,
        routeObserver:
            routeObserver ?? EditorInjector.of(context).routeObserver,
        elementFinder: elementFinder,
      ),
      builder: (mContext, presenter, model) => _buildEditorPage(
        mContext.buildContext,
        presenter,
        model,
      ),
    );
  }

  _buildEditorPage(
    final BuildContext context,
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
  ) {
    return WillPopScope(
      onWillPop: () {
        removeOverlay();
        return Future.value(false);
      },
      child: Material(
        key: ValueKey("EditorMaterial"),
        color: Colors.transparent,
        shadowColor: Colors.transparent,
        child: Container(
          color: Colors.black.withOpacity(.2),
          child: Stack(
            children: [
              if (model.isEditingWidget) Positioned.fill(child: _helperToEdit),
              (!model.isLoading)
                  ? Stack(
                      key: ValueKey('palEditorModeInteractUI'),
                      children: [
                        _buildValidationActions(context, presenter, model),
                        _buildBannerEditorMode(context),
                      ],
                    )
                  : AnimatedOpacity(
                      duration: Duration(milliseconds: 400),
                      opacity: model.loadingOpacity,
                      child: Stack(
                        children: [
                          BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                            child: Container(
                              color: Colors.black54,
                            ),
                          ),
                          Center(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: (model.isHelperCreating)
                                  ? _buildLoadingScreen()
                                  : _buildCreationStatusScreen(model),
                            ),
                          ),
                        ],
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildLoadingScreen() {
    return [
      CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      ),
      SizedBox(height: 25.0),
      Text(
        'Creating your helper...',
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
      ),
    ];
  }

  List<Widget> _buildCreationStatusScreen(HelperEditorViewModel model) {
    return [
      model.isHelperCreated
          ? Icon(
              Icons.check,
              color: Colors.green,
              size: 100.0,
            )
          : Icon(
              Icons.close,
              color: Colors.red,
              size: 100.0,
            ),
      SizedBox(height: 25.0),
      Text(
        (model.isHelperCreated)
            ? 'Helper created 👍'
            : 'An error occured 😐\nPlease try again.',
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
      ),
    ];
  }

  Widget _buildBannerEditorMode(BuildContext context) {
    return Positioned(
      top: 24,
      right: -24,
      child: Transform.rotate(angle: pi / 4, child: EditorModeBanner()),
    );
  }

  Widget _buildValidationActions(
    final BuildContext context,
    final HelperEditorPresenter presenter,
    final HelperEditorViewModel model,
  ) {
    return Positioned(
      bottom: 25,
      left: 16,
      right: 16,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          EditorButton.cancel(
            PalTheme.of(context),
            presenter.onEditorClose,
            key: ValueKey("editModeCancel"),
          ),
          if (model.isEditingWidget)
            Padding(
              padding: EdgeInsets.only(left: 16),
              child: EditorButton.validate(
                PalTheme.of(context),
                presenter.onEditorValidate,
                key: ValueKey("editModeValidate"),
              ),
            ),
        ],
      ),
    );
  }

  // /////////////////////////////////////////:
  // HelperEditorView
  // /////////////////////////////////////////:

  addFullscreenHelperEditor(FullscreenHelperViewModel model, Function isValid) {
    _helperToEdit = EditorFullScreenHelperPage(
      viewModel: model,
      onFormChanged: isValid,
    );
  }

  addSimpleHelperEditor(SimpleHelperViewModel model, Function isValid) {
    _helperToEdit = EditorSimpleHelperPage(
      viewModel: model,
      onFormChanged: isValid,
    );
  }

  addUpdateHelperEditor(UpdateHelperViewModel model, Function isValid) {
    _helperToEdit = EditorUpdateHelperPage(
      viewModel: model,
      onFormChanged: isValid,
    );
  }

  addAnchoredFullscreenEditor(HelperEditorPresenter presenter) {
    _helperToEdit = EditorAnchoredFullscreenHelper();
  }

  @override
  unFocusCurrentTextField(final BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  @override
  removeOverlay() {
    Overlayed.removeOverlay(
      helperEditorPageArguments.hostedAppNavigatorKey.currentContext,
      OverlayKeys.EDITOR_OVERLAY_KEY,
    );
  }
}
