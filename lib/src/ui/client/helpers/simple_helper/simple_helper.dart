import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/simple_helper_presenter.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/simple_helper_viewmodel.dart';
import 'package:pal/src/ui/client/widgets/animated/animated_translate.dart';
import 'package:pal/src/ui/shared/widgets/circle_button.dart';

import '../../../shared/helper_shared_viewmodels.dart';

abstract class SimpleHelperView {}

class SimpleHelperPage extends StatelessWidget implements SimpleHelperView {
  final HelperTextViewModel descriptionLabel;
  final HelperBoxViewModel? helperBoxViewModel;

  SimpleHelperPage({
    Key? key,
    required this.descriptionLabel,
    this.helperBoxViewModel,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<SimpleHelperPresenter, SimpleHelperModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => SimpleHelperPresenter(this),
      builder: (mvvmContext, presenter, model) {
        final Animation<double> offsetAnimation = Tween(begin: 0.0, end: 20.0)
            .chain(CurveTween(curve: Curves.elasticIn))
            .animate(mvvmContext.animationsControllers![2]);

        return AnimatedTranslateWidget(
          position: Tween<Offset>(
            begin: Offset(0.0, 1.0),
            end: Offset(0.0, 0.0),
          ),
          animationController: mvvmContext.animationsControllers![0],
          widget: SafeArea(
            child: Column(
              children: [
                AnimatedBuilder(
                    animation: offsetAnimation,
                    builder: (context, child) {
                      return Transform.translate(
                        offset: Offset(offsetAnimation.value, 0.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: PalTheme.of(context)!.colors.black, //this.helperBoxViewModel?.backgroundColor,
                            borderRadius:
                                BorderRadius.all(Radius.circular(8.0)),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black26,
                                offset: Offset(0, 8),
                                blurRadius: 8,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 16,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              mainAxisSize: MainAxisSize.max,
                              children: <Widget>[
                                _buildLeft(mvvmContext),
                                _buildContent(),
                                _buildRight(mvvmContext),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                SizedBox(height: 5.0),
                Text(
                  '💡 You can swipe to dismiss the helper.',
                  style: TextStyle(
                    fontSize: 12.0,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      multipleAnimControllerBuilder: (tickerProvider) {
        return [
          // Box transition
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 1100,
            ),
          ),
          // Thumb
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 500,
            ),
          ),
          // Shake
          AnimationController(
            vsync: tickerProvider,
            duration: Duration(
              milliseconds: 500,
            ),
          ),
        ];
      },
      animListener: (context, presenter, model) {
        if (model.boxTransitionAnimation) {
          context.animationsControllers![0].forward().then(
                (value) => presenter.onBoxAnimationEnd(),
              );
        }
        if (model.thumbAnimation) {
          context.animationsControllers![1].repeat(reverse: true).then(
                (value) => presenter.onThumbAnimationEnd(),
              );
        }
        if (model.shakeAnimation) {
          context.animationsControllers![2].forward().then(
            (value) {
              presenter.onShakeAnimationEnd();
              context.animationsControllers![2].reverse();
            },
          );
        }
      },
    );
  }

  Widget _buildLeft(MvvmContext mvvmContext) {
    return Transform.translate(
      offset: Offset(-25.0, 0),
      child: CircleIconButton(
        backgroundColor: Colors.redAccent,
        icon: Icon(
          Icons.thumb_down,
          color: Colors.white,
          size: 15,
        ),
        onTapCallback: () {},
      ),
    );
  }

  Widget _buildRight(MvvmContext mvvmContext) {
    return Transform.translate(
      offset: Offset(25.0, 0),
      child: CircleIconButton(
        backgroundColor: Colors.greenAccent,
        icon: Icon(
          Icons.thumb_up,
          color: Colors.white,
          size: 15,
        ),
        onTapCallback: () {},
      ),
    );
  }

  Flexible _buildContent() {
    return Flexible(
      flex: 10,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text(
                descriptionLabel.text ?? '',
                key: ValueKey('SimpleHelperContentText'),
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: descriptionLabel.fontColor ?? Colors.white,
                  fontSize: descriptionLabel.fontSize ?? 14.0,
                  fontWeight: descriptionLabel.fontWeight ?? FontWeight.normal,
                ).merge(
                  GoogleFonts.getFont(
                      descriptionLabel.fontFamily ?? 'Montserrat'),
                ),
                maxLines: 10,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
