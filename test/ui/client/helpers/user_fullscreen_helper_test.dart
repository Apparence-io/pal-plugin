import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper_widget.dart';

void main() {
  group('[Client] Fullscreen helper', () {
    testWidgets('bgColor is required', (WidgetTester tester) async {
      bool hasThrow = false;
      try {
        UserFullscreenHelperWidget helperWidget = UserFullscreenHelperWidget();
        var app = new MediaQuery(
            data: MediaQueryData(), child: MaterialApp(home: helperWidget));
        await tester.pumpWidget(app);
      } catch (e) {
        hasThrow = true;
        expect(e.toString().contains("'bgColor != null': is not true"), isTrue);
      }
      expect(hasThrow, isTrue);
    });

    testWidgets('textColor is required', (WidgetTester tester) async {
      bool hasThrow = false;
      try {
        UserFullscreenHelperWidget helperWidget = UserFullscreenHelperWidget(
          bgColor: Colors.black,
        );
        var app = new MediaQuery(
            data: MediaQueryData(), child: MaterialApp(home: helperWidget));
        await tester.pumpWidget(app);
        await tester.pumpAndSettle(Duration(seconds: 1));
      } catch (e) {
        hasThrow = true;
        expect(
            e.toString().contains("'textColor != null': is not true"), isTrue);
      }
      expect(hasThrow, isTrue);
    });

    testWidgets(
        'helper has two actions to dissmiss it. One is positive feedback, other is negative',
        (WidgetTester tester) async {
      UserFullscreenHelperWidget helperWidget = UserFullscreenHelperWidget(
        bgColor: Colors.black,
        textColor: Colors.white,
        helperText: "Lorem ipsum",
        textSize: 21,
      );
      var app = new MediaQuery(
          data: MediaQueryData(), child: MaterialApp(home: helperWidget));
      await tester.pumpWidget(app);
      await tester.pumpAndSettle(Duration(seconds: 1));

      expect(find.byType(InkWell), findsNWidgets(2));
      var positivFeedback = find.byKey(ValueKey("positiveFeedback"));
      var negativFeedback = find.byKey(ValueKey("negativeFeedback"));
      expect(positivFeedback, findsOneWidget);
      expect(negativFeedback, findsOneWidget);
    });
  });
}
