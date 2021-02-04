import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_loader.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_modal.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_modal_presenter.dart';
import 'package:pal/src/ui/editor/pages/helpers_list/helpers_list_modal_viewmodel.dart';

import '../../../../pal_test_utilities.dart';

class HelpersListModalLoaderMock extends Mock
    implements HelpersListModalLoader {}

class EditorHelperServiceMock extends Mock implements EditorHelperService {}

class PalEditModeStateServiceMock extends Mock
    implements PalEditModeStateService {}

main() {
  group('Helpers list modal', () {
    HelpersListModalLoader loader = HelpersListModalLoaderMock();
    EditorHelperService helperService = EditorHelperServiceMock();
    PalEditModeStateService palEditModeStateService =
        PalEditModeStateService.build();
    HelpersListModal helpersListModal = HelpersListModal(
      loader: loader,
      palEditModeStateService: palEditModeStateService,
      helperService: helperService,
    );
    HelpersListModalPresenter presenter;

    when(loader.load()).thenAnswer(
      (realInvocation) => Future.value(
        HelpersListModalModel(
          helpers: [
            HelperEntity(
              id: '1',
              name: 'aName 1',
              triggerType: HelperTriggerType.ON_SCREEN_VISIT,
              type: HelperType.SIMPLE_HELPER,
            ),
            HelperEntity(
              id: '2',
              name: 'aName 2',
              triggerType: HelperTriggerType.ON_SCREEN_VISIT,
              type: HelperType.HELPER_FULL_SCREEN,
            ),
            HelperEntity(
              id: '3',
              name: 'aName 3',
              triggerType: HelperTriggerType.ON_SCREEN_VISIT,
              type: HelperType.UPDATE_HELPER,
            ),
          ],
        ),
      ),
    );

    before(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: helpersListModal,
          routes: {
            '/editor/new': (context) =>
                Scaffold(body: Text('Welcome editor new')),
            '/editor/helper': (context) => Scaffold(body: Text('Helper 3')),
          },
        ),
      );

      final presenterFinder =
          find.byKey(ValueKey('pal_HelpersListModal_MvvmBuilder'));
      final page = presenterFinder.evaluate().first.widget
          as PresenterInherited<HelpersListModalPresenter,
              HelpersListModalModel>;
      presenter = page.presenter;
    }

    void checkHelpersOrder(List<String> oldHelpers) {
      List<String> newHelpersName = presenter.viewModel.helpers
          .map((HelperEntity helperEntity) => helperEntity.name)
          .toList();
      expect(oldHelpers, orderedEquals(newHelpersName));
    }

    testWidgets('should display properly', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();
      expect(find.byKey(ValueKey('pal_HelpersListModal_Close')), findsOneWidget);
      expect(find.byKey(ValueKey('palHelpersListModalContent')), findsOneWidget);
      expect(find.text('PAL editor'), findsOneWidget);
      expect(find.text('💡 You can re-order helpers by long tap on them.'),findsOneWidget);
      expect(find.byKey(ValueKey('pal_HelpersListModal_New')), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    //FIXME versions are now on group
    testWidgets('should display helpers', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();

      expect(find.text('aName 1'), findsOneWidget);
      // expect(find.text('1.0.1 '), findsOneWidget);
      // expect(find.text(' 2.0.0'), findsOneWidget);

      expect(find.text('aName 2'), findsOneWidget);
      // expect(find.text('1.0.2 '), findsOneWidget);
      // expect(find.text(' last'), findsOneWidget);

      expect(find.text('aName 3'), findsOneWidget);
      // expect(find.text('1.8.2 '), findsOneWidget);
      // expect(find.text(' 2.3.0'), findsOneWidget);

      expect(find.text('Overlayed bottom'),
          findsNWidgets(1));
      expect(
          find.text('Fullscreen'), findsNWidgets(1));
      expect(find.text('Update overlay'),
          findsNWidgets(1));
          expect(find.text('On screen visit'),
          findsNWidgets(3));
    });

    testWidgets('should tap on helper', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();

      Finder helper3Button = find.byKey(ValueKey('pal_HelpersListModal_Tile2'));
      await tester.ensureVisible(helper3Button);
      await tester.tap(helper3Button);
      await tester.pumpAndSettle();

      expect(find.text('Helper 3'), findsOneWidget);
    });

    testWidgets('should open new editor page', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();

      Finder newButton = find.byKey(ValueKey('pal_HelpersListModal_New'));
      await tester.ensureVisible(newButton);
      await tester.tap(newButton);
      await tester.pumpAndSettle();

      expect(find.text('Welcome editor new'), findsOneWidget);
    });

    testWidgets('should re-order helpers by drag & drop', (tester) async {
      await before(tester);
      when(helperService.updateHelperPriority(any, any))
          .thenAnswer((realInvocation) => Future.value());
      await tester.pumpAndSettle();

      checkHelpersOrder(['aName 1', 'aName 2', 'aName 3']);
      await longPressDrag(tester, find.text('aName 1'), find.text('aName 2'));
      checkHelpersOrder(['aName 2', 'aName 3', 'aName 1']);
      await tester.pumpAndSettle();
    });

    testWidgets('should cancel drag & drop if any error occurs',
        (tester) async {
      await before(tester);
      when(helperService.updateHelperPriority(any, any))
          .thenAnswer((realInvocation) => throw 'an error :/');
      await tester.pumpAndSettle();

      checkHelpersOrder(['aName 1', 'aName 2', 'aName 3']);
      await longPressDrag(tester, find.text('aName 1'), find.text('aName 2'));
      checkHelpersOrder(['aName 1', 'aName 2', 'aName 3']);
    });
  });
}
