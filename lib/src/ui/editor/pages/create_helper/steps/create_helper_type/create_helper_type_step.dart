import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step_model.dart';
import 'package:pal/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card_swiper.dart';

class CreateHelperTypeStep extends StatelessWidget {
  final CreateHelperModel model;
  final CreateHelperPresenter presenter;

  const CreateHelperTypeStep({
    Key? key,
    required this.model,
    required this.presenter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PreviewCardSwiperWidget(
        cards: CreateHelperTypesStepModel.cards,
        onCardSelected: _checkFormValid,
      ),
    );
  }

  void _checkFormValid(int index) {
    bool isFormValid = false;
    for (PreviewTypeCard card in CreateHelperTypesStepModel.cards) {
      if (card.isSelected) {
        isFormValid = true;
        model.selectedHelperType = card.helperType;
      }
    }
    model.selectedHelperTheme = null;
    model.isFormValid?.value = isFormValid;
    presenter.refreshView();
  }
}
