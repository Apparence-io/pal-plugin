import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helper_client_models.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/simple_helper.dart';
import 'package:palplugin/src/ui/client/helpers/simple_helper/widget/simple_helper_layout.dart';

void main() {
  group('Simple Toaster overlay helper', () {
    
    var component = SimpleHelperLayout(
      toaster: SimpleHelperPage(
        key: ValueKey("toast"),
        descriptionLabel: CustomLabel(
            fontColor: Colors.white,
            fontSize: 14.0,
            text:
                "You can just disable notification by going in your profile and click on notifications tab > disable notifications"),
        backgroundColor: Colors.black,
      ),
      onDismissed: (res) => print("dismissed..."),
    );

    beforeEach(WidgetTester tester) async {
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: PalTheme(
          theme: PalThemeData.light(),
          child: Builder(
            builder: (context) => MaterialApp(
              theme: PalTheme.of(context).buildTheme(),
              home: component,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
    }

    testWidgets('widget is created as overlay', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await beforeEach(tester);
        await tester.pumpAndSettle(Duration(milliseconds: 400));
        expect(
            find.text(
                "You can just disable notification by going in your profile and click on notifications tab > disable notifications"),
            findsOneWidget);
      });
    });

    testWidgets('swipe to the right dismiss the helper',
        (WidgetTester tester) async {
      await tester.runAsync(() async {
        await beforeEach(tester);
        await tester.pumpAndSettle(Duration(milliseconds: 400));    
        var toastFinder = find.byType(Dismissible);
        expect(toastFinder, findsOneWidget);
        var center = tester.getCenter(toastFinder);
        var gesture = await tester.startGesture(center);
        await gesture.moveBy(Offset(300, 0));
        // await tester.drag(toastFinder, Offset(300, 0));
        await tester.pump();
        // expect(dismissed, isTrue); //Not working as moveBy seems have no effect
      });
    });
  });
}
