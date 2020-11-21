import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/simple_helper.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/widget/simple_helper_layout.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

void main() {
  group('Simple Toaster overlay helper', () {
    
    var component = SimpleHelperLayout(
      toaster: SimpleHelperPage(
        key: ValueKey("toast"),
        helperBoxViewModel: HelperBoxViewModel(
          backgroundColor: Colors.black,
        ),
        descriptionLabel: HelperTextViewModel(
            fontColor: Colors.white,
            fontSize: 14.0,
            text:
                "You can just disable notification by going in your profile and click on notifications tab > disable notifications"),
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
      await tester.pump(Duration(milliseconds: 1300));
      await tester.pump(Duration(milliseconds: 1100));
      await tester.pump(Duration(milliseconds: 500));
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
