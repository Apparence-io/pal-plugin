import 'dart:math';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/pal_navigator_observer.dart';
import 'package:pal/src/pal_notifications.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/router.dart';
import 'package:pal/src/services/editor/page/page_editor_service.dart';
import 'package:pal/src/services/editor/versions/version_editor_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/helpers/editor_anchored_helper/editor_anchored_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper.dart';
import 'package:pal/src/ui/editor/helpers/editor_update_helper/editor_update_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_banner.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_button.dart';
import 'package:pal/src/ui/shared/utilities/element_finder.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import 'helper_editor_presenter.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPageArguments {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;
  final String helperMinVersion;
  final String helperMaxVersion;
  final bool isOnEditMode;
  final HelperViewModel templateViewModel;

  HelperEditorPageArguments(
    this.hostedAppNavigatorKey,
    this.pageId, {
    this.helperMinVersion,
    this.helperMaxVersion,
    this.templateViewModel,
    this.isOnEditMode = false,
  });
}

abstract class HelperEditorView {
  addFullscreenHelperEditor(FullscreenHelperViewModel model, Function isValid);

  addSimpleHelperEditor(SimpleHelperViewModel model, Function isValid);

  addUpdateHelperEditor(UpdateHelperViewModel model, Function isValid);

  addAnchoredFullscreenEditor(HelperEditorPresenter presenter);

  unFocusCurrentTextField(final BuildContext context);

  removeOverlay();

  triggerHaptic();

  showBubble(bool isVisible);

  showHelpersList();
}

class HelperEditorPageBuilder implements HelperEditorView {
  final ElementFinder elementFinder;
  final HelperEditorPageArguments helperEditorPageArguments;
  final EditorHelperService helperService;
  final VersionEditorService versionEditorService;
  final PalRouteObserver routeObserver;
  final PageEditorService pageService;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: (RouteSettings settings) => route(settings),
      theme: PalTheme.of(context).buildTheme(),
      home: WillPopScope(
        onWillPop: () {
          removeOverlay();
          return Future.value(false);
        },
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3.0, sigmaY: 3.0),
            child: Container(
              color: Colors.black.withOpacity(.4),
              child: Stack(
                children: [
                  if (model.isEditingWidget)
                    Positioned.fill(child: _helperToEdit),
                  (!model.isLoading)
                      ? Stack(
                          key: ValueKey('palEditorModeInteractUI'),
                          children: [
                            if (!model.isKeyboardOpened)
                              _buildValidationActions(
                                  context, presenter, model),
                            _buildBannerEditorMode(context),
                          ],
                        )
                      : AnimatedOpacity(
                          duration: Duration(milliseconds: 400),
                          opacity: model.loadingOpacity,
                          child: Stack(
                            children: [
                              BackdropFilter(
                                filter:
                                    ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
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
        !helperEditorPageArguments.isOnEditMode ? 'Creating your helper...' : 'Updating your helper...',
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
            ? (!helperEditorPageArguments.isOnEditMode) ? 'Helper created 👍' : 'Helper updated 😎'
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
                isEnabled: model.isEditableWidgetValid,
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
  removeOverlay() async {
    Overlayed.removeOverlay(
      helperEditorPageArguments.hostedAppNavigatorKey.currentContext,
      OverlayKeys.EDITOR_OVERLAY_KEY,
    );

    this.showBubble(true);
    this.showHelpersList();
  }

  @override
  triggerHaptic() {
    HapticFeedback.mediumImpact();
  }

  @override
  showBubble(bool isVisible) {
    ShowBubbleNotification(isVisible).dispatch(_scaffoldKey.currentContext);
  }

  @override
  showHelpersList() {
    ShowHelpersListNotification().dispatch(_scaffoldKey.currentContext);
  }
}
