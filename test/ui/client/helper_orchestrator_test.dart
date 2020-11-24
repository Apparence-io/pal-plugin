import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_group_entity.dart';
import 'package:pal/src/database/entity/in_app_user_entity.dart';
import 'package:pal/src/database/entity/page_entity.dart';
import 'package:pal/src/pal_navigator_observer.dart';
import 'package:pal/src/services/client/helper_client_service.dart';
import 'package:pal/src/services/client/in_app_user/in_app_user_client_service.dart';
import 'package:pal/src/services/client/page_client_service.dart';
import 'package:pal/src/ui/client/helper_orchestrator.dart';

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
      when(helperClientServiceMock.getPageNextHelper(any, any)).thenAnswer((_) => Future.value());

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
      verify(helperClientServiceMock.getPageNextHelper("/test1", "db6b01e1-b649-4a17-949a-9ab320601001")).called(1);
      await tester.pumpAndSettle(Duration(seconds: 1));
    });

    testWidgets('changing page will dismiss current helper', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      when(inAppUserClientService.getOrCreate()).thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));

      HelperEntity(id: "1", name: "test1");
      var helperGroup = HelperGroupEntity(
        id: "g1",
        priority: 1,
        page: PageEntity(id: 'p1', route: '/test'),
        helpers: [HelperEntity(id: "1")]
      );
      when(helperClientServiceMock.getPageNextHelper("/test", "db6b01e1-b649-4a17-949a-9ab320601001"))
        .thenAnswer((_) => Future.value(helperGroup));
      when(helperClientServiceMock.getPageNextHelper("/route2", "db6b01e1-b649-4a17-949a-9ab320601001"))
        .thenAnswer((_) => Future.value(null));
      var orchestrator = HelperOrchestrator.create(
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
      var helperGroup = HelperGroupEntity(
        id: "g1",
        priority: 1,
        page: PageEntity(id: 'p1', route: 'route1'),
        helpers: [HelperEntity(id: "1")]
      );

      when(inAppUserClientService.getOrCreate())
        .thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));
      when(helperClientServiceMock
        .getPageNextHelper("test", "db6b01e1-b649-4a17-949a-9ab320601001"))
        .thenAnswer((_) => Future.value(helperGroup));
      var orchestrator = HelperOrchestrator.create(
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