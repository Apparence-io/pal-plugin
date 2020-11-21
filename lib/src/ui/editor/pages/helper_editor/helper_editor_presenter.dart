import 'package:flutter/widgets.dart';
import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/pal_navigator_observer.dart';
import 'package:pal/src/services/editor/helper/helper_editor_models.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/editor/page/page_editor_service.dart';
import 'package:pal/src/services/editor/versions/version_editor_service.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:pal/src/ui/shared/utilities/element_finder.dart';

import 'helper_editor.dart';
import 'helper_editor_viewmodel.dart';

class HelperEditorPresenter
    extends Presenter<HelperEditorViewModel, HelperEditorView> {
  final EditorHelperService helperService;
  final PageEditorService pageService;
  final VersionEditorService versionEditorService;
  final PalNavigatorObserver palNavigatorObserver;
  final PalRouteObserver routeObserver;
  final ElementFinder elementFinder;
  final HelperEditorPageArguments basicArguments;

  HelperEditorPresenter(
    HelperEditorView viewInterface, {
    this.basicArguments,
    this.helperService,
    this.pageService,
    this.routeObserver,
    this.versionEditorService,
    this.palNavigatorObserver,
    this.elementFinder,
  }) : super(HelperEditorViewModel(), viewInterface);

  @override
  void onInit() {
    viewModel.enableSave = false;
    viewModel.isLoading = false;
    viewModel.isEditingWidget = false;
    viewModel.loadingOpacity = 0;
    viewModel.isHelperCreated = false;
    viewModel.isHelperCreating = false;
    viewModel.isKeyboardOpened = false;

    // Create a template helper model
    // this template will be copied to edited widget
    viewModel.templateViewModel = basicArguments?.templateViewModel;
    viewModel.helperViewModel = EditorViewModelFactory.transform(
      viewModel.templateViewModel,
    );

    chooseHelperType();

    KeyboardVisibilityNotification().addNewListener(
      onChange: (bool visible) {
        viewModel.isKeyboardOpened = visible;
        this.refreshView();
      },
    );

    // If user edit an helper, it was always valid the first time
    viewModel.isEditableWidgetValid = basicArguments?.isOnEditMode;
  }

  checkIfEditableWidgetFormValid(bool isFormValid) {
    viewModel.isEditableWidgetValid = isFormValid;
    this.refreshView();
  }

  chooseHelperType() {
    switch (viewModel?.helperViewModel?.helperType) {
      case HelperType.HELPER_FULL_SCREEN:
        viewInterface.addFullscreenHelperEditor(
            viewModel.helperViewModel, checkIfEditableWidgetFormValid);
        break;
      case HelperType.SIMPLE_HELPER:
        viewInterface.addSimpleHelperEditor(
            viewModel.helperViewModel, checkIfEditableWidgetFormValid);
        break;
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        viewInterface.addAnchoredFullscreenEditor(this);
        break;
      case HelperType.UPDATE_HELPER:
        viewInterface.addUpdateHelperEditor(
            viewModel.helperViewModel, checkIfEditableWidgetFormValid);
        break;
      default:
        throw "Not implemented type";
        break;
    }
    viewModel.isEditingWidget = true;
    refreshView();
  }

  onEditorClose() => this.viewInterface.removeOverlay();

  onEditorValidate() async {
    RouteSettings route = await routeObserver.routeSettings.first;
    if (route == null || route.name.length <= 0) {
      return Future.value();
    }

    String pageId = await this.pageService.getOrCreatePageId(route.name);
    int versionMinId = await this
        .versionEditorService
        .getOrCreateVersionId(basicArguments?.helperMinVersion);

    final helperBasicConfig = CreateHelperConfig(
      id: basicArguments?.templateViewModel?.id,
      pageId: pageId,
      name: basicArguments?.templateViewModel?.name,
      triggerType: basicArguments?.templateViewModel?.triggerType,
      helperType: basicArguments?.templateViewModel?.helperType,
      priority: basicArguments?.templateViewModel?.priority,
      versionMinId: versionMinId,
      versionMaxId: basicArguments?.templateViewModel?.versionMaxId,
    );

    await this.save(helperBasicConfig);
  }

  Future<void> save(CreateHelperConfig config) async {
    viewModel.isLoading = true;
    viewModel.isHelperCreating = true;
    this.refreshView();

    // Trigger opacity animation
    await Future.delayed(Duration(milliseconds: 200));
    viewModel.loadingOpacity = 1;
    this.refreshView();

    // Wait for animation complete
    await Future.delayed(Duration(milliseconds: 400));

    // Update or create
    await _saveHelper(config);

    this.viewInterface.triggerHaptic();
    viewModel.isHelperCreating = false;
    this.refreshView();

    await Future.delayed(Duration(milliseconds: 2200));

    viewModel.loadingOpacity = 0;
    this.refreshView();

    Future.delayed(Duration(milliseconds: 400), () {
      viewModel.isLoading = false;
      this.refreshView();
    });

    if (viewModel.isHelperCreated) {
      await Future.delayed(Duration(milliseconds: 500));
      this.viewInterface.removeOverlay();
    }
  }

  //----------------------------------------------------------------------
  // PRIVATES
  //----------------------------------------------------------------------

  Future _saveHelper(CreateHelperConfig config) async {
    try {
      switch (config?.helperType) {
        case HelperType.HELPER_FULL_SCREEN:
          var model = viewModel.helperViewModel as FullscreenHelperViewModel;
          await helperService.saveFullScreenHelper(config.pageId,
              EditorEntityFactory.buildFullscreenArgs(config, model));
          break;
        case HelperType.SIMPLE_HELPER:
          var model = viewModel.helperViewModel as SimpleHelperViewModel;
          await helperService.saveSimpleHelper(config.pageId,
              EditorEntityFactory.buildSimpleArgs(config, model));
          break;
        // case HelperType.ANCHORED_OVERLAYED_HELPER:
        //   break;
        case HelperType.UPDATE_HELPER:
          var model = viewModel.helperViewModel as UpdateHelperViewModel;
          await helperService.saveUpdateHelper(config.pageId,
              EditorEntityFactory.buildUpdateArgs(config, model));
          break;
        default:
          throw "NOT_IMPLEMENTED_TYPE";
          break;
      }
      viewModel.isHelperCreated = true;
    } catch (e) {
      print("--------------------------");
      print("Error while saving helper");
      print("--------------------------");
      debugPrint(e);
      print("--------------------");
      viewModel.isHelperCreated = false;
    }
  }


}
