import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/helpers/editor_simple_helper/editor_simple_helper.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/helper_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/widgets/edit_helper_toolbar.dart';

void main() {
  group('simple helper widget', () {
    group('client mode', () {
      // TODO: Create client mode
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
                home: Material(
                  child: EditorSimpleHelperPage(
                    viewModel: SimpleHelperViewModel(),
                  ),
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

        expect(find.byType(TextFormField), findsOneWidget);
        expect(find.text('Edit me!'), findsOneWidget);
      });

      testWidgets('toolbar can be closed', (WidgetTester tester) async {
        await _before(tester);

        expect(find.byType(EditHelperToolbar), findsOneWidget);

        var closeButtonToolbar = find.byKey(ValueKey('palToolbarClose'));
        await tester.tap(closeButtonToolbar);
        await tester.pumpAndSettle();

        expect(find.byType(EditHelperToolbar), findsNothing);
      });

      testWidgets('text can be entered', (WidgetTester tester) async {
        await _before(tester);

        var simpleHelperDetailTextField = find.byKey(ValueKey('palSimpleHelperDetailField'));
        await tester.enterText(simpleHelperDetailTextField, 'Hello!');
        await tester.pumpAndSettle();
        expect(find.text('Hello!'), findsOneWidget);
      });
    });
  });
}
