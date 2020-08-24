import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/ui/pages/editor/editor.dart';

void main() {
  group('Editor', () {

    var editorPageBuilder = EditorPageBuilder();

    testWidgets('should create page correctly', (WidgetTester tester) async {
      var app = new MediaQuery(data: MediaQueryData(), child: MaterialApp(
        onGenerateRoute: (_) => MaterialPageRoute(builder: editorPageBuilder.build),
      ));
      await tester.pumpWidget(app);
      // page exists
      expect(find.byType(EditorPageBuilder), findsOneWidget);
      // has a menu bar
      var bottomBarFinder = find.byType(BottomNavigationBar);
      expect(bottomBarFinder, findsOneWidget);
      // has 5 menu
      BottomNavigationBar nav = bottomBarFinder.evaluate().first.widget as BottomNavigationBar;
      expect(nav.items.length, 5);
    });

  });
}