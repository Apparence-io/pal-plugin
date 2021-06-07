import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper_presenter.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper_viewmodel.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/widgets/onboarding_progress.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';
import '../../screen_tester_utilities.dart';

void main() {
  UserFullScreenHelperPresenter presenter; // ignore: unused_local_variable

  group('[Client] Fullscreen helper', () {

    createPage({GroupViewModel? group}) {
    return UserFullScreenHelperPage(
      group: group ?? GroupViewModel(
        index: 0,
        steps: 0
      ),
      helperBoxViewModel: HelperBoxViewModel(backgroundColor: Colors.blueAccent),
      titleLabel: HelperTextViewModel(
        text: 'A simple test',
        fontSize: 28.0,
        fontColor: Colors.white,
      ),
      descriptionLabel: HelperTextViewModel(
        text: 'A description test',
        fontSize: 16.0,
        fontColor: Colors.white,
      ),
      positivLabel: HelperButtonViewModel(
        text: 'Positiv button',
        fontSize: 14.0,
        fontColor: Colors.red,
      ),
      negativLabel: HelperButtonViewModel(
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
  }
    
    _beforeEach(WidgetTester tester, UserFullScreenHelperPage page) async {
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: PalTheme(
          theme: PalThemeData.light(),
          child: Builder(
            builder: (context) => MaterialApp(
              theme: PalTheme.of(context)!.buildTheme(),
              home: page,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pump(Duration(milliseconds: 500));
      await tester.pump(Duration(milliseconds: 2000));
      presenter = page.presenter;
    }

    testWidgets('should have valid UI', (WidgetTester tester) async {
      await tester.setIphone11Max();
      await _beforeEach(tester, createPage());
      await tester.pump(Duration(milliseconds: 2000));
      expect(
          find.byKey(ValueKey('pal_UserFullScreenHelperPage')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Media')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Title')),
          findsOneWidget);
      expect(
          find.byKey(
              ValueKey('pal_UserFullScreenHelperPage_Feedback_PositivButton')),
          findsOneWidget);
      expect(
          find.byKey(
              ValueKey('pal_UserFullScreenHelperPage_Feedback_NegativButton')),
          findsOneWidget);
      await tester.pumpAndSettle(Duration(milliseconds: 100));
    });

    testWidgets('should have valid data', (WidgetTester tester) async {
      await tester.setIphone11Max();
      await _beforeEach(tester, createPage());
      await tester.pump(Duration(milliseconds: 2000));
      expect(find.text('A simple test'), findsOneWidget);
      expect(find.text('Positiv button'), findsOneWidget);
      expect(find.text('Negativ button'), findsOneWidget);

      await tester.pumpAndSettle(Duration(milliseconds: 100));
    });

    testWidgets('group has 3 helpers => show progress with 3 steps', (WidgetTester tester) async {
      await tester.setIphone11Max();
      await _beforeEach(tester, createPage(group: GroupViewModel(index: 0, steps: 3)));
      await tester.pump(Duration(milliseconds: 2000));
      expect(find.byType(OnboardingProgress), findsOneWidget);
      var progress = find.byType(OnboardingProgress).evaluate().first.widget as OnboardingProgress;
      expect(progress.steps, equals(3));
      expect(progress.progression, equals(0));
    });

    testWidgets('group has 1 helpers => do not show progress', (WidgetTester tester) async {
      await tester.setIphone11Max();
      await _beforeEach(tester, createPage());
      await tester.pump(Duration(milliseconds: 2000));
      expect(find.byType(OnboardingProgress), findsNothing);
    });

    testWidgets('should tap on negativ button', (WidgetTester tester) async {
      await tester.setIphone11Max();
      await _beforeEach(tester, createPage());
      final negativButton = find.byKey(
          ValueKey('pal_UserFullScreenHelperPage_Feedback_NegativButton'));
      expect(negativButton, findsOneWidget);
      await tester.tap(negativButton);

      await tester.pumpAndSettle(Duration(milliseconds: 100));
      await tester.pump(Duration(milliseconds: 2000));
    });

    testWidgets('should tap on positiv button', (WidgetTester tester) async {
      await tester.setIphone11Max();
      await _beforeEach(tester, createPage());
      final positivButton = find.byKey(
          ValueKey('pal_UserFullScreenHelperPage_Feedback_PositivButton'));
      await tester.tap(positivButton);

      await tester.pumpAndSettle(Duration(milliseconds: 100));
    });
  });

  
}
