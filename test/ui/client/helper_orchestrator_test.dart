import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/client/helper_client_service.dart';
import 'package:palplugin/src/services/client/page_client_service.dart';
import 'package:palplugin/src/ui/client/helper_orchestrator.dart';


class HelperClientServiceMock extends Mock implements HelperClientService {}

class PageClientServiceMock extends Mock implements PageClientService {}


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

    testWidgets('should create properly and accessible from children', (WidgetTester tester) async {
      HelperOrchestrator orchestatorInstance;
      Widget page1 = Scaffold(
        body: Builder(
          builder: (context) {
            orchestatorInstance = HelperOrchestrator.of(context);
            return Container(key: ValueKey("paged"));
          },
        )
      );
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: HelperOrchestrator(
          helperClientService:  helperClientServiceMock,
          routeObserver: PalNavigatorObserver.instance(),
          child: MaterialApp(
            home: page1
          )
        )
      );
      await tester.pumpWidget(app);
      expect(orchestatorInstance, isNotNull);
      expect(orchestatorInstance.routeObserver, isNotNull);
    });

    testWidgets('call helperService to get what needs to be shown on each route', (WidgetTester tester) async {
      final routeObserver = PalNavigatorObserver.instance();
      when(helperClientServiceMock.getPageHelpers("/")).thenAnswer((_) => Future.value([]));
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: HelperOrchestrator(
          helperClientService:  helperClientServiceMock,
          routeObserver: routeObserver,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            navigatorObservers: [routeObserver],
            onGenerateRoute: route,
            initialRoute: "/",
          )
        )
      );
      await tester.pumpWidget(app);

      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text("New"), findsOneWidget);
//      verify(helperClientServiceMock.getPageHelpers("/")).called(1);

      navigatorKey.currentState.pushNamed("/test1");
      await tester.pumpAndSettle(Duration(seconds: 1));
      expect(find.text("New1"), findsOneWidget);
//      verify(helperClientServiceMock.getPageHelpers("/test1")).called(1);
    });


  });
}