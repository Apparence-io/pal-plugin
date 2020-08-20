import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal_example/ui/pages/route1/route1_page.dart';

main() {
  Route1Page route1page = Route1Page();

  before(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: route1page,
        routes: {
          '/route2': (context) => Scaffold(body: Text('Welcome to route 2')),
        },
      ),
    );
  }

  testWidgets('should display properly', (tester) async {
    await before(tester);
    await tester.pumpAndSettle();

    expect(find.byKey(ValueKey('Route1')), findsOneWidget);
    expect(find.text('Route 1'), findsOneWidget);

    expect(find.byKey(ValueKey('childRoute2Push')), findsOneWidget);
  });
  
  testWidgets('should push to route 2', (tester) async {
    await before(tester);
    await tester.pumpAndSettle();

    Finder child1RouteButton = find.byKey(ValueKey('childRoute2Push'));
    await tester.ensureVisible(child1RouteButton);
    await tester.tap(child1RouteButton);
    await tester.pumpAndSettle();

    expect(find.text('Welcome to route 2'), findsOneWidget);
  });
}
