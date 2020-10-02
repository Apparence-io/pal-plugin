import 'package:application_icon/application_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/shared/widgets/circle_button.dart';

class AnimatedAppIcon extends AnimatedWidget {
  final double radius;
  final Function onTap;
  final AnimationController animationController;

  AnimatedAppIcon({
    Key key,
    @required this.radius,
    @required this.animationController,
    this.onTap,
  }) : super(key: key, listenable: animationController);

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: Tween(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(
          parent: animationController,
          curve: Curves.elasticOut,
        ),
      ),
      child: Container(
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 4,
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipOval(child: AppIconImage()),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleIconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: PalTheme.of(context).colors.light,
                  ),
                  backgroundColor: PalTheme.of(context).colors.dark,
                  onTapCallback: () {
                    if (onTap != null) {
                      HapticFeedback.selectionClick();
                      onTap();
                    }
                  },
                ),
              )
            ],
          ),
        ),
    );
  }
}
