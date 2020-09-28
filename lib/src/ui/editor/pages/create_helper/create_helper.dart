import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/router.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_infos_step.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_theme_step.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_type_step.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/nested_navigator.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';
import 'package:palplugin/src/ui/shared/widgets/progress_widget/progress_bar_widget.dart';

class CreateHelperPageArguments {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;

  CreateHelperPageArguments(
    this.hostedAppNavigatorKey,
    this.pageId,
  );
}

abstract class CreateHelperView {
  void onFormChanged(
    CreateHelperModel model,
    CreateHelperPresenter presenter,
  );
  void launchHelperEditor(final CreateHelperModel model);
  void changeStep(GlobalKey<NavigatorState> nestedNavigationKey, int index);
  void popStep(GlobalKey<NavigatorState> nestedNavigationKey);
}

class CreateHelperPage extends StatefulWidget {
  final GlobalKey<NavigatorState> hostedAppNavigatorKey;
  final String pageId;

  CreateHelperPage({
    Key key,
    this.hostedAppNavigatorKey,
    this.pageId,
  });

  @override
  _CreateHelperPageState createState() => _CreateHelperPageState();
}

class _CreateHelperPageState extends State<CreateHelperPage>
    implements CreateHelperView {
  final _mvvmPageBuilder =
      MVVMPageBuilder<CreateHelperPresenter, CreateHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => CreateHelperPresenter(this),
      builder: (context, presenter, model) {
        return Scaffold(
          key: ValueKey('CreateHelper'),
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
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final CreateHelperPresenter presenter,
    final CreateHelperModel model,
  ) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 23.0,
                bottom: 17.0,
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
                    formKey: model.formKey,
                    model: model,
                    presenter: presenter,
                  ),
                  'create/type': (context) => CreateHelperTypeStep(),
                  'create/theme': (context) => CreateHelperThemeStep(),
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 11.0),
              child: Container(
                width: double.infinity,
                child: _buildNextButton(model, presenter),
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
          model.stepsTitle[model.step.value],
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        ProgressBarWidget(
          nbSteps: 3,
          step: model.step,
        ),
      ],
    );
  }

  Widget _buildNextButton(
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
      onPressed: presenter.incrementStep,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }

  @override
  void onFormChanged(
    CreateHelperModel model,
    CreateHelperPresenter presenter,
  ) {
    model.isFormValid = model.formKey.currentState.validate();
    presenter.refreshView();
  }

  @override
  //FIXME put this in another class to deport logic
  void launchHelperEditor(final CreateHelperModel model) {
    HapticFeedback.selectionClick();

    // Open editor overlay
    HelperEditorPageArguments args = HelperEditorPageArguments(
      widget.hostedAppNavigatorKey,
      widget.pageId,
      helperName: '_helperNameController?.value?.text',
      triggerType: getHelperTriggerType(model.selectedTriggerType),
    );
    var elementFinder =
        ElementFinder(widget.hostedAppNavigatorKey.currentContext);
    showOverlayed(
      widget.hostedAppNavigatorKey,
      HelperEditorPageBuilder(args, elementFinder: elementFinder).build,
    );
    // Go back
    Navigator.of(context).pop(true);
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
}
