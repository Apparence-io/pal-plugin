import 'package:flutter/widgets.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step_model.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card_swiper.dart';

class CreateHelperTypeStep extends StatelessWidget {
  final CreateHelperModel model;
  final CreateHelperPresenter presenter;

  const CreateHelperTypeStep({
    Key key,
    @required this.model,
    @required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PreviewCardSwiperWidget(
      cards: CreateHelperTypesStepModel.cards,
      onCardSelected: _checkFormValid,
    );
  }

  void _checkFormValid(int index) {
    bool isFormValid = false;
    for (PreviewCard card in CreateHelperTypesStepModel.cards) {
      if (card.isSelected) {
        isFormValid = true;
        model.selectedHelperType = card.helperType;
      }
    }
    model.isFormValid = isFormValid;
    presenter.refreshView();
  }
}
