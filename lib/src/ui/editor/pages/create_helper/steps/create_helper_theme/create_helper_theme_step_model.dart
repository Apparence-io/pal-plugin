import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card.dart';

class CreateHelperThemeStepModel {
  static final Map<HelperType, List<PreviewCard>> cards = {
    HelperType.HELPER_FULL_SCREEN: [
      PreviewCard(
        'packages/palplugin/assets/images/create_helper/themes/black/helper_theme_black_fullscreen.png',
        'Blacked fullscreen',
        'A classy pre-configured black fullscreen theme for your helpers.',
      ),
    ],
    HelperType.SIMPLE_HELPER: [
      PreviewCard(
        'packages/palplugin/assets/images/create_helper/themes/black/helper_theme_black_simple.png',
        'Basic black box',
        'This will show a customizable box on the screen containing your helper text',
      ),
    ],
    HelperType.UPDATE_HELPER: [
      PreviewCard(
        'packages/palplugin/assets/images/create_helper/themes/black/helper_theme_black_update.png',
        'Blacked update overlay',
        'A shiny black update overlay. Try to explain your update to your user with maximum 3 points to be sure they read it !',
      ),
    ],
  };
}
