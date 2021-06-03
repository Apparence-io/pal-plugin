import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/client/helpers/animations/combined_animation.dart';
import 'package:pal/src/ui/client/helpers/animations/opacity_anims.dart';
import 'package:pal/src/ui/client/widgets/animated/animated_scale.dart';
import 'package:pal/src/ui/client/widgets/animated/animated_translate.dart';
import 'package:pal/src/ui/client/widgets/helper_button_widget.dart';
import 'package:pal/src/ui/client/widgets/screen_text_widget.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';
import 'user_fullscreen_helper_presenter.dart';
import 'user_fullscreen_helper_viewmodel.dart';

abstract class UserFullScreenHelperView {
  void playAnimation(
    MvvmContext context,
    bool isReversed,
    Function callback,
  );
  void onPositivButtonCallback();
  void onNegativButtonCallback();
}

class UserFullScreenHelperPage extends StatelessWidget
    implements UserFullScreenHelperView {
  final HelperBoxViewModel helperBoxViewModel;
  final HelperTextViewModel titleLabel;
  final HelperTextViewModel descriptionLabel;
  final HelperButtonViewModel? positivLabel;
  final HelperButtonViewModel? negativLabel;
  final HelperImageViewModel? headerImageViewModel;
  final Function onPositivButtonTap;
  final Function onNegativButtonTap;

  UserFullScreenHelperPage({
    Key? key,
    required this.helperBoxViewModel,
    required this.titleLabel,
    required this.descriptionLabel,
    required this.onPositivButtonTap,
    required this.onNegativButtonTap,
    this.headerImageViewModel,
    this.positivLabel,
    this.negativLabel,
  });

  final _mvvmPageBuilder = MVVMPageBuilder<UserFullScreenHelperPresenter,UserFullScreenHelperModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  late final AnimationController pageAnimationController;
  late final AnimationSet mediaAnim, titleAnim, descriptionAnim;

  @visibleForTesting
  get presenter => _mvvmPageBuilder.presenter;

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      multipleAnimControllerBuilder: (tickerProvider) {
        pageAnimationController = AnimationController(
          vsync: tickerProvider, 
          duration: Duration(milliseconds: 2000)
        );
        mediaAnim = AnimationSet.fadeAndTranslate(pageAnimationController, .2);
        titleAnim = AnimationSet.fadeAndTranslate(pageAnimationController, .4);
        descriptionAnim = AnimationSet.fadeAndTranslate(pageAnimationController, .5);
        
        return [pageAnimationController];
      },
      animListener: (context, presenter, model) {
        if (model.animate!) {
          this.playAnimation(
            context,
            model.isReversedAnimations!,
            presenter.onAnimationEnd,
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
    return Scaffold(
      backgroundColor: helperBoxViewModel.backgroundColor,
      key: _scaffoldKey,
      body: SafeArea(
        child: Container(
          key: ValueKey('pal_UserFullScreenHelperPage'),
          width: double.infinity,
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 40),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  flex: 0,
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      HelperButton(
                        buttonKey: ValueKey('pal_UserFullScreenHelperPage_Feedback_NegativButton'),
                        model: negativLabel!,
                        onPressed:  () {
                          HapticFeedback.selectionClick();
                          presenter.onNegativButtonCallback();
                        },
                      )
                    ]
                  )
                ),
                Column(
                  children: [
                    if (headerImageViewModel?.url != null &&
                        headerImageViewModel!.url!.length > 0)
                      Flexible(
                        key: ValueKey('pal_UserFullScreenHelperPage_Media'),
                        flex: 0,
                        fit: FlexFit.tight,
                        child: _buildMedia(context),
                      ),
                    Flexible(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 24.0, bottom: 40.0),
                        child: _buildTitle(context),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    key: ValueKey('pal_UserFullScreenHelperPage_Feedback'),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: SizedBox(
                        width: double.infinity,
                        child: HelperButton(
                          buttonKey: ValueKey('pal_UserFullScreenHelperPage_Feedback_PositivButton'),
                          model: positivLabel!,
                          onPressed:  () {
                            HapticFeedback.selectionClick();
                            presenter.onPositivButtonCallback();
                          },
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMedia(MvvmContext context) {
    return TranslationOpacityAnimation(
      opacityAnim: mediaAnim.opacity,
      translateAnim: mediaAnim.translateHorizontal,    
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15.0),
        child: Image.network(
          headerImageViewModel?.url ?? '',
          fit: BoxFit.cover,
          loadingBuilder: (context, child, chunk) {
            if(chunk != null && chunk.expectedTotalBytes != null && chunk.cumulativeBytesLoaded < chunk.expectedTotalBytes!) {
              return Center(child: CircularProgressIndicator(
                value: chunk.cumulativeBytesLoaded / chunk.expectedTotalBytes!,
              ));
            }
            return child;
          },
          errorBuilder: (BuildContext context, dynamic _, dynamic error) 
            => Image.asset('assets/images/create_helper.png', package: 'pal'),
        ),
      ),
      controller: context.animationsControllers![0],
    );
  }

  Widget _buildTitle(MvvmContext context) 
    => SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TranslationOpacityAnimation(
            controller: pageAnimationController,
            opacityAnim: titleAnim.opacity,
            translateAnim: titleAnim.translateHorizontal,    
            child: ScreenText(
              textKey: ValueKey('pal_UserFullScreenHelperPage_Title'),
              model: titleLabel,
            ) 
          ),
          SizedBox(height: 8),
          TranslationOpacityAnimation(
            controller: pageAnimationController,
            opacityAnim: descriptionAnim.opacity,
            translateAnim: descriptionAnim.translateHorizontal,      
            child: ScreenText(
              textKey: ValueKey('pal_UserFullScreenHelperPage_Description'),
              model: descriptionLabel,
            ) 
          ),
        ],
      ),
    );


  ////////////////////////////////
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
    Function callback,
  ) {
    if (isReversed) {
      context.animationsControllers![0]
          .reverse()
          .then((value) => callback());
    } else {
      context.animationsControllers![0]
          .forward()
          .then((value) => callback());
    }
  }
}
