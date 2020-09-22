import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper_widget.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_fullscreen_helper/editor_fullscreen_helper.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';

void main() {
  group('full screen helper widget', () {
    group('user mode', () {
      testWidgets('bgColor is required', (WidgetTester tester) async {
        bool hasThrow = false;
        try {
          UserFullscreenHelperWidget helperWidget =
              UserFullscreenHelperWidget();
          var app = new MediaQuery(
              data: MediaQueryData(), child: MaterialApp(home: helperWidget));
          await tester.pumpWidget(app);
        } catch (e) {
          hasThrow = true;
          expect(
              e.toString().contains("'bgColor != null': is not true"), isTrue);
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
          expect(e.toString().contains("'textColor != null': is not true"),
              isTrue);
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

    group('editor mode', () {
      _before(WidgetTester tester) async {
        var app = new MediaQuery(
          data: MediaQueryData(),
          child: PalTheme(
            theme: PalThemeData.light(),
            child: Builder(
              builder: (context) => MaterialApp(
                theme: PalTheme.of(context).buildTheme(),
                home: EditorFullScreenHelperPage(
                  viewModel: FullscreenHelperViewModel(),
                ),
              ),
            ),
          ),
        );
        await tester.pumpWidget(app);
        await tester.pumpAndSettle(Duration(seconds: 1));
      }

      testWidgets('textfield is present', (WidgetTester tester) async {
        await _before(tester);

        expect(find.byType(TextField), findsOneWidget);
        expect(find.text('Edit me!'), findsOneWidget);
      });
    });
  });
}