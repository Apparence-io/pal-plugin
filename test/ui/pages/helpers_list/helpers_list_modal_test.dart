import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal.dart';

main() {
  HelpersListModal helpersListModal = HelpersListModal();

  before(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: helpersListModal,
      ),
    );
  }

  testWidgets('should display properly', (tester) async {
    await before(tester);
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey('palHelpersListModal')), findsOneWidget);

    expect(find.text('Pal editor'), findsOneWidget);
    expect(find.text('Helpers list here'), findsOneWidget);

    expect(find.byKey(ValueKey('palHelpersListModalNew')), findsOneWidget);
    expect(find.byIcon(Icons.add_circle_outline), findsOneWidget);
  });
}
