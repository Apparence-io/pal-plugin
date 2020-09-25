import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/injectors/user_app/user_app_injector.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/user_update_helper_presenter.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/user_update_helper_viewmodel.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/widgets/animated_progress_bar.dart';
import 'package:palplugin/src/ui/client/helpers/user_update_helper/widgets/release_note_tile.dart';

abstract class UserUpdateHelperView {}

class UserUpdateHelperPage extends StatelessWidget
    implements UserUpdateHelperView {
  final Color backgroundColor;
  final CustomLabel titleLabel;
  final List<CustomLabel> changelogLabels;
  final CustomLabel thanksButtonLabel;
  final PackageVersionReader packageVersionReader;
  final Function onTrigger;

  UserUpdateHelperPage({
    Key key,
    @required this.backgroundColor,
    @required this.titleLabel,
    @required this.changelogLabels,
    @required this.onTrigger,
    this.thanksButtonLabel,
    this.packageVersionReader,
  })  : assert(backgroundColor != null),
        assert(titleLabel != null),
        assert(changelogLabels != null);

  final _mvvmPageBuilder =
      MVVMPageBuilder<UserUpdateHelperPresenter, UserUpdateHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      multipleAnimControllerBuilder: (tickerProvider) {
        return [
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 1100,
            ),
          ),
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 5000,
            ),
          ),
        ];
      },
      animListener: (context, presenter, model) {
        if (model.changelogCascadeAnimation) {
          context.animationsControllers[0]
              .forward()
              .then((value) => presenter.onCascadeAnimationEnd());
        }
        if (model.progressBarAnimation) {
          context.animationsControllers[1]
              .forward()
              .then((value) => presenter.onProgressBarAnimationEnd());
        }
      },
      presenterBuilder: (context) => UserUpdateHelperPresenter(
        this,
        packageVersionReader ?? UserInjector.of(context).packageVersionReader,
      ),
      builder: (context, presenter, model) {
        return this._buildPage(context, presenter, model);
      },
    );
  }

  Widget _buildPage(
    final MvvmContext context,
    final UserUpdateHelperPresenter presenter,
    final UserUpdateHelperModel model,
  ) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      opacity: model.helperOpacity,
      child: Scaffold(
        key: ValueKey('pal_UserUpdateHelperWidget_Scaffold'),
        backgroundColor: backgroundColor,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Container(
              child: Column(
                children: [
                  Flexible(
                    key: ValueKey('pal_UserUpdateHelperWidget_Icon'),
                    flex: 4,
                    child: buildIcon(),
                  ),
                  Flexible(
                    key: ValueKey('pal_UserUpdateHelperWidget_AppSummary'),
                    flex: 2,
                    child: buildAppSummary(context.buildContext, model),
                  ),
                  Expanded(
                    key: ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes'),
                    flex: 5,
                    child: _buildReleaseNotes(context, model),
                  ),
                  buildThanksButton(context, model, presenter),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Container buildIcon() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Image.asset(
          'packages/palplugin/assets/images/create_helper.png',
          key: ValueKey('pal_UserUpdateHelperWidget_Icon_Image'),
          // height: 282.0,
        ),
      ),
    );
  }

  Container buildAppSummary(
    final BuildContext context,
    final UserUpdateHelperModel model,
  ) {
    return Container(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            titleLabel?.text ?? 'New application update',
            key: ValueKey('pal_UserUpdateHelperWidget_AppSummary_Title'),
            style: TextStyle(
              fontSize: titleLabel?.fontSize ?? 27.0,
              fontWeight: FontWeight.bold,
              color: titleLabel?.fontColor ?? PalTheme.of(context).colors.light,
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          Text(
            'Version ${model.appVersion}',
            key: ValueKey('pal_UserUpdateHelperWidget_AppSummary_Version'),
            style: TextStyle(
              fontSize: 13.0,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildThanksButton(
    final MvvmContext context,
    final UserUpdateHelperModel model,
    final UserUpdateHelperPresenter presenter,
  ) {
    return SizedBox(
      key: ValueKey('pal_UserUpdateHelperWidget_ThanksButton'),
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(
          left: 20.0,
          right: 20.0,
          bottom: 15.0,
        ),
        child: RaisedButton(
          key: ValueKey('pal_UserUpdateHelperWidget_ThanksButton_Raised'),
          color: PalTheme.of(context.buildContext).colors.dark,
          onPressed: model.showThanksButton ? onTrigger : null,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            transitionBuilder: (Widget child, Animation<double> animation) =>
                ScaleTransition(
              child: child,
              scale: animation,
            ),
            child: model.showThanksButton
                ? Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(
                      thanksButtonLabel?.text ?? 'Thank you !',
                      style: TextStyle(
                        fontSize: thanksButtonLabel?.fontSize ?? 18.0,
                        color: thanksButtonLabel?.fontColor ?? Colors.white,
                      ),
                    ),
                  )
                : AnimatedProgressBar(
                    animationController: context.animationsControllers[1],
                  ),
          ),
        ),
      ),
    );
  }

  SingleChildScrollView _buildReleaseNotes(
    final MvvmContext context,
    final UserUpdateHelperModel model,
  ) {
    return SingleChildScrollView(
      child: Container(
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27.0),
          child: Column(
            key: ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List'),
            children: _buildReleaseNotesLabels(context, model),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildReleaseNotesLabels(
    final MvvmContext context,
    final UserUpdateHelperModel model,
  ) {
    List<Widget> labels = [];
    int index = 0;
    for (CustomLabel label in changelogLabels) {
      var stepTime = 1.0 / changelogLabels.length;
      var animationStart = stepTime * index;
      var animationEnd = stepTime + animationStart;

      Widget textLabel = Padding(
        padding: const EdgeInsets.only(bottom: 8.0),
        child: ReleaseNoteTile(
          index: index++,
          text: label?.text,
          fontColor: label?.fontColor,
          fontSize: label?.fontSize,
          animationController: context.animationsControllers[0],
          animationStart: animationStart,
          animationEnd: animationEnd,
        ),
      );
      labels.add(textLabel);
    }
    return labels;
  }
}
