import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/create_helper_infos_step.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_theme/create_helper_theme_step.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/editor_router.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/widgets/nested_navigator.dart';
import 'package:pal/src/ui/editor/widgets/progress_widget/progress_bar_widget.dart';

import '../../../../pal_navigator_observer.dart';

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

  void changeStep(GlobalKey<NavigatorState> nestedNavigationKey, int index);

  void popStep(GlobalKey<NavigatorState> nestedNavigationKey);

  void checkSteps(CreateHelperModel model, CreateHelperPresenter presenter);
}

class CreateHelperPage extends StatelessWidget implements CreateHelperView {

  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final PalRouteObserver routeObserver;
  final String pageId;
  final PackageVersionReader packageVersionReader;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  CreateHelperPage({
    Key key,
    this.hostedAppNavigatorKey,
    this.packageVersionReader,
    this.pageId,
    this.routeObserver
  });

  final _mvvmPageBuilder = MVVMPageBuilder<CreateHelperPresenter, CreateHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => CreateHelperPresenter(
        this,
        routeObserver: routeObserver
          ?? EditorInjector.of(context).routeObserver,
        packageVersionReader: packageVersionReader
          ?? EditorInjector.of(context).packageVersionReader,
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
                bottom: 17.0,
                left: 16.0,
                right: 16.0,
              ),
              child: _buildProgressBar(model),
            ),
            Expanded(
              child: NestedNavigator(
                navigationKey: model.nestedNavigationKey,
                initialRoute: 'create/infos',
                onWillPop: presenter.decrementStep,
                routes: {
                  'create/infos': (context) => CreateHelperInfosStep(
                        model: model,
                        presenter: presenter,
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
          nbSteps: 3,
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
    return RaisedButton(
      key: ValueKey('palCreateHelperNextButton'),
      disabledColor: PalTheme.of(context).colors.color4,
      child: Text(
        'Next',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      color: PalTheme.of(context).colors.color1,
      onPressed: (model.isFormValid) ? presenter.incrementStep : null,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
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
  void changeStep(GlobalKey<NavigatorState> nestedNavigationKey, int index) {
    String routeName;
    switch (index) {
      case 0:
        routeName = 'infos';
        break;
      case 1:
        routeName = 'type';
        break;
      case 2:
        routeName = 'theme';
        break;
      default:
    }

    Navigator.of(nestedNavigationKey.currentContext)
        .pushNamed('create/$routeName');
  }

  @override
  void popStep(GlobalKey<NavigatorState> nestedNavigationKey) {
    Navigator.of(nestedNavigationKey.currentContext).pop();
  }

  @override
  void checkSteps(CreateHelperModel model, CreateHelperPresenter presenter) {
    switch (model.step.value) {
      case 0:
        model.isFormValid = model.infosForm.currentState.validate();
        break;
      case 1:
        model.isFormValid = model.selectedHelperType != null;
        break;
      case 2:
        model.isFormValid = model.selectedHelperType != null;
        break;
      default:
    }

    presenter.refreshView();
  }
}
