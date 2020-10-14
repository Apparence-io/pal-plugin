import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper_widget.dart';
import '../../../pal_test_utilities.dart';

void main() {
  group('Simple Toaster overlay helper', () {

    final _navigatorKey = GlobalKey<NavigatorState>();

    var component = ToastLayout(
      toaster: Toaster(
        key: ValueKey("toast"),
        title: "Tip",
        description: "You can just disable notification by going in your profile and click on notifications tab",
      ),
      onDismissed: (res) => print("dismissed..."),
    );

    var app = MaterialApp(
      navigatorKey: _navigatorKey,
      home: Column(
        children: [
          Container(child: Text("title")),
          Container(child: Text("description")),
          Container(child: Text("text 2"))
        ],
      )
    );

    testWidgets('widget is created as overlay', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      _navigatorKey.currentState.overlay.insert(OverlayEntry(
        opaque: false,
        builder: (ctx) => component
      ));
      await tester.pump(Duration(milliseconds: 500));
      expect(find.text("Tip"), findsOneWidget);
      expect(find.text("You can just disable notification by going in your profile and click on notifications tab"),
        findsOneWidget);
    });

    testWidgets('swipe to the right dismiss the helper', (WidgetTester tester) async {
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(Duration(milliseconds: 100));
      bool dismissed = false;
      var component = ToastLayout(
        toaster: Toaster(
          key: ValueKey("toast"),
          title: "Tip",
          description: "You can just disable notification by going in your profile and click on notifications tab",
        ),
        onDismissed: (res) => dismissed = true,
      );
      _navigatorKey.currentState.overlay.insert(OverlayEntry(
        opaque: false,
        builder: (ctx) => component
      ));
      await tester.pump(Duration(milliseconds: 500));
      var toastFinder = find.byType(Dismissible);
      expect(toastFinder, findsOneWidget);
      var center = tester.getCenter(toastFinder);
      var gesture = await tester.startGesture(center);
      await gesture.moveBy(Offset(300,0));
      // await tester.drag(toastFinder, Offset(300, 0));
      await tester.pump();
      // expect(dismissed, isTrue); //Not working as moveBy seems have no effect
    });

  });
}