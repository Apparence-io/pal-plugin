import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_family_picker/font_family_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_family_picker/font_family_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_family_picker/font_family_picker_viewmodel.dart';

class FontFamilyPickerLoaderMock extends Mock
    implements FontFamilyPickerLoader {}

void main() {
  group('Font family picker', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _beforeEach(tester);

      // Check if page exist
      expect(find.byKey(ValueKey('pal_FontFamilyPicker')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontFamilyPicker_SearchBarField')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontFamilyPicker_ListView')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontFamilyPicker_ResultsLabel')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontFamilyPicker')), findsOneWidget);
      expect(find.text('Font family'), findsOneWidget);
    });

    testWidgets('should listview correctly displayed',
        (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.byType(ListTile), findsNWidgets(6));
      expect(find.byKey(ValueKey('pal_FontFamilyPicker_ListView_ListTile0')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontFamilyPicker_ListView_ListTile1')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontFamilyPicker_ListView_ListTile2')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontFamilyPicker_ListView_ListTile3')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontFamilyPicker_ListView_ListTile4')),
          findsOneWidget);
      expect(find.byKey(ValueKey('pal_FontFamilyPicker_ListView_ListTile5')),
          findsOneWidget);

      expect(find.byKey(ValueKey('pal_FontFamilyPicker_ListView_ListTile6')),
          findsNothing);

      expect(find.byIcon(Icons.check), findsOneWidget);
      expect(
          find.byKey(ValueKey('pal_FontFamilyPicker_ListView_ListTile_Check3')),
          findsOneWidget);
    });

    testWidgets('should search bar works', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.text('6 results'), findsOneWidget);

      var searchBarField =
          find.byKey(ValueKey('pal_FontFamilyPicker_SearchBarField'));
      await tester.enterText(searchBarField, 'Crimson Pro');
      await tester.pumpAndSettle();
      expect(find.text('Crimson Pro'), findsNWidgets(2));

      expect(find.text('1 result'), findsOneWidget);
    });
  });
}

Future _beforeEach(
  WidgetTester tester,
) async {
  final loader = FontFamilyPickerLoaderMock();
  List<String> fonts = [
    'Aldrich',
    'Averia Serif Libre',
    'Crimson Pro',
    'Finger Paint',
    'Libre Barcode 39 Extended Text',
    'Michroma',
  ];
  FontFamilyPickerModel viewModel = FontFamilyPickerModel(
    fonts: fonts,
    originalFonts: List.from(fonts),
  );
  when(loader.load()).thenAnswer((realInvocation) => Future.value(viewModel));

  final component = FontFamilyPickerPage(
    loader: loader,
    arguments: FontFamilyPickerArguments(
      fontFamilyName: 'Finger Paint',
      fontWeightName: 'Normal',
    ),
  );
  await tester.pumpWidget(
    MediaQuery(
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
    ),
  );
  await tester.pumpAndSettle();
}
