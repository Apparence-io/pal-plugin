import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal_example/ui/pages/route2/route2_page.dart';

main() {
  group('Route 2 page', () {
    Route2Page route2page = Route2Page();

    before(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: route2page,
        ),
      );
    }

    testWidgets('should display properly', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey('Route2')), findsOneWidget);
      expect(find.text('Route 2'), findsOneWidget);

      expect(find.byKey(ValueKey('childRoutePop')), findsOneWidget);
    });
  });
}
