import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/services/editor/finder/finder_service.dart';
import 'package:palplugin/src/ui/shared/utilities/element_finder.dart';

import '../../../pal_test_utilities.dart';

void main() {
  group('finder with multiple pages app', () {

    final _navigatorKey = GlobalKey<NavigatorState>();

    FinderService finderService;

    _createPage(int n) {
      return Scaffold(
        key: ValueKey("page$n"),
        body: Column(
          children: [
            Text("Test Text", key: ValueKey("p${n}Text1")),
            Text("Test Text 2", key: ValueKey("p${n}Text2")),
            Text("Test Text 3", key: ValueKey("p${n}Text3")),
            Container(key: ValueKey("container"), height: 50, width: 150)
          ],
        ),
      );
    }

    _before(WidgetTester tester) async {
      var routeFactory = (settings) {
        switch(settings.name) {
          case '/':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => _createPage(0),
            );
          case '/page1':
            return MaterialPageRoute(
              settings: settings,
              builder: (context) => _createPage(1),
            );
        }
      };
      await initAppWithPal(tester, null, _navigatorKey, routeFactory: routeFactory);
      // go to page 2
      Navigator.of(_navigatorKey.currentContext).pushNamed("/page1");
      await tester.pumpAndSettle(Duration(milliseconds: 500));
      expect(find.byKey(ValueKey("p0Text1")), findsNothing);
      expect(find.byKey(ValueKey("p1Text1")), findsOneWidget);
      finderService = EditorInjector.of(_navigatorKey.currentContext).finderService;
      expect(finderService, isNotNull);
    }

    testWidgets('only current page items should be available', (WidgetTester tester) async {
      await _before(tester);
      var element = await finderService.searchChildElement("p0Text1");
      expect(element.element, isNull);
      var element2 = await finderService.searchChildElement("p1Text1");
      expect(element2.element, isNotNull);
    });

  });

}