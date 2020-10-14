import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal_example/main.dart';

main() {
  _before(WidgetTester tester) async {
    TestWidgetsFlutterBinding.ensureInitialized();

    MyApp myApp = MyApp();
    await tester.pumpWidget(myApp);
  }

  group('Hosted app integration', () {
    testWidgets('should be visible', (tester) async {
      await _before(tester);

      expect(find.byKey(ValueKey('palMainStack')), findsOneWidget);

      Finder hostedApp = find.byKey(ValueKey('hostedApp'));
      expect(hostedApp, findsOneWidget);
      await tester.ensureVisible(hostedApp);

      expect(find.byKey(ValueKey('Home')), findsOneWidget);
    });
  });

  group('Pal integration', () {
    testWidgets('should be visible', (tester) async {
      await _before(tester);

      expect(find.byKey(ValueKey('palMainStack')), findsOneWidget);

      Finder palBubble = find.byKey(ValueKey('palBubbleOverlay'));
      expect(palBubble, findsOneWidget);
      await tester.ensureVisible(palBubble);
    });

    // FIXME: Test can't pass because a network call is called from HelpersListModalLoader
    // need to mock HelpersListModal
    // testWidgets('floating bubble should be tappable', (tester) async {
    //   await before(tester);
    //   await tester.pumpAndSettle();

    //   Finder floatingBubble = find.byKey(ValueKey('palBubbleOverlay'));
    //   await tester.ensureVisible(floatingBubble);
    //   await tester.tap(floatingBubble);
    //   await tester.pumpAndSettle();

    //   // Helpers list modal should be visible
    //   Finder palHelpersListModal = find.byKey(ValueKey('palHelpersListModal'));
    //   expect(palHelpersListModal, findsOneWidget);
    //   await tester.ensureVisible(palHelpersListModal);

    //   // Hosted app should be visible
    //   Finder hostedApp = find.byKey(ValueKey('hostedApp'));
    //   expect(hostedApp, findsOneWidget);
    //   await tester.ensureVisible(hostedApp);

    //   // Close the modal
    //   Finder closeButton = find.byKey(ValueKey('palHelpersListModalClose'));
    //   expect(closeButton, findsOneWidget);
    //   await tester.ensureVisible(closeButton);
    //   await tester.tap(closeButton);
    //   await tester.pumpAndSettle();

    //   // Helpers modal should not be visible
    //   expect(find.byKey(ValueKey('palHelpersListModal')), findsNothing);
    // });

    testWidgets('floating bubble should be draggable', (tester) async {
      await _before(tester);

      // Check if the floating bubble exist & be visible
      Finder floatingBubble = find.byKey(ValueKey('palBubbleOverlay'));
      await tester.ensureVisible(floatingBubble);
      Offset oldBubblePosition = tester.getCenter(floatingBubble);

      // Fling the widget to given offset
      Offset dragOffset = Offset(10.0, -40.0);
      await tester.fling(floatingBubble, dragOffset, 3);
      await tester.pumpAndSettle();

      // Test if the position of the bubble was modified by the offset
      Offset newBubblePosition =
          tester.getCenter(find.byKey(ValueKey('palBubbleOverlay')));
      expect(
          newBubblePosition.dx, equals(oldBubblePosition.dx + dragOffset.dx));
      expect(
          newBubblePosition.dy, equals(oldBubblePosition.dy + dragOffset.dy));
    });
  });
}
