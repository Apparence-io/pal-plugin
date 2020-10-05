import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/services/pal/pal_state_service.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_modal.dart';
import 'package:palplugin/src/ui/editor/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalLoaderMock extends Mock
    implements HelpersListModalLoader {}
class PalEditModeStateServiceMock extends Mock
    implements PalEditModeStateService {}

main() {
  group('Helpers list modal', () {
    HelpersListModalLoader loader = HelpersListModalLoaderMock();
    PalEditModeStateService palEditModeStateService = PalEditModeStateService.build();
    HelpersListModal helpersListModal = HelpersListModal(
      loader: loader,
      palEditModeStateService: palEditModeStateService,
    );

    when(loader.load()).thenAnswer(
        (realInvocation) => Future.value(HelpersListModalModel(helpers: [
              HelperEntity(
                id: '1',
                name: 'aName',
                triggerType: HelperTriggerType.ON_SCREEN_VISIT,
                versionMin: '1.0.1',
                versionMax: '2.0.0',
              ),
              HelperEntity(
                id: '2',
                name: 'aName 2',
                triggerType: HelperTriggerType.ON_SCREEN_VISIT,
                versionMin: '1.0.2',
              ),
              HelperEntity(
                id: '3',
                name: 'aName 3',
                triggerType: HelperTriggerType.ON_SCREEN_VISIT,
                versionMin: '1.8.2',
                versionMax: '2.3.0',
              ),
            ])));

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
    }

    testWidgets('should display properly', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey('palHelpersListModal')), findsOneWidget);

      expect(find.byKey(ValueKey('palHelpersListModalClose')), findsOneWidget);
      expect(
          find.byKey(ValueKey('palHelpersListModalContent')), findsOneWidget);

      expect(find.text('PAL editor'), findsOneWidget);
      expect(
          find.text('List of available helpers on this page'), findsOneWidget);

      expect(find.byKey(ValueKey('palHelpersListModalNew')), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);
    });

    testWidgets('should display helpers', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();

      expect(find.text('aName'), findsOneWidget);
      expect(find.text('1.0.1 - 2.0.0'), findsOneWidget);

      expect(find.text('aName 2'), findsOneWidget);
      expect(find.text('1.0.2 - last'), findsOneWidget);

      expect(find.text('aName 3'), findsOneWidget);
      expect(find.text('1.8.2 - 2.3.0'), findsOneWidget);

      expect(find.text('ON_SCREEN_VISIT'), findsNWidgets(3));
    });

    testWidgets('should tap on helper', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();

      Finder helper3Button = find.byKey(ValueKey('palHelpersListModalTile2'));
      await tester.ensureVisible(helper3Button);
      await tester.tap(helper3Button);
      await tester.pumpAndSettle();

      expect(find.text('Helper 3'), findsOneWidget);
    });

    testWidgets('should open new editor page', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();

      Finder newButton = find.byKey(ValueKey('palHelpersListModalNew'));
      await tester.ensureVisible(newButton);
      await tester.tap(newButton);
      await tester.pumpAndSettle();

      expect(find.text('Welcome editor new'), findsOneWidget);
    });
  });
}
