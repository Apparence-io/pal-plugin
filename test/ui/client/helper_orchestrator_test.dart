import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/in_app_user_entity.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/client/helper_client_service.dart';
import 'package:palplugin/src/services/client/in_app_user/in_app_user_client_service.dart';
import 'package:palplugin/src/services/client/page_client_service.dart';
import 'package:palplugin/src/ui/client/helper_orchestrator.dart';

import '../../pal_test_utilities.dart';


class HelperClientServiceMock extends Mock implements HelperClientService {}

class PageClientServiceMock extends Mock implements PageClientService {}

class InAppUserClientServiceMock extends Mock implements InAppUserClientService {}


class SamplePage extends StatelessWidget {

  String value;

  SamplePage(this.value);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Container(child: Text(value)));
  }
}


void main() {
  group('HelperOrchestrator', () {

    var helperClientServiceMock = HelperClientServiceMock();

    InAppUserClientService inAppUserClientService = InAppUserClientServiceMock();

    final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();

    Route<dynamic> route(RouteSettings settings) {
      switch (settings.name) {
        case '/':
          return MaterialPageRoute(builder: (context) => SamplePage('New'));
        case '/test1':
          return MaterialPageRoute(builder: (context) => SamplePage('New1'));
        case '/test2':
          return MaterialPageRoute(builder: (context) => SamplePage('New3'));
        default:
          throw 'unexpected Route';
      }
    }

    setUp(() {
      reset(inAppUserClientService);
      reset(helperClientServiceMock);
    });

    testWidgets('should create properly and accessible from children', (WidgetTester tester) async {
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);
      expect(HelperOrchestrator.getInstance(), isNotNull);
    });

    testWidgets('call helperService to get what needs to be shown on each route', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      when(inAppUserClientService.getOrCreate()).thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));
      when(helperClientServiceMock.getPageHelpers(any, any)).thenAnswer((_) => Future.value([]));

      var orchestrator = HelperOrchestrator.create(
        helperClientService: helperClientServiceMock,
        inAppUserClientService: inAppUserClientService,
        routeObserver: routeObserver,
        navigatorKey: navigatorKey
      );
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text("New"), findsOneWidget);

      // FIXME in test => routeObserver receives only null RouteSettings using this
      // navigatorKey.currentState.pushNamed("/test1");
      // expect(find.text("New1"), findsOneWidget);
      await orchestrator.onChangePage("/test1");
      verify(helperClientServiceMock.getPageHelpers("/test1", "db6b01e1-b649-4a17-949a-9ab320601001"), ).called(1);
      await tester.pumpAndSettle(Duration(seconds: 1));
    });

    testWidgets('changing page will dismiss current helper', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      when(inAppUserClientService.getOrCreate()).thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));
      when(helperClientServiceMock.getPageHelpers("/test", "db6b01e1-b649-4a17-949a-9ab320601001")).thenAnswer((_) => Future.value([
        HelperEntity(id: "1", name: "test1")
      ]));
      when(helperClientServiceMock.getPageHelpers("/route2", "db6b01e1-b649-4a17-949a-9ab320601001")).thenAnswer((_) => Future.value([]));
      var orchestrator = HelperOrchestrator.getInstance(
        helperClientService: helperClientServiceMock,
        inAppUserClientService: inAppUserClientService,
        routeObserver: routeObserver,
        navigatorKey: navigatorKey
      );
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);

      await orchestrator.onChangePage("/test");
      expect(orchestrator.overlay, isNotNull);
      await orchestrator.onChangePage("/route2");
      expect(orchestrator.overlay, isNull);
    });

    testWidgets('only one overlay at a time', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      when(inAppUserClientService.getOrCreate()).thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));
      when(helperClientServiceMock
        .getPageHelpers("test", "db6b01e1-b649-4a17-949a-9ab320601001"))
        .thenAnswer((_) => Future.value([
          HelperEntity(id: "1", name: "test1")
        ]));
      var orchestrator = HelperOrchestrator.getInstance(
        helperClientService: helperClientServiceMock,
        inAppUserClientService: inAppUserClientService,
        routeObserver: routeObserver,
        navigatorKey: navigatorKey
      );
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);
      expect(orchestrator.overlay, isNot(isList));
    });

  });
}