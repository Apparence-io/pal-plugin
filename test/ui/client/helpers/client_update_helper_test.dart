import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/user_update_helper.dart';

class PackageVersionReaderMock extends Mock implements PackageVersionReader {}

void main() {
  group('[Client] Update helper widget', () {
    var packageVersionReaderService = PackageVersionReaderMock();

    when(packageVersionReaderService.init()).thenAnswer((_) => Future.value());
    when(packageVersionReaderService.version).thenReturn('0.0.1');

    UserUpdateHelperPage userUpdateHelperWidget = UserUpdateHelperPage(
      onPositivButtonTap: () {},
      packageVersionReader: packageVersionReaderService,
      helperBoxViewModel: HelperBoxViewModel(backgroundColor: Colors.blue),
      thanksButtonLabel: HelperTextViewModel(
        text: 'Free Ademo',
        fontColor: Colors.white,
        fontSize: 9.0,
      ),
      titleLabel: HelperTextViewModel(
        text: 'N.O.S au secours',
        fontColor: Colors.red,
        fontSize: 27.0,
      ),
      changelogLabels: [
        HelperTextViewModel(
          text: 'My feature 1',
          fontColor: Colors.white,
          fontSize: 14.0,
        ),
        HelperTextViewModel(
          text: 'My feature 2',
          fontColor: Colors.black,
          fontSize: 22.0,
        ),
        HelperTextViewModel(
          text: 'My feature 3',
          fontColor: Colors.red,
          fontSize: 14.0,
        ),
        HelperTextViewModel(
          text: 'My feature 4',
          fontColor: Colors.white,
          fontSize: 19.0,
        ),
      ],
      helperImageViewModel: HelperImageViewModel(
        url: 'https://picsum.photos/id/237/200/300',
      ),
    );

    beforeEach(WidgetTester tester) async {
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: PalTheme(
          theme: PalThemeData.light(),
          child: Builder(
            builder: (context) => MaterialApp(
              theme: PalTheme.of(context).buildTheme(),
              home: userUpdateHelperWidget,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
      await tester.pump(Duration(milliseconds: 1100));
      await tester.pump(Duration(milliseconds: 5000));
      await tester.pump(Duration(milliseconds: 700));
      await tester.pump(Duration(milliseconds: 700));
    }

    testWidgets('should display all elements', (WidgetTester tester) async {
      await beforeEach(tester);
      expect(find.byKey(ValueKey('pal_UserUpdateHelperWidget_Scaffold')),
          findsOneWidget);

      expect(find.byKey(ValueKey('pal_UserUpdateHelperWidget_Icon')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_UserUpdateHelperWidget_Image')),
          findsOneWidget);

      expect(find.byKey(ValueKey('pal_UserUpdateHelperWidget_AppSummary')),
          findsOneWidget);
      expect(
          find.byKey(ValueKey('pal_UserUpdateHelperWidget_AppSummary_Title')),
          findsOneWidget);
      expect(
          find.byKey(ValueKey('pal_UserUpdateHelperWidget_AppSummary_Version')),
          findsOneWidget);

      expect(find.byKey(ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes')),
          findsOneWidget);
      expect(
          find.byKey(ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List')),
          findsOneWidget);

      expect(find.byKey(ValueKey('pal_UserUpdateHelperWidget_ThanksButton')),
          findsOneWidget);
    });

    testWidgets('should display correct title', (WidgetTester tester) async {
      await beforeEach(tester);
      expect(find.text('N.O.S au secours'), findsOneWidget);
      var titleLabel =
          (tester.firstWidget(find.text('N.O.S au secours')) as Text);
      expect(titleLabel.style.color, Colors.red);
      expect(titleLabel.style.fontSize, 27.0);
    });

    testWidgets('should display correct thanks button',
        (WidgetTester tester) async {
      await beforeEach(tester);
      await tester.pump(Duration(milliseconds: 4000));
      expect(find.text('Free Ademo'), findsOneWidget);
      var buttonFinder = find
          .byKey(ValueKey('pal_UserUpdateHelperWidget_ThanksButton_Raised'));
      var button = buttonFinder.evaluate().first.widget as RaisedButton;
      expect(button.color, Color(0xff03045e));
    });

    testWidgets('should display release notes', (WidgetTester tester) async {
      await beforeEach(tester);
      expect(
        find.byKey(ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_0')),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_1')),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_2')),
        findsOneWidget,
      );
      expect(
        find.byKey(ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_3')),
        findsOneWidget,
      );

      final richText0Finder = find.byKey(
        ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_0'),
      );
      final richText1Finder = find.byKey(
        ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_1'),
      );
      final richText2Finder = find.byKey(
        ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_2'),
      );
      final richText3Finder = find.byKey(
        ValueKey('pal_UserUpdateHelperWidget_ReleaseNotes_List_3'),
      );
      final richText0Widget =
          tester.element(richText0Finder).widget as RichText;
      final richText1Widget =
          tester.element(richText1Finder).widget as RichText;
      final richText2Widget =
          tester.element(richText2Finder).widget as RichText;
      final richText3Widget =
          tester.element(richText3Finder).widget as RichText;

      // FIXME: Impossible to use children without using the deprecated one
      final textSpan0 = richText0Widget.text.children.last as TextSpan;
      final textSpan1 = richText1Widget.text.children.last as TextSpan;
      final textSpan2 = richText2Widget.text.children.last as TextSpan;
      final textSpan3 = richText3Widget.text.children.last as TextSpan;

      expect(textSpan0.style.color, Colors.white);
      expect(textSpan0.style.fontSize, 14.0);
      expect(textSpan0.text, 'My feature 1');

      expect(textSpan1.style.color, Colors.black);
      expect(textSpan1.style.fontSize, 22.0);
      expect(textSpan1.text, 'My feature 2');

      expect(textSpan2.style.color, Colors.red);
      expect(textSpan2.style.fontSize, 14.0);
      expect(textSpan2.text, 'My feature 3');

      expect(textSpan3.style.color, Colors.white);
      expect(textSpan3.style.fontSize, 19.0);
      expect(textSpan3.text, 'My feature 4');
    });
  });
}
