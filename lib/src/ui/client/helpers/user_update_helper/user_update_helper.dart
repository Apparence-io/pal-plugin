import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/injectors/user_app/user_app_injector.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/user_update_helper_presenter.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/user_update_helper_viewmodel.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/widgets/animated_progress_bar.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/widgets/release_note_cell.dart';
import 'package:pal/src/ui/client/widgets/animated/animated_scale.dart';
import 'package:pal/src/ui/client/widgets/animated/animated_translate.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

abstract class UserUpdateHelperView {
  void playAnimation(
    MvvmContext context,
    bool isReversed,
    int index,
    Function callback,
  );
  void onThanksButtonCallback();
}

class UserUpdateHelperPage extends StatelessWidget
    implements UserUpdateHelperView {
  final HelperBoxViewModel helperBoxViewModel;
  final HelperTextViewModel titleLabel;
  final List<HelperTextViewModel> changelogLabels;
  final HelperButtonViewModel thanksButtonLabel;
  final PackageVersionReader packageVersionReader;
  final HelperImageViewModel helperImageViewModel;
  final Function onPositivButtonTap;

  UserUpdateHelperPage({
    Key key,
    @required this.helperBoxViewModel,
    @required this.titleLabel,
    @required this.changelogLabels,
    @required this.onPositivButtonTap,
    this.helperImageViewModel,
    this.thanksButtonLabel,
    this.packageVersionReader,
  })  : assert(helperBoxViewModel != null),
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
          // Changelog
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 1100,
            ),
          ),
          // Progress bar
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 5000,
            ),
          ),
          // Image logo
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 700,
            ),
          ),
          // Title
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 700,
            ),
          ),
        ];
      },
      animListener: (context, presenter, model) {
        if (model.changelogCascadeAnimation) {
          this.playAnimation(
            context,
            model.isReversedAnimations,
            0,
            presenter.onCascadeAnimationEnd,
          );
        }
        if (model.progressBarAnimation) {
          this.playAnimation(
            context,
            model.isReversedAnimations,
            1,
            presenter.onProgressBarAnimationEnd,
          );
        }
        if (model.imageAnimation) {
          this.playAnimation(
            context,
            model.isReversedAnimations,
            2,
            presenter.onImageAnimationEnd,
          );
        }
        if (model.titleAnimation) {
          this.playAnimation(
            context,
            model.isReversedAnimations,
            3,
            presenter.onTitleAnimationEnd,
          );
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
        backgroundColor: helperBoxViewModel?.backgroundColor,
        body: SafeArea(
          child: Container(
            width: double.infinity,
            child: Container(
              child: Column(
                children: [
                  if (helperImageViewModel?.url != null && helperImageViewModel.url.length > 0)
                    Flexible(
                      key: ValueKey('pal_UserUpdateHelperWidget_Icon'),
                      flex: 4,
                      child: _buildMedia(context),
                    ),
                  Flexible(
                    key: ValueKey('pal_UserUpdateHelperWidget_AppSummary'),
                    flex: 2,
                    child: _buildAppSummary(context, model),
                  ),
                  Expanded(
                    key: ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes'),
                    flex: 5,
                    child: _buildReleaseNotes(context, model),
                  ),
                  _buildThanksButton(context, model, presenter),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedia(
    final MvvmContext context,
  ) {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: AnimatedScaleWidget(
          widget: ClipRRect(
            borderRadius: BorderRadius.circular(15.0),
            child: CachedNetworkImage(
              key: ValueKey('pal_UserUpdateHelperWidget_Image'),
              imageUrl: helperImageViewModel?.url,
              fit: BoxFit.contain,
              placeholder: (context, url) =>
                  Center(child: CircularProgressIndicator()),
              errorWidget: (BuildContext context, String url, dynamic error) {
                return Image.asset(
                  'packages/pal/assets/images/create_helper.png',
                );
              },
            ),
          ),
          animationController: context.animationsControllers[2],
        ),
      ),
    );
  }

  Container _buildAppSummary(
    final MvvmContext context,
    final UserUpdateHelperModel model,
  ) {
    return Container(
      width: double.infinity,
      child: AnimatedTranslateWidget(
        position: Tween<Offset>(begin: Offset(-1.0, 0.0), end: Offset(0, 0)),
        animationController: context.animationsControllers[3],
        widget: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                titleLabel?.text ?? 'New application update',
                key: ValueKey('pal_UserUpdateHelperWidget_AppSummary_Title'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: titleLabel?.fontSize ?? 27.0,
                  fontWeight: titleLabel?.fontWeight ?? FontWeight.normal,
                  color: titleLabel?.fontColor ??
                      PalTheme.of(context.buildContext).colors.light,
                ).merge(
                  GoogleFonts.getFont(titleLabel?.fontFamily ?? 'Montserrat'),
                ),
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Version ${model.appVersion ?? '1.0.0'}',
              key: ValueKey('pal_UserUpdateHelperWidget_AppSummary_Version'),
              style: TextStyle(
                fontSize: 13.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox _buildThanksButton(
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
          onPressed: model.showThanksButton
              ? () {
                  HapticFeedback.selectionClick();
                  presenter.onThanksButtonCallback();
                }
              : null,
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
                      key: ValueKey('pal_UserUpdateHelperWidget_ThanksButton_Label'),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: thanksButtonLabel?.fontSize ?? 18.0,
                        color: thanksButtonLabel?.fontColor ?? Colors.white,
                        fontWeight:
                            thanksButtonLabel?.fontWeight ?? FontWeight.normal,
                      ).merge(
                        GoogleFonts.getFont(
                            thanksButtonLabel?.fontFamily ?? 'Montserrat'),
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
    for (HelperTextViewModel label in changelogLabels) {
      var stepTime = 1.0 / changelogLabels.length;
      var animationStart = stepTime * index;
      var animationEnd = stepTime + animationStart;

      labels.add(
        ReleaseNoteCell(
          index: index++,
          customLabel: label,
          animationController: context.animationsControllers[0],
          positionCurve: Interval(
            animationStart,
            animationEnd,
            curve: Curves.decelerate,
          ),
          opacityCurve: Interval(
            animationStart,
            animationEnd,
            curve: Curves.decelerate,
          ),
        ),
      );
    }
    return labels;
  }

  @override
  void playAnimation(
    MvvmContext context,
    bool isReversed,
    int index,
    Function callback,
  ) {
    if (isReversed) {
      context.animationsControllers[index]
          .reverse()
          .then((value) => callback());
    } else {
      context.animationsControllers[index]
          .forward()
          .then((value) => callback());
    }
  }

  @override
  void onThanksButtonCallback() {
    if (this.onPositivButtonTap != null) {
      this.onPositivButtonTap();
    }
  }
}
