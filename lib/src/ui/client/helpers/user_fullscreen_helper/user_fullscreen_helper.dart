import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/client/widgets/animated/animated_scale.dart';
import 'package:pal/src/ui/client/widgets/animated/animated_translate.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

import 'user_fullscreen_helper_presenter.dart';
import 'user_fullscreen_helper_viewmodel.dart';

abstract class UserFullScreenHelperView {
  void playAnimation(
    MvvmContext context,
    bool isReversed,
    int index,
    Function callback,
  );
  void onPositivButtonCallback();
  void onNegativButtonCallback();
}

class UserFullScreenHelperPage extends StatelessWidget
    implements UserFullScreenHelperView {

      // TODO: Create description field !!!!

  final HelperBoxViewModel helperBoxViewModel;
  final HelperTextViewModel titleLabel;
  final HelperButtonViewModel positivLabel;
  final HelperButtonViewModel negativLabel;
  final HelperImageViewModel headerImageViewModel;
  final Function onPositivButtonTap;
  final Function onNegativButtonTap;

  UserFullScreenHelperPage({
    Key key,
    @required this.helperBoxViewModel,
    @required this.titleLabel,
    @required this.onPositivButtonTap,
    @required this.onNegativButtonTap,
    this.headerImageViewModel,
    this.positivLabel,
    this.negativLabel,
  })  : assert(helperBoxViewModel != null),
        assert(titleLabel != null),
        assert(onPositivButtonTap != null),
        assert(onNegativButtonTap != null);

  final _mvvmPageBuilder = MVVMPageBuilder<UserFullScreenHelperPresenter,
      UserFullScreenHelperModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('pal_UserFullScreenHelperPage_Builder'),
      context: context,
      multipleAnimControllerBuilder: (tickerProvider) {
        return [
          // Media
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 1100,
            ),
          ),
          // Title
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 700,
            ),
          ),
          // Feedback
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 700,
            ),
          ),
        ];
      },
      animListener: (context, presenter, model) {
        if (model.mediaAnimation) {
          this.playAnimation(
            context,
            model.isReversedAnimations,
            0,
            presenter.onMediaAnimationEnd,
          );
        }
        if (model.titleAnimation) {
          this.playAnimation(
            context,
            model.isReversedAnimations,
            1,
            presenter.onTitleAnimationEnd,
          );
        }
        if (model.feedbackAnimation) {
          this.playAnimation(
            context,
            model.isReversedAnimations,
            2,
            presenter.onFeedbackAnimationEnd,
          );
        }
      },
      presenterBuilder: (context) => UserFullScreenHelperPresenter(this),
      builder: (context, presenter, model) => _buildPage(context, presenter, model),
    );
  }

  Widget _buildPage(
    final MvvmContext context,
    final UserFullScreenHelperPresenter presenter,
    final UserFullScreenHelperModel model,
  ) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      curve: Curves.fastOutSlowIn,
      opacity: model?.helperOpacity,
      child: Scaffold(
        backgroundColor: helperBoxViewModel?.backgroundColor,
        key: _scaffoldKey,
        body: SafeArea(
          child: Container(
            key: ValueKey('pal_UserFullScreenHelperPage'),
            width: double.infinity,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (headerImageViewModel?.url != null && headerImageViewModel.url.length > 0)
                    Flexible(
                      key: ValueKey('pal_UserFullScreenHelperPage_Media'),
                      flex: 3,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: _buildMedia(context),
                      ),
                    ),
                  Flexible(
                    flex: 4,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 40.0),
                      child: _buildTitle(context),
                    ),
                  ),
                  Container(
                    key: ValueKey('pal_UserFullScreenHelperPage_Feedback'),
                    child: Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: _buildFeedback(context, presenter),
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

  Widget _buildMedia(MvvmContext context) {
    return AnimatedScaleWidget(
      widget: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: CachedNetworkImage(
          imageUrl: headerImageViewModel?.url,
          fit: BoxFit.cover,
          placeholder: (context, url) =>
              Center(child: CircularProgressIndicator()),
          errorWidget: (BuildContext context, String url, dynamic error) {
            return Image.asset(
                'packages/pal/assets/images/create_helper.png');
          },
        ),
      ),
      animationController: context.animationsControllers[0],
    );
  }

  Widget _buildTitle(MvvmContext context) {
    return AnimatedTranslateWidget(
      animationController: context.animationsControllers[1],
      widget: SingleChildScrollView(
        child: Text(
          titleLabel?.text ?? 'Title',
          key: ValueKey('pal_UserFullScreenHelperPage_Title'),
          textAlign: TextAlign.center,
          style: TextStyle(
            color: titleLabel?.fontColor ?? Colors.white,
            fontSize: titleLabel?.fontSize ?? 60.0,
            fontWeight: titleLabel?.fontWeight,
          ).merge(GoogleFonts.getFont(titleLabel?.fontFamily ?? 'Montserrat')),
        ),
      ),
    );
  }

  Widget _buildFeedback(
      MvvmContext context, UserFullScreenHelperPresenter presenter) {
    return AnimatedTranslateWidget(
      position: Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset(0.0, 0.0)),
      animationController: context.animationsControllers[2],
      widget: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              key: ValueKey(
                  'pal_UserFullScreenHelperPage_Feedback_PositivButton'),
              onPressed: () {
                HapticFeedback.selectionClick();
                presenter.onPositivButtonCallback();
              },
              color: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  positivLabel?.text ?? 'Ok, thanks !',
                  key: ValueKey(
                  'pal_UserFullScreenHelperPage_Feedback_PositivLabel'),
                  style: TextStyle(
                    color: positivLabel?.fontColor ?? Colors.white,
                    fontSize: positivLabel?.fontSize ?? 23.0,
                    fontWeight: positivLabel?.fontWeight ?? FontWeight.bold,
                  ).merge(GoogleFonts.getFont(
                      positivLabel?.fontFamily ?? 'Montserrat')),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 10.0,
          ),
          SizedBox(
            width: double.infinity,
            child: RaisedButton(
              key: ValueKey('pal_UserFullScreenHelperPage_Feedback_NegativButton'),
              onPressed: () {
                HapticFeedback.selectionClick();
                presenter.onNegativButtonCallback();
              },
              color: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  negativLabel?.text ?? 'This is not helping',
                  key: ValueKey(
                  'pal_UserFullScreenHelperPage_Feedback_NegativLabel'),
                  style: TextStyle(
                    color: negativLabel?.fontColor ?? Colors.white,
                    fontSize: negativLabel?.fontSize ?? 13.0,
                    fontWeight: negativLabel?.fontWeight ?? FontWeight.bold,
                  ).merge(GoogleFonts.getFont(
                      negativLabel?.fontFamily ?? 'Montserrat')),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  void onNegativButtonCallback() {
    this.onNegativButtonTap();
  }

  @override
  void onPositivButtonCallback() {
    this.onPositivButtonTap();
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
}
