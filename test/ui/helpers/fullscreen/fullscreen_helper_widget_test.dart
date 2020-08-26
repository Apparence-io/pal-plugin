import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/ui/helpers/fullscreen/fullscreen_helper_widget.dart';

void main() {
  group('full screen helper widget', () {

    testWidgets('bgColor is required', (WidgetTester tester) async {
      bool hasThrow = false;
      try {
        FullscreenHelperWidget helperWidget = FullscreenHelperWidget();
        var app = new MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(home: helperWidget)
        );
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
        FullscreenHelperWidget helperWidget = FullscreenHelperWidget(
          bgColor: Colors.black,
        );
        var app = new MediaQuery(
          data: MediaQueryData(),
          child: MaterialApp(home: helperWidget)
        );
        await tester.pumpWidget(app);
        await tester.pumpAndSettle(Duration(seconds: 1));
      } catch (e) {
        hasThrow = true;
        expect(e.toString().contains("'textColor != null': is not true"), isTrue);
      }
      expect(hasThrow, isTrue);
    });

    testWidgets('helper has two actions to dissmiss it. One is positive feedback, other is negative', (WidgetTester tester) async {
      FullscreenHelperWidget helperWidget = FullscreenHelperWidget(
        bgColor: Colors.black,
        textColor: Colors.white,
        helperText: "Lorem ipsum",
        textSize: 21,
      );
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: MaterialApp(home: helperWidget)
      );
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