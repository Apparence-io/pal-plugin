import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/widgets/edit_helper_toolbar.dart';

void main() {
  group('Helper toolbar', () {
    EditHelperToolbar editHelperToolbar = EditHelperToolbar();

    _setup(WidgetTester tester) async {
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: PalTheme(
          theme: PalThemeData.light(),
          child: Builder(
            builder: (context) => MaterialApp(
              theme: PalTheme.of(context)!.buildTheme(),
              home: editHelperToolbar,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
    }

    testWidgets('should display correctly', (WidgetTester tester) async {
      await _setup(tester);

      expect(find.byKey(ValueKey('pal_EditHelperToolbar')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_EditHelperToolbar_TextColor')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_EditHelperToolbar_TextFont')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_EditHelperToolbar_Close')), findsOneWidget);
    });
  });
}
