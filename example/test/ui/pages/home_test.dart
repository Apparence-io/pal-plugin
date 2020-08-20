import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal_example/ui/pages/home/home_page.dart';

main() {
  group('Home page', () {
    HomePage homePage = HomePage();

    before(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: homePage,
          routes: {
            '/route1': (context) => Scaffold(body: Text('Welcome to route 1')),
            '/route2': (context) => Scaffold(body: Text('Welcome to route 2')),
          },
        ),
      );
    }

    testWidgets('should display properly', (tester) async {
      await before(tester);
      await tester.pumpAndSettle();

      expect(find.byKey(ValueKey('Home')), findsOneWidget);
      expect(find.byTooltip('Increment'), findsOneWidget);
      expect(find.byIcon(Icons.add), findsOneWidget);

      expect(find.text('Pal example'), findsOneWidget);
      expect(find.text('You have pushed the button this many times:'),
          findsOneWidget);

      expect(find.byKey(ValueKey('childRoute1Push')), findsOneWidget);
      expect(find.byKey(ValueKey('childRoute2Push')), findsOneWidget);
    });

    group('child navigation should work', () {
      testWidgets('should push to route 1', (tester) async {
        await before(tester);
        await tester.pumpAndSettle();

        Finder child1RouteButton = find.byKey(ValueKey('childRoute1Push'));
        await tester.ensureVisible(child1RouteButton);
        await tester.tap(child1RouteButton);
        await tester.pumpAndSettle();

        expect(find.text('Welcome to route 1'), findsOneWidget);
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
    });
  });
}
