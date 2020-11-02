import 'package:pal/src/database/entity/helper/helper_theme.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card.dart';

class PreviewThemeCard extends PreviewCard {
  final HelperTheme helperTheme;

  PreviewThemeCard(
    String previewImage,
    String title,
    String description,
    this.helperTheme,
  ) : super(
          previewImage,
          title,
          description,
        );
}

class CreateHelperThemeStepModel {
  static final Map<HelperType, List<PreviewThemeCard>> cards = {
    HelperType.HELPER_FULL_SCREEN: [
      PreviewThemeCard(
        'packages/pal/assets/images/create_helper/themes/black/helper_theme_black_fullscreen.png',
        'Blacked fullscreen',
        'A classy pre-configured black fullscreen theme for your helpers.',
        HelperTheme.BLACK,
      ),
    ],
    HelperType.SIMPLE_HELPER: [
      PreviewThemeCard(
        'packages/pal/assets/images/create_helper/themes/black/helper_theme_black_simple.png',
        'Basic black box',
        'This will show a customizable box on the screen containing your helper text',
        HelperTheme.BLACK,
      ),
    ],
    HelperType.UPDATE_HELPER: [
      PreviewThemeCard(
        'packages/pal/assets/images/create_helper/themes/black/helper_theme_black_update.png',
        'Blacked update overlay',
        'A shiny black update overlay. Try to explain your update to your user with maximum 3 points to be sure they read it !',
        HelperTheme.BLACK,
      ),
    ],
  };
}
