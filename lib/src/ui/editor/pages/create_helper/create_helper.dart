import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/editor/project/project_editor_service.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_group/create_helper_group.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/setup_group/select_helper_group.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_theme/create_helper_theme_step.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_router.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/widgets/nested_navigator.dart';
import 'package:pal/src/ui/editor/widgets/progress_widget/progress_bar_widget.dart';

import '../../../../pal_navigator_observer.dart';
import 'steps/select_group_position/helper_position_setup.dart';

class CreateHelperPageArguments {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;

  CreateHelperPageArguments(
    this.hostedAppNavigatorKey,
    this.pageId,
  );
}

abstract class CreateHelperView {

  void launchHelperEditor(final String pageRoute, final CreateHelperModel model);

  void changeStep(int index);

  void popStep();

  void showNewHelperGroupForm();

  void showGroupHelpersPositions(Future<List<GroupHelperViewModel>> loadGroupHelpers, OnValidate onValidate);
}

class CreateHelperPage extends StatelessWidget implements CreateHelperView {

  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final PalRouteObserver routeObserver;
  final String pageId;
  final PackageVersionReader packageVersionReader;
  final ProjectEditorService projectEditorService;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  final GlobalKey<NavigatorState> _nestedNavigationKey = GlobalKey<NavigatorState>();


  CreateHelperPage({
    Key key,
    this.hostedAppNavigatorKey,
    this.packageVersionReader,
    this.pageId,
    this.routeObserver,
    this.projectEditorService
  });

  final _mvvmPageBuilder = MVVMPageBuilder<CreateHelperPresenter, CreateHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey("createHelperPresenter"),
      context: context,
      presenterBuilder: (context) => CreateHelperPresenter(
        this,
        this.pageId,
        routeObserver: routeObserver ?? EditorInjector.of(context).routeObserver,
        packageVersionReader: packageVersionReader ?? EditorInjector.of(context).packageVersionReader,
        projectEditorService: projectEditorService ?? EditorInjector.of(context).projectEditorService
      ),
      builder: (context, presenter, model)
        => Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.transparent,
            iconTheme: IconThemeData(
              color: PalTheme.of(context.buildContext).colors.dark,
            ),
            title: Text(
              'Create new helper',
              style: TextStyle(
                color: PalTheme.of(context.buildContext).colors.dark,
              ),
            ),
          ),
          body: this._buildPage(context.buildContext, presenter, model),
        ),
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final CreateHelperPresenter presenter,
    final CreateHelperModel model,
  ) {
    return SafeArea(
      child: Container(
        width: double.infinity,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 23.0,
                bottom: 24.0,
                left: 16.0,
                right: 16.0,
              ),
              child: _buildProgressBar(model),
            ),
            Expanded(
              child: NestedNavigator(
                navigationKey: _nestedNavigationKey,
                initialRoute: 'create/helper_group',
                onWillPop: presenter.decrementStep,
                routes: {
                  'create/new_helper_group': (context) => CreateHelperGroup(
                    triggerTypes: model.triggerTypes,
                    defaultTriggerType: model.triggerTypes.first,
                    helperNameValidator: presenter.checkHelperGroupName,
                    onTriggerValueSelected: presenter.selectHelperGroupTrigger,
                    onChangedNameText: presenter.onChangedHelperGroupName,
                    triggerTypeValidator: null,
                    minVersionChanged: presenter.setMinAppVersion,
                    maxVersionChanged: presenter.setMaxAppVersion,
                    minVersionInitialValue: model.minVersion,
                    maxVersionInitialValue: model.maxVersion,
                    onFormChanged: presenter.groupCreationFormChanged,
                    minVersionValidator: presenter.checkValidVersion,
                    maxVersionValidator: presenter.checkMaxValidVersion,
                  ),
                  'create/helper_group': (context) => SelectHelperGroupPage(
                      helperGroupLoader: presenter.loadHelperGroup,
                      onTapAdd: presenter.onTapAddNewGroup,
                      onTapElement: presenter.onTapHelperGroupSelection,
                    ),
                  'create/infos': (context) => CreateHelperInfosStep(
                      model: model,
                      presenter: presenter,
                      onTapChangePosition: presenter.onTapChangePosition,
                    ),
                  'create/type': (context) => CreateHelperTypeStep(
                      model: model,
                      presenter: presenter,
                    ),
                  'create/theme': (context) => CreateHelperThemeStep(
                      model: model,
                      presenter: presenter,
                    ),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                top: 8.0,
                bottom: 8.0,
                left: 16.0,
                right: 16.0,
              ),
              child: Container(
                width: double.infinity,
                child: _buildNextButton(context, model, presenter),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(final CreateHelperModel model) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          (model?.step?.value != null)
              ? model.stepsTitle[model?.step?.value]
              : '',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        SizedBox(height: 15.0),
        ProgressBarWidget(
          nbSteps: 4,
          step: model.step,
        ),
      ],
    );
  }

  Widget _buildNextButton(
    final BuildContext context,
    final CreateHelperModel model,
    final CreateHelperPresenter presenter,
  ) {
    return ValueListenableBuilder<bool>(
      valueListenable: model.isFormValid,
      builder: (context, value, child) => RaisedButton(
        key: ValueKey('palCreateHelperNextButton'),
        disabledColor: PalTheme.of(context).colors.color4,
        child: Text(
          'Next',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        color: PalTheme.of(context).colors.color1,
        onPressed: (value) ? presenter.incrementStep : null,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  @override
  void launchHelperEditor(final String pageRoute, final CreateHelperModel model) {
    new EditorRouter(hostedAppNavigatorKey).createHelper(pageRoute, model);
    // Go back
    Navigator.of(_scaffoldKey.currentContext).pop(true);
  }

  @override
  void changeStep(int index) {
    const routeNames = [
      "helper_group",
      "infos",
      "type",
      "theme",
    ];
    Navigator.of(_nestedNavigationKey.currentContext).pushNamed('create/${routeNames[index]}');
  }

  void showNewHelperGroupForm()
    => Navigator.of(_nestedNavigationKey.currentContext).pushNamed('create/new_helper_group');

  @override
  void popStep()
    => Navigator.of(_nestedNavigationKey.currentContext).pop();

  @override
  void showGroupHelpersPositions(Future<List<GroupHelperViewModel>> loadGroupHelpers, OnValidate onValidate) {
   Navigator.of( _scaffoldKey.currentContext).push(new MaterialPageRoute(
      settings: RouteSettings(name: "helper_group_position"),
      builder: (context) => HelperPositionPage(
            helpersLoader: loadGroupHelpers,
            onValidate: onValidate,
          ))
    );
  }
}
