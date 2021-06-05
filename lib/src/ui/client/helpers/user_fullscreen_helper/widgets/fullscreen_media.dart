import 'package:flutter/material.dart';
import 'package:pal/src/ui/client/helpers/animations/combined_animation.dart';
import 'package:pal/src/ui/client/helpers/animations/opacity_anims.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

class FullscreenMedia extends StatelessWidget {

  final AnimationController animationController;
  final AnimationSet mediaAnim;
  final HelperImageViewModel headerImageViewModel;

  const FullscreenMedia({ 
    Key? key,
    required this.animationController,
    required this.mediaAnim,
    required this.headerImageViewModel 
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TranslationOpacityAnimation(
        opacityAnim: mediaAnim.opacity,
        translateAnim: mediaAnim.translation,    
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0),
          child: Image.network(
            headerImageViewModel.url ?? '',
            key: ValueKey('pal_UserFullScreenHelperPage_Media'),
            fit: BoxFit.scaleDown,
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
        controller: animationController,
      );
  }
}