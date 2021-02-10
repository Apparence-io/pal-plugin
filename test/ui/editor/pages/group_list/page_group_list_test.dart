import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';
import 'package:pal/src/services/http_client/base_client.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:pal/src/ui/editor/pages/page_groups/page_group_list.dart';
import 'package:pal/src/ui/editor/widgets/bubble_overlay.dart';

import '../../../../pal_test_utilities.dart';

class HttpClientMock extends Mock implements HttpClient {}

void main() {

  final _navigatorKey = GlobalKey<NavigatorState>();

  final httpClientMock = HttpClientMock();

  Scaffold _myHomeTest = Scaffold(
    body: Column(
      children: [
        Text("text1", key: ValueKey("text1")),
        Text("text2", key: ValueKey("text2")),
        Padding(
          padding: EdgeInsets.only(top: 32),
          child: FlatButton(
            key: ValueKey("MFlatButton"),
            child: Text("tapme"),
            onPressed: () => print("impressed!"),
          ),
        )
      ],
    ),
  );

  setUp(() => reset(httpClientMock));

  Future _before(WidgetTester tester) async {
    EditorAppContext editorAppContext = HttpEditorAppContext.private(httpClient: httpClientMock);
    await initAppWithPal(tester, _myHomeTest, _navigatorKey, editorAppContext: editorAppContext);
    var bubble = find.byType(BubbleOverlayButton);
    var bubbleWidget = bubble.evaluate().first.widget as BubbleOverlayButton;
    bubbleWidget.onTapCallback();
  }
  
  testWidgets('should create page correctly', (WidgetTester tester) async {
    var helpersListJson = '''[

    ]''';
    when(httpClientMock.get('pal-business/editor/groups?routeName=myPage'))
      .thenAnswer((_) => Future.value(Response(helpersListJson, 200)));
    await _before(tester);
    await tester.pump(Duration(seconds: 2));
    await tester.pump(Duration(seconds: 2));
    expect(find.byType(PageGroupsListPage), findsOneWidget);
  });

  testWidgets('loading 6 groups => shows 6 groups', (WidgetTester tester) async {
    var helpersListJson = '''[
      {"id":"JKLSDJDLS23", "priority":1, "name":"group 01", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-04-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": null},
      {"id":"JKLSDJDLS24", "priority":2, "name":"group 02", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-14-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": null},
      {"id":"JKLSDJDLS25", "priority":3, "name":"group 03", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-05-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"},
      {"id":"JKLSDJDLS26", "priority":4, "name":"group 04", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-06-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"},
      {"id":"JKLSDJDLS27", "priority":5, "name":"group 05", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-01-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"},
      {"id":"JKLSDJDLS28", "priority":6, "name":"group 06", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-12-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"}
    ]''';
    when(httpClientMock.get('pal-business/editor/groups?routeName=myPage'))
      .thenAnswer((_) => Future.value(Response(helpersListJson, 200)));
    await _before(tester);
    await tester.pump(Duration(seconds: 2));
    expect(find.byType(PageGroupsListPage), findsOneWidget);
    verify(httpClientMock.get('pal-business/editor/groups?routeName=myPage')).called(1);
    // expect(find.byType(PageGroupsListItem), findsNWidgets(6));
  });

  testWidgets('click close button => page is dismissed', (WidgetTester tester) async {
    var helpersListJson = '''[
      {"id":"JKLSDJDLS23", "priority":1, "name":"group 01", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-04-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": null}
    ]''';
    when(httpClientMock.get('pal-business/editor/groups?routeName=myPage'))
      .thenAnswer((_) => Future.value(Response(helpersListJson, 200)));
    await _before(tester);
    await tester.pump(Duration(seconds: 2));
    expect(find.text("Close"), findsOneWidget);
    await tester.tap(find.text("Close"));
    await tester.pump(Duration(seconds: 2));
  });

  testWidgets('click add helper button => show create helper page', (WidgetTester tester) async {
    var helpersListJson = '''[
      {"id":"JKLSDJDLS23", "priority":1, "name":"group 01", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-04-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": null}
    ]''';
    when(httpClientMock.get('pal-business/editor/groups?routeName=myPage'))
      .thenAnswer((_) => Future.value(Response(helpersListJson, 200)));
    await _before(tester);
    await tester.pump(Duration(seconds: 2));
    expect(find.text("Create new helper"), findsOneWidget);
    await tester.tap(find.text("Create new helper"));
    await tester.pump(Duration(seconds: 2));
    expect(find.byType(CreateHelperPage), findsOneWidget);
  });
}