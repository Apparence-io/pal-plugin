
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
import 'package:pal/src/services/client/versions/version.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/ui/client/helper_orchestrator.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper.dart';
import 'package:pal/src/ui/client/helpers_synchronizer.dart';

import '../../pal_test_utilities.dart';
import 'helper_mocks.dart';


class HelperClientServiceMock extends Mock implements HelperClientService {}

class PageClientServiceMock extends Mock implements PageClientService {}

class InAppUserClientServiceMock extends Mock implements InAppUserClientService {}

class HelperSynchronizerMock extends Mock implements HelpersSynchronizer {}

class PackageVersionReaderMock extends Mock implements PackageVersionReader {}


class SamplePage extends StatelessWidget {

  final String value;

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
    HelpersSynchronizer helperSynchronizer = HelperSynchronizerMock();
    PackageVersionReader packageVersionReader = PackageVersionReaderMock();

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
      reset(helperSynchronizer);
      when(helperSynchronizer.sync(any, languageCode: anyNamed("languageCode"))).thenAnswer((_) => Future.value());
      when(packageVersionReader.version).thenReturn('1.0.0');
      when(packageVersionReader.appVersion).thenReturn(AppVersion.fromString('1.0.0'));
    });

    testWidgets('should create properly and accessible from children', (WidgetTester tester) async {
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);
      expect(HelperOrchestrator.getInstance(), isNotNull);
    });

    testWidgets('call helperService to get what needs to be shown on each route', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      when(inAppUserClientService.getOrCreate()).thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));
      when(helperClientServiceMock.getPageNextHelper(any, any, any!)).thenAnswer((_) => Future.value());

      var orchestrator = HelperOrchestrator.create(
        helperClientService: helperClientServiceMock,
        inAppUserClientService: inAppUserClientService,
        routeObserver: routeObserver,
        navigatorKey: navigatorKey,
        helpersSynchronizer: helperSynchronizer,
        packageVersionReader: packageVersionReader
      );
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text("New"), findsOneWidget);

      // FIXME in test => routeObserver receives only null RouteSettings using this
      // navigatorKey.currentState.pushNamed("/test1");
      // expect(find.text("New1"), findsOneWidget);
      await orchestrator.onChangePage("/test1");
      verify(helperClientServiceMock.getPageNextHelper("/test1", "db6b01e1-b649-4a17-949a-9ab320601001", AppVersion.fromString('1.0.0'))).called(1);
      verify(helperSynchronizer.sync("db6b01e1-b649-4a17-949a-9ab320601001", languageCode: "en")).called(1);
      await tester.pumpAndSettle(Duration(seconds: 1));
    });

    testWidgets('changing page will dismiss current helper, sync helpers schema is not call again', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      when(inAppUserClientService.getOrCreate()).thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));

      HelperEntity(id: "1", name: "test1");
      var helperGroup = HelperGroupEntity(
        id: "g1",
        priority: 1,
        page: PageEntity(id: 'p1', route: '/test'),
        helpers: [HelperEntity(id: "1")]
      );

      when(helperClientServiceMock.getPageNextHelper("/test", "db6b01e1-b649-4a17-949a-9ab320601001", AppVersion.fromString('1.0.0')))
        .thenAnswer((_) => Future.value(helperGroup));
      when(helperClientServiceMock.getPageNextHelper("/route2", "db6b01e1-b649-4a17-949a-9ab320601001", AppVersion.fromString('1.0.0')))
        .thenAnswer((_) => Future.value(null));
      var orchestrator = HelperOrchestrator.create(
        helperClientService: helperClientServiceMock,
        inAppUserClientService: inAppUserClientService,
        routeObserver: routeObserver,
        navigatorKey: navigatorKey,
        helpersSynchronizer: helperSynchronizer,
        packageVersionReader: packageVersionReader
      );
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);

      await orchestrator.onChangePage("/test");
      expect(orchestrator.overlay, isNotNull);
      await orchestrator.onChangePage("/route2");
      expect(orchestrator.overlay, isNull);
      verify(helperSynchronizer.sync("db6b01e1-b649-4a17-949a-9ab320601001", languageCode: "en")).called(1);
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
        .getPageNextHelper("test", "db6b01e1-b649-4a17-949a-9ab320601001", AppVersion.fromString('1.0.0')))
        .thenAnswer((_) => Future.value(helperGroup));
      var orchestrator = HelperOrchestrator.create(
        helperClientService: helperClientServiceMock,
        inAppUserClientService: inAppUserClientService,
        routeObserver: routeObserver,
        navigatorKey: navigatorKey,
        helpersSynchronizer: helperSynchronizer,
        packageVersionReader: packageVersionReader
      );
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);
      expect(orchestrator.overlay, isNot(isList));
    });

    testWidgets('''
      navigate to page test1,
      group has 3 helpers, show first helper then answer positive feedback 
      => show second helper
      ''', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      MockHelperEntityBuilder mockHelperBuilder = MockFullscreenHelperEntityBuilder();
      var helperGroup = HelperGroupEntity(
        id: "g1",
        priority: 1,
        page: PageEntity(id: 'p1', route: 'test1'),
        helpers: [
          mockHelperBuilder.create("1", title: "TITLEKEY_1"),
          mockHelperBuilder.create("2", title: "TITLEKEY_2"),
          mockHelperBuilder.create("3", title: "TITLEKEY_3"),
        ]
      );
      when(inAppUserClientService.getOrCreate())
        .thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));
      when(helperClientServiceMock
        .getPageNextHelper("/test1", "db6b01e1-b649-4a17-949a-9ab320601001", AppVersion.fromString('1.0.0')))
        .thenAnswer((_) => Future.value(helperGroup));
      var orchestrator = HelperOrchestrator.create(
        helperClientService: helperClientServiceMock,
        inAppUserClientService: inAppUserClientService,
        routeObserver: routeObserver,
        navigatorKey: navigatorKey,
        helpersSynchronizer: helperSynchronizer,
        packageVersionReader: packageVersionReader
      );
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);
      // call in manually as route observer not working in tests
      await orchestrator.onChangePage("/test1");
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(orchestrator.overlay, isNotNull);
      expect(find.byType(UserFullScreenHelperPage), findsOneWidget);
      expect(find.text("TITLEKEY_1"), findsOneWidget);
      // push positiv button that will dismiss then show next helper
      await tester.tap(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Feedback_PositivButton')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // next helper should be visible
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(orchestrator.overlay, isNotNull);
      expect(find.byType(UserFullScreenHelperPage), findsOneWidget);
      expect(find.text("TITLEKEY_2"), findsOneWidget);
    });    


    testWidgets('''
      navigate to page test1,
      group has 3 helpers, show first helper then answer negative feedback 
      => do NOT show second helper
      ''', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      MockHelperEntityBuilder mockHelperBuilder = MockFullscreenHelperEntityBuilder();
      var helperGroup = HelperGroupEntity(
        id: "g1",
        priority: 1,
        page: PageEntity(id: 'p1', route: 'test1'),
        helpers: [
          mockHelperBuilder.create("1", title: "TITLEKEY_1"),
          mockHelperBuilder.create("2", title: "TITLEKEY_2"),
          mockHelperBuilder.create("3", title: "TITLEKEY_3"),
        ]
      );
      when(inAppUserClientService.getOrCreate())
        .thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));
      when(helperClientServiceMock
        .getPageNextHelper("/test1", "db6b01e1-b649-4a17-949a-9ab320601001", AppVersion.fromString('1.0.0')))
        .thenAnswer((_) => Future.value(helperGroup));
      var orchestrator = HelperOrchestrator.create(
        helperClientService: helperClientServiceMock,
        inAppUserClientService: inAppUserClientService,
        routeObserver: routeObserver,
        navigatorKey: navigatorKey,
        helpersSynchronizer: helperSynchronizer,
        packageVersionReader: packageVersionReader
      );
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);
      // call in manually as route observer not working in tests
      await orchestrator.onChangePage("/test1");
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(orchestrator.overlay, isNotNull);
      expect(find.byType(UserFullScreenHelperPage), findsOneWidget);
      expect(find.text("TITLEKEY_1"), findsOneWidget);
      // push positiv button that will dismiss then show next helper
      await tester.tap(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Feedback_NegativButton')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // next helper should be NOT be visible
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text("TITLEKEY_2"), findsNothing);
    });    


    testWidgets('''
      navigate to page test1,
      group has 3 helpers, show first helper then answer positive feedback,
      show second helper then answer positive feedback,
      show last helper then answer positive feedback,
      => helper is dismissed, nothing more to do
      ''', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      MockHelperEntityBuilder mockHelperBuilder = MockFullscreenHelperEntityBuilder();
      var helperGroup = HelperGroupEntity(
        id: "g1",
        priority: 1,
        page: PageEntity(id: 'p1', route: 'test1'),
        helpers: [
          mockHelperBuilder.create("1", title: "TITLEKEY_1"),
          mockHelperBuilder.create("2", title: "TITLEKEY_2"),
          mockHelperBuilder.create("3", title: "TITLEKEY_3"),
        ]
      );
      when(inAppUserClientService.getOrCreate())
        .thenAnswer((_) => Future.value(InAppUserEntity(id: "db6b01e1-b649-4a17-949a-9ab320601001", disabledHelpers: false, anonymous: true)));
      when(helperClientServiceMock
        .getPageNextHelper("/test1", "db6b01e1-b649-4a17-949a-9ab320601001", AppVersion.fromString('1.0.0')))
        .thenAnswer((_) => Future.value(helperGroup));
      var orchestrator = HelperOrchestrator.create(
        helperClientService: helperClientServiceMock,
        inAppUserClientService: inAppUserClientService,
        routeObserver: routeObserver,
        navigatorKey: navigatorKey,
        helpersSynchronizer: helperSynchronizer,
        packageVersionReader: packageVersionReader
      );
      await initAppWithPal(tester, null, navigatorKey, editorModeEnabled: false, routeFactory: route);
      // call in manually as route observer not working in tests
      await orchestrator.onChangePage("/test1");
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(orchestrator.overlay, isNotNull);
      expect(find.byType(UserFullScreenHelperPage), findsOneWidget);
      expect(find.text("TITLEKEY_1"), findsOneWidget);
      // push positiv button that will dismiss then show next helper
      await tester.tap(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Feedback_PositivButton')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // second helper should be visible then click next 
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text("TITLEKEY_2"), findsOneWidget);
      await tester.tap(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Feedback_PositivButton')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // last helper should be visible then click next 
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text("TITLEKEY_3"), findsOneWidget);
      await tester.tap(find.byKey(ValueKey('pal_UserFullScreenHelperPage_Feedback_PositivButton')));
      await tester.pumpAndSettle(Duration(seconds: 1));
      await tester.pumpAndSettle(Duration(seconds: 1));
      // no more overlay 
      expect(orchestrator.overlay, isNull); 
    });    




  });
}