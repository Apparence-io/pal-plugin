import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor_viewmodel.dart';

void main() {
  group('FontEditor dialog using showDialog', () {

    GlobalKey<NavigatorState> testNavigatorKey = new GlobalKey<NavigatorState>();

    Scaffold _overlayedApplicationPage = Scaffold(
      body: Column(
        children: [
          Text("text1", key: ValueKey("text1"),),
          Text("text2", key: ValueKey("text2")),
          Padding(
            padding: EdgeInsets.only(top: 32),
            child: FlatButton(
              key: ValueKey("MFlatButton"),
              child: Text("tapme"),
              onPressed: () => print("impressed!"),
            ),
          )
        ],
      ),
    );

    Future _beforeEach(WidgetTester tester, WidgetBuilder widgetBuilder)  async {
      var app = PalTheme(
        theme: PalThemeData.light(),
        child: MaterialApp(
          navigatorKey: testNavigatorKey,
          home: _overlayedApplicationPage
        ),
      );
      await tester.pumpWidget(app);
      showDialog(
        context: testNavigatorKey.currentContext,
        builder: widgetBuilder
      );
    }

    testWidgets('Font editor dialog should be displayed correctly using overlay', (WidgetTester tester) async {
      var widgetBuilder = (context) => FontEditorDialogPage(
        onCancelPicker: () => Navigator.of(context).pop(),
        onValidatePicker: () => Navigator.of(context).pop(),
        actualTextStyle: new TextStyle(fontSize: 20),
        fontFamilyKey: 'Montserrat',
        onFontModified: (TextStyle newTextStyle, FontKeys fontKeys) {},
      );
      await _beforeEach(tester, widgetBuilder);
      await tester.pump(Duration(seconds: 2));
      var sliderFinder = find.byKey(ValueKey('pal_FontSizePicker_Slider'));
      expect(sliderFinder, findsOneWidget);
    });

    testWidgets('font size = 20, tap on middle of slider, validate => onFontModified returns a size = 45', (WidgetTester tester) async {
      double selectedFontSize = 20;
      var widgetBuilder = (context) => FontEditorDialogPage(
        onCancelPicker: () => Navigator.of(context).pop(),
        onValidatePicker: () => Navigator.of(context).pop(),
        actualTextStyle: new TextStyle(fontSize: 20),
        fontFamilyKey: 'Montserrat',
        onFontModified: (TextStyle newTextStyle, FontKeys fontKeys) {
          selectedFontSize = newTextStyle.fontSize;
        },
      );
      await _beforeEach(tester, widgetBuilder);
      await tester.pump(Duration(seconds: 2));
      var sliderKey = ValueKey('pal_FontSizePicker_Slider');
      var sliderFinder = find.byKey(sliderKey);
      expect(sliderFinder, findsOneWidget);

      await tester.tap(sliderFinder);
      await tester.pump();
      await tester.tap(find.byKey(ValueKey('pal_FontEditorDialog_ValidateButton')));
      await tester.pump();
      expect(selectedFontSize, closeTo(40.0, 50.0));
    });

    testWidgets('font size = 20, tap on middle of slider, cancel => selectedFontSize = 20', (WidgetTester tester) async {
      double selectedFontSize = 20;
      var widgetBuilder = (context) => FontEditorDialogPage(
        onCancelPicker: () => Navigator.of(context).pop(),
        onValidatePicker: () => Navigator.of(context).pop(),
        actualTextStyle: new TextStyle(fontSize: 20),
        fontFamilyKey: 'Montserrat',
        onFontModified: (TextStyle newTextStyle, FontKeys fontKeys) {
          selectedFontSize = newTextStyle.fontSize;
        },
      );
      await _beforeEach(tester, widgetBuilder);
      await tester.pump(Duration(seconds: 2));
      var sliderKey = ValueKey('pal_FontSizePicker_Slider');
      var sliderFinder = find.byKey(sliderKey);
      expect(sliderFinder, findsOneWidget);

      await tester.tap(sliderFinder);
      await tester.pump();
      await tester.tap(find.byKey(ValueKey('pal_FontEditorDialog_CancelButton')));
      await tester.pump();
      expect(selectedFontSize, equals(20.0));
    });

  });
}