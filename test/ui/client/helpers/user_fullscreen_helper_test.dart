import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper_presenter.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper_viewmodel.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';
void main() {
  UserFullScreenHelperPresenter presenter;

  group('[Client] Fullscreen helper', () {
    UserFullScreenHelperPage userFullScreenHelperPage =
        UserFullScreenHelperPage(
      helperBoxViewModel:
          HelperBoxViewModel(backgroundColor: Colors.blueAccent),
      titleLabel: HelperTextViewModel(
        text: 'A simple test',
        fontSize: 60.0,
        fontColor: Colors.white,
      ),
      positivLabel: HelperTextViewModel(
        text: 'Positiv button',
        fontSize: 14.0,
        fontColor: Colors.red,
      ),
      negativLabel: HelperTextViewModel(
        text: 'Negativ button',
        fontSize: 12.0,
        fontColor: Colors.black,
      ),
      headerImageViewModel: HelperImageViewModel(
        url: 'https://picsum.photos/200/300',
      ),
      onPositivButtonTap: () async {},
      onNegativButtonTap: () async {},
    );

    _beforeEach(WidgetTester tester) async {
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: PalTheme(
          theme: PalThemeData.light(),
          child: Builder(
            builder: (context) => MaterialApp(
              theme: PalTheme.of(context).buildTheme(),
              home: userFullScreenHelperPage,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pump(Duration(milliseconds: 1100));
      await tester.pump(Duration(milliseconds: 700));
      await tester.pump(Duration(milliseconds: 700));

      final presenterFinder =
          find.byKey(ValueKey('pal_UserFullScreenHelperPage_Builder'));
      final page = presenterFinder.evaluate().first.widget
          as PresenterInherited<UserFullScreenHelperPresenter,
              UserFullScreenHelperModel>;
      presenter = page.presenter;
    }

    testWidgets('should crash when no box was provided',
        (WidgetTester tester) async {
      bool hasThrow = false;
      try {
        var label = CustomLabel(
          text: 'test',
          fontColor: Colors.white,
          fontSize: 23.0,
        );
        UserFullScreenHelperPage helperWidget = UserFullScreenHelperPage(
          titleLabel: label,
          positivLabel: label,
          negativLabel: label,
          onPositivButtonTap: () => null,
          onNegativButtonTap: () => null,
          backgroundColor: null
        );
        var app = new MediaQuery(
            data: MediaQueryData(), child: MaterialApp(home: helperWidget));
        await tester.pumpWidget(app);
      } catch (e) {
        hasThrow = true;
        expect(e.toString().contains("'helperBoxViewModel != null': is not true"),
            isTrue);
      }
      expect(hasThrow, isTrue);
    });

    testWidgets('should crash when no title label was provided',
        (WidgetTester tester) async {
      bool hasThrow = false;
      try {
        UserFullScreenHelperPage helperWidget = UserFullScreenHelperPage(
          helperBoxViewModel: HelperBoxViewModel(
            backgroundColor: Colors.black,
          ),
          positivLabel: HelperTextViewModel(
            text: 'test',
            fontColor: Colors.white,
            fontSize: 23.0,
          ),
          negativLabel: HelperTextViewModel(
            text: 'test',
            fontColor: Colors.white,
            fontSize: 23.0,
          ),
          onNegativButtonTap: () {},
          onPositivButtonTap: () {},
        );
        var app = new MediaQuery(
            data: MediaQueryData(), child: MaterialApp(home: helperWidget));
        await tester.pumpWidget(app);
        await tester.pumpAndSettle(Duration(seconds: 1));
      } catch (e) {
        hasThrow = true;
      }
      expect(hasThrow, isTrue);
    });

    testWidgets('should have valid UI', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(
          find.byKey(ValueKey('pal_UserFullScreenHelperPage')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Media')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Title')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Feedback')),
          findsOneWidget);
      expect(
          find.byKey(
              ValueKey('pal_UserFullScreenHelperPage_Feedback_PositivButton')),
          findsOneWidget);
      expect(
          find.byKey(
              ValueKey('pal_UserFullScreenHelperPage_Feedback_NegativButton')),
          findsOneWidget);
    });

    testWidgets('should have valid data', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.text('A simple test'), findsOneWidget);
      expect(find.text('Positiv button'), findsOneWidget);
      expect(find.text('Negativ button'), findsOneWidget);
    });

    testWidgets('should tap on positiv button', (WidgetTester tester) async {
      await _beforeEach(tester);
      await tester.pump(Duration(milliseconds: 1000));
      final positivButton = find.byKey(
          ValueKey('pal_UserFullScreenHelperPage_Feedback_PositivButton'));
      await tester.tap(positivButton);
      await tester.pump(Duration(milliseconds: 100));
      await tester.pump(Duration(milliseconds: 200));
      await tester.pump(Duration(milliseconds: 1000));
      await tester.pump(Duration(milliseconds: 500));
    });

    testWidgets('should tap on negativ button', (WidgetTester tester) async {
      await _beforeEach(tester);
      await tester.pump(Duration(milliseconds: 1000));
      final negativButton = find.byKey(
          ValueKey('pal_UserFullScreenHelperPage_Feedback_NegativButton'));
      await tester.tap(negativButton);
      await tester.pump(Duration(milliseconds: 100));
      await tester.pump(Duration(milliseconds: 200));
      await tester.pump(Duration(milliseconds: 1000));
      await tester.pump(Duration(milliseconds: 500));
    });
  });
}
