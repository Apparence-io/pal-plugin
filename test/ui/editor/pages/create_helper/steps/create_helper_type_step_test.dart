import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_type/create_helper_type_step_model.dart';
import 'package:pal/src/ui/editor/pages/create_helper/widgets/preview_card_swiper/preview_card_swiper.dart';

class CreateHelperPresenterMock extends Mock implements CreateHelperPresenter {}

class CreateHelperModelMock extends Mock implements CreateHelperModel {}

Future _before(WidgetTester tester) async {
  final mockedPresenter = CreateHelperPresenterMock();
  final mockedModel = CreateHelperModelMock();

  when(() => mockedPresenter.checkValidStep()).thenAnswer((_) => Future.value([]));
  when(() => mockedModel.selectedHelperType).thenReturn(null);

  // Clean static data
  for (PreviewTypeCard card in CreateHelperTypesStepModel.cards) {
    card.isSelected = false;
  }

  final app = MediaQuery(
    data: MediaQueryData(),
    child: PalTheme(
      theme: PalThemeData.light(),
      child: Builder(
        builder: (context) => MaterialApp(
          theme: PalTheme.of(context)!.buildTheme(),
          home: CreateHelperTypeStep(
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
  group('[Step 2] Create helper page type', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _before(tester);

      expect(find.byType(PreviewCardSwiperWidget), findsOneWidget);
      expect(find.byKey(ValueKey('pal_PreviewCard_0')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_PreviewCard_1')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_PreviewCard_2')), findsNothing);
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

    testWidgets('should select only one card', (WidgetTester tester) async {
      await _before(tester);

      var card0 = find.byKey(ValueKey('pal_PreviewCard_0'));
      await tester.tap(card0);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);

      var card1 = find.byKey(ValueKey('pal_PreviewCard_1'));
      await tester.tap(card1);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.check), findsOneWidget);
    });
  });
}
