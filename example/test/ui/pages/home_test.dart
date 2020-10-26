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

      expect(find.byKey(ValueKey('demo_HomePage')), findsOneWidget);

      expect(find.text('Pal demo'), findsOneWidget);

      expect(find.text('Trending now'), findsOneWidget);

      expect(find.text('Get a look here'), findsOneWidget);

      expect(find.text('One more'), findsOneWidget);
      expect(find.text('Second one'), findsOneWidget);

      expect(find.byKey(ValueKey('demo_HomePage_Cards_Truman')), findsOneWidget);
      expect(find.byKey(ValueKey('demo_HomePage_Cards_Gump')), findsOneWidget);
      expect(find.byKey(ValueKey('demo_HomePage_Cards_Joker')), findsOneWidget);
    });

    group('child navigation should work', () {
      testWidgets('should push to route 1', (tester) async {
        await before(tester);
        await tester.pumpAndSettle();

        Finder child1RouteButton = find.byKey(ValueKey('demo_HomePage_Cards_Joker'));
        await tester.ensureVisible(child1RouteButton);
        await tester.tap(child1RouteButton);
        await tester.pumpAndSettle();

        expect(find.text('Welcome to route 1'), findsOneWidget);
      });

      testWidgets('should push to route 2', (tester) async {
        await before(tester);
        await tester.pumpAndSettle();

        Finder child1RouteButton = find.byKey(ValueKey('demo_HomePage_Cards_Gump'));
        await tester.ensureVisible(child1RouteButton);
        await tester.tap(child1RouteButton);
        await tester.pumpAndSettle();

        expect(find.text('Welcome to route 2'), findsOneWidget);
      });
    });
  });
}
