import 'package:flutter/widgets.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_models.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_service.dart';
import 'package:palplugin/src/services/editor/page/page_editor_service.dart';
import 'package:palplugin/src/services/editor/versions/version_editor_service.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_factory.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

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
    viewModel.isEditableWidgetValid = false;
    viewModel.loadingOpacity = 0;
    viewModel.isHelperCreated = false;
    viewModel.isHelperCreating = false;

    // Create a template helper model
    // this template will be copied to edited widget
    viewModel.templateViewModel = HelperViewModel(
      name: basicArguments?.helperName,
      priority: basicArguments?.priority ?? 0,
      triggerType:
          basicArguments?.triggerType ?? HelperTriggerType.ON_SCREEN_VISIT,
      versionMinId: basicArguments?.versionMinId ?? 1,
      versionMaxId: basicArguments?.versionMaxId ?? 2,
    );
    viewModel.helperViewModel = EditorViewModelFactory.transform(
        viewModel.templateViewModel, basicArguments?.helperType);
    chooseHelperType();
  }

  checkIfEditableWidgetFormValid(bool isFormValid) {
    viewModel.isEditableWidgetValid = isFormValid;
    this.refreshView();
  }

  chooseHelperType() {
    switch (basicArguments?.helperType) {
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

  onEditorClose() {
    this.viewInterface.removeOverlay();
  }

  onEditorValidate() async {
    RouteSettings route = await routeObserver.routeSettings.first;
    if (route == null || route.name.length <= 0) {
      return Future.value();
    }

    String pageId = await this.pageService.getOrCreatePageId(route.name);
    int versionMinId = await this
        .versionEditorService
        .getOrCreateVersionId(basicArguments?.helperMinVersion);

    var helperBasicConfig = CreateHelperConfig(
      pageId: pageId,
      name: basicArguments.helperName,
      triggerType: basicArguments.triggerType,
      helperType: basicArguments.helperType,
      priority: basicArguments.priority,
      versionMinId: versionMinId,
      versionMaxId: basicArguments.versionMaxId,
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

    try {
      switch (config?.helperType) {
        case HelperType.HELPER_FULL_SCREEN:
          var model = viewModel.helperViewModel as FullscreenHelperViewModel;
          await helperService.createFullScreenHelper(config.pageId,
              EditorEntityFactory.buildFullscreenArgs(config, model));
          break;
        case HelperType.SIMPLE_HELPER:
          var model = viewModel.helperViewModel as SimpleHelperViewModel;
          await helperService.createSimpleHelper(config.pageId,
              EditorEntityFactory.buildSimpleArgs(config, model));
          break;
        // case HelperType.ANCHORED_OVERLAYED_HELPER:
        //   break;
        case HelperType.UPDATE_HELPER:
          var model = viewModel.helperViewModel as UpdateHelperViewModel;
          await helperService.createUpdateHelper(config.pageId,
              EditorEntityFactory.buildUpdateArgs(config, model));
          break;
        default:
          throw "NOT_IMPLEMENTED_TYPE";
          break;
      }
      viewModel.isHelperCreated = true;
    } catch (e) {
      viewModel.isHelperCreated = false;
    }
    viewModel.isHelperCreating = false;
    this.refreshView();

    await Future.delayed(Duration(milliseconds: 2500));

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

}
