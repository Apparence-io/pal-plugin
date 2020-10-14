import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card.dart';

class PreviewTypeCard extends PreviewCard {
  final HelperType helperType;

  PreviewTypeCard(
    String previewImage,
    String title,
    String description,
    this.helperType,
  ) : super(
          previewImage,
          title,
          description,
        );
}

class CreateHelperTypesStepModel {
  static final List<PreviewTypeCard> cards = [
      PreviewTypeCard(
        'packages/palplugin/assets/images/create_helper/types/helper_type_simple.png',
        'Overlayed bottom helper',
        'This will show a customizable box over the screen containing your helper text. User can swipe it left or right to dismiss it.',
        HelperType.SIMPLE_HELPER,
      ),
      PreviewTypeCard(
        'packages/palplugin/assets/images/create_helper/types/helper_type_fullscreen.png',
        'Fullscreen helper',
        'This will show a customizable fullscreen helper to your user. User can dismiss it using one of the two feedback buttons. You can add an image from your gallery.',
        HelperType.HELPER_FULL_SCREEN,
      ),
      PreviewTypeCard(
        'packages/palplugin/assets/images/create_helper/types/helper_type_update.png',
        'Update overlay',
        'This will show a customizable fullscreen helper to your user. This trigger when user has download an update to the current version. This will be shown first to your user and just one time.',
        HelperType.UPDATE_HELPER,
      ),
    ];
}