import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_theme/create_helper_theme_step.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_theme/create_helper_theme_step_model.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step_model.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card_swiper.dart';

class CreateHelperPresenterMock extends Mock implements CreateHelperPresenter {}

class CreateHelperModelMock extends Mock implements CreateHelperModel {}

var mockedPresenter = CreateHelperPresenterMock();
var mockedModel = CreateHelperModelMock();

Future _before(WidgetTester tester) async {
  final mockedPresenter = CreateHelperPresenterMock();
  final mockedModel = CreateHelperModelMock();

  when(mockedPresenter.checkValidStep()).thenAnswer((_) => Future.value([]));
  when(mockedModel.selectedHelperType).thenReturn(HelperType.HELPER_FULL_SCREEN);

  // Clean static data
  for (PreviewThemeCard card in CreateHelperThemeStepModel.cards[mockedModel.selectedHelperType]) {
    card.isSelected = false;
  }

  var app = MediaQuery(
    data: MediaQueryData(),
    child: PalTheme(
      theme: PalThemeData.light(),
      child: Builder(
        builder: (context) => MaterialApp(
          theme: PalTheme.of(context).buildTheme(),
          home: CreateHelperThemeStep(
            presenter: mockedPresenter,
            model: mockedModel,
          ),
        ),
      ),
    ),
  );
  await tester.pumpWidget(app);
}

void main() {
  group('[Step 3] Create helper page theme', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _before(tester);

      expect(find.byType(PreviewCardSwiperWidget), findsOneWidget);
      expect(find.byKey(ValueKey('pal_PreviewCard_0')), findsOneWidget);
    });

    testWidgets('should drag pageview', (WidgetTester tester) async {
      await _before(tester);

      await tester.drag(
          find.byKey(ValueKey('pal_PreviewCardSwiperWidget_PageView')),
          const Offset(-40, 0.0));
      await tester.pump();
      await tester.pumpAndSettle();
    });

    testWidgets('should select a card', (WidgetTester tester) async {
      await _before(tester);

      expect(find.byIcon(Icons.check), findsNothing);
      expect(find.byKey(ValueKey('pal_PreviewCard_Check_0')), findsNothing);

      var card0 = find.byKey(ValueKey('pal_PreviewCard_0'));
      await tester.tap(card0);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(find.byKey(ValueKey('pal_PreviewCard_Check_0')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_PreviewCard_Check_1')), findsNothing);
      expect(find.byKey(ValueKey('pal_PreviewCard_Check_2')), findsNothing);
    });
  });
}
