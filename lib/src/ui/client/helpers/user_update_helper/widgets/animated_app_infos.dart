import 'package:flutter/material.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';

class AnimatedAppInfos extends AnimatedWidget {
  final AnimationController animationController;
  final CustomLabel titleLabel;
  final String appVersion;
  
  Animation<double> opacityAnim;
  Animation<double> verticalOffsetAnim;

  AnimatedAppInfos({
    Key key,
    @required this.animationController,
    @required this.titleLabel,
    @required this.appVersion,
  }) : super(key: key, listenable: animationController) {
    this.opacityAnim = Tween<double>(begin: 0, end: 1).animate(
      animationController,
    );
    this.verticalOffsetAnim = Tween<double>(begin: -40, end: 0).animate(
      animationController,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(verticalOffsetAnim.value, 0),
      child: Opacity(
        opacity: opacityAnim != null ? opacityAnim.value : 1,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              titleLabel?.text ?? 'New application update',
              key: ValueKey('pal_UserUpdateHelperWidget_AppSummary_Title'),
              style: TextStyle(
                fontSize: titleLabel?.fontSize ?? 27.0,
                fontWeight: FontWeight.bold,
                color:
                    titleLabel?.fontColor ?? PalTheme.of(context).colors.light,
              ),
            ),
            SizedBox(
              height: 10.0,
            ),
            Text(
              'Version $appVersion',
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
}
