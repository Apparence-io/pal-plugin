import 'package:flutter/widgets.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_theme/create_helper_theme_step_model.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step_model.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card_swiper.dart';

class CreateHelperThemeStep extends StatelessWidget {
  final CreateHelperModel model;
  final CreateHelperPresenter presenter;

  const CreateHelperThemeStep({
    Key key,
    @required this.model,
    @required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreviewCardSwiperWidget(
      note: 'Note : you can customize colors / fonts… after this',
      onCardSelected: _checkFormValid,
      cards: CreateHelperThemeStepModel.cards[model.selectedHelperType],
    );
  }

  void _checkFormValid(int index) {
    bool isFormValid = false;
    for (PreviewThemeCard card in CreateHelperThemeStepModel.cards[model.selectedHelperType]) {
      if (card.isSelected) {
        isFormValid = true;
        model.selectedHelperTheme = card.helperTheme;
      }
    }
    model.isFormValid = isFormValid;
    presenter.refreshView();
  }
}
