import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/widgets/edit_helper_toolbar.dart';

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
              theme: PalTheme.of(context).buildTheme(),
              home: editHelperToolbar,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
    }

    testWidgets('should display correctly', (WidgetTester tester) async {
      await _setup(tester);

      expect(find.byKey(ValueKey('palToolbar')), findsOneWidget);
      expect(find.byKey(ValueKey('palToolbarEditText')), findsOneWidget);
      expect(find.byKey(ValueKey('palToolbarChangeBorder')), findsOneWidget);
      expect(find.byKey(ValueKey('palToolbarChangeFont')), findsOneWidget);
      expect(find.byKey(ValueKey('palToolbarClose')), findsOneWidget);
    });
  });
}
