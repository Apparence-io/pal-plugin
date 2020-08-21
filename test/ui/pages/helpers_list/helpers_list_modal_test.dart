import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal.dart';

main() {
  group('Helpers list modal', () {
    HelpersListModal helpersListModal = HelpersListModal();

    before(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: helpersListModal,
          routes: {
            '/editor/new': (context) =>
                Scaffold(body: Text('Welcome editor new')),
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
