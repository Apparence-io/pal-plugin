import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mocktail/mocktail.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';
import 'package:pal/src/services/http_client/base_client.dart';
import 'package:pal/src/ui/editor/pages/group_details/group_details.dart';
import 'package:pal/src/ui/editor/pages/group_details/widgets/group_details_helpers.dart';
import 'package:pal/src/ui/editor/pages/group_details/widgets/group_details_infos.dart';

import '../../../../pal_test_utilities.dart';

class HttpClientMock extends Mock implements HttpClient {}

// MOCK DATA
const mockGroup =
    '''{"id":"JKLSDJDLS28", "priority":6, "name":"group 06", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-12-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"}''';
const mockHelpersList = '''[{
        "id": "id1",
        "name": "helper1",
        "type": "HELPER_FULL_SCREEN",
        "creationDate": "2020-12-23T18:25:43.511Z",
        "lastUpdateDate": "2020-12-23T18:25:43.511Z",
        "priority": 1
        },{
        "id": "id2",
        "name": "helper2",
        "type": "HELPER_FULL_SCREEN",
        "creationDate": "2020-12-23T18:25:43.511Z",
        "lastUpdateDate": "2020-12-23T18:25:43.511Z",
        "priority": 2
        },{
        "id": "id2",
        "name": "helper2",
        "type": "HELPER_FULL_SCREEN",
        "creationDate": "2020-12-23T18:25:43.511Z",
        "lastUpdateDate": "2020-12-23T18:25:43.511Z",
        "priority": 3
        }]''';
String maxVersionEntity =
    '''{"content":[{"id":42,"name":"1.0.3"}],"pageable":{"offset":null,"pageNumber":null,"pageSize":null}}''';
String minVersionEntity =
    '''{"content":[{"id":666,"name":"1.0.2"}],"pageable":{"offset":null,"pageNumber":null,"pageSize":null}}''';

const userApp = Scaffold(
  body: Center(
    child: Text('Testing'),
  ),
);

var navKey = GlobalKey<NavigatorState>();

main() {
  HttpClientMock httpMock = HttpClientMock();
  late GroupDetailsPage component;
  group('Group Details Tests', () {
    Future _before(WidgetTester tester) async {
      EditorAppContext editorAppContext =
          HttpEditorAppContext.private(httpClient: httpMock);
      await initAppWithPal(tester, userApp, navKey,
          editorAppContext: editorAppContext);

      await tester.pumpAndSettle();

      Navigator.push(
          navKey.currentContext!,
          MaterialPageRoute(
            builder: (context) => GroupDetailsPage(
              groupId: 'testId',
              routeName: '/',
            ),
          ));

      await tester.pumpAndSettle();

      component = tester.widget(find.byType(GroupDetailsPage));
    }

    DetailsTextField groupName(WidgetTester tester) =>
        tester.widget(find.byKey(ValueKey('GroupNameField')));
    DetailsSelectField triggerType(WidgetTester tester) =>
        tester.widget(find.byKey(ValueKey('TriggerTypeField')));
    DetailsTextField minVer(WidgetTester tester) =>
        tester.widget(find.byKey(ValueKey('MinVersionField')));
    DetailsTextField maxVer(WidgetTester tester) =>
        tester.widget(find.byKey(ValueKey('MaxVersionField')));

    setUp(() {
      reset(httpMock);
      // GROUP DETAILS MOCK
      when(() => httpMock.get(Uri.parse('pal-business/editor/groups/testId')))
          .thenAnswer((_) => Future.value(Response(mockGroup, 200)));

      when(() => httpMock.get(Uri.parse('pal-business/editor/groups/testId/helpers')))
          .thenAnswer((_) => Future.value(Response(mockHelpersList, 200)));
      // GROUP DETAILS MOCK

      when(() => httpMock.put(Uri.parse('pal-business/editor/groups/testId'), body: any(named: 'body')))
          .thenAnswer((_) => Future.delayed(
            Duration(seconds: 2), () => Response(mockGroup, 200))
          );

      // VERSIONS MOCKS
      when(() => httpMock.get(Uri.parse('pal-business/editor/versions?versionName=1.0.2&pageSize=1')))
          .thenAnswer((_) => Future.value(Response(minVersionEntity, 200)));

      when(() => httpMock.get(Uri.parse('pal-business/editor/versions?versionName=1.0.3&pageSize=1')))
          .thenAnswer((_) => Future.value(Response(maxVersionEntity, 200)));
      // VERSIONS MOCKS
    });

    testWidgets('should create => init is called with right values',
        (tester) async {
      await _before(tester);
      expect(find.byType(GroupDetailsPage), findsOneWidget);

      expect(groupName(tester).controller!.text, equals('group 06'));
      expect(helperTriggerTypeToString(triggerType(tester).initialValue), equals('ON_SCREEN_VISIT'));
      expect(minVer(tester).controller!.text, equals('1.0.1'));
      expect(maxVer(tester).controller!.text, equals('1.0.2'));
    });

    testWidgets(
        'On save button click (sucess) => should make server \'save\' request',
        (tester) async {
      await _before(tester);
      expect(find.byType(GroupDetailsPage), findsOneWidget);

      groupName(tester).controller!.text = 'newTest';
      component.getPageBuilder.presenter
          .onNewTrigger(HelperTriggerType.ON_NEW_UPDATE);
      minVer(tester).controller!.text = '1.0.2';
      maxVer(tester).controller!.text = '1.0.3';
      await tester.pump();

      await tester.tap(find.byKey(ValueKey("saveButton")));
      await tester.pump(Duration(milliseconds: 100));

      expect(component.getPageBuilder.presenter.viewModel.loading, equals(true));

      await tester.pump(Duration(seconds: 2));

      expect(
        verify(() => httpMock.put(
          Uri.parse('pal-business/editor/groups/testId'),
          body: captureAny(named: 'body'),
        )).captured.first,
        equals('{"versionMinId":666,"versionMaxId":42,"triggerType":"ON_NEW_UPDATE","name":"newTest"}'),
      );

      await tester.pumpAndSettle();
      expect(component.getPageBuilder.presenter.viewModel.loading, equals(false));
    });

    testWidgets(
        'On save button click (error) => should make server \'save\' request',
        (tester) async {
      when(() => httpMock.put(Uri.parse('pal-business/editor/groups/testId'), body: any(named: 'body')))
          .thenThrow(InternalHttpError);
      await _before(tester);

      groupName(tester).controller!.text = 'newTest';
      component.getPageBuilder.presenter
          .onNewTrigger(HelperTriggerType.ON_NEW_UPDATE);
      minVer(tester).controller!.text = '1.0.2';
      maxVer(tester).controller!.text = '1.0.3';
      await tester.pump();

      await tester.tap(find.byKey(ValueKey("saveButton")));
      await tester.pump();

      expect(
          component.getPageBuilder.presenter.viewModel.locked, equals(false));
      await tester.pumpAndSettle(Duration(milliseconds: 200));
      SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect(snackBar, isNotNull);
      expect(snackBar.backgroundColor, equals(Colors.redAccent));
      await tester.pumpAndSettle();
    });

    // TEST UTILS
    Future _goToHelpersList(WidgetTester tester) async {
      await tester.tap(find.byKey(ValueKey('HelpersList')));
      await tester.pumpAndSettle();
    }
    // TEST UTILS

    testWidgets('On helpers list click => Should fetch helper list and show',
        (tester) async {
      when(() => httpMock.put(Uri.parse('pal-business/groups/testId/helpers')))
        .thenAnswer((_) => Future.delayed(Duration(seconds: 2), () => Response(mockHelpersList, 200)));
      await _before(tester);

      await _goToHelpersList(tester);

      Finder helpers = find.byType(GroupDetailsHelperTile);
      expect(helpers.evaluate().length, equals(3));
    });

    testWidgets(
        'On Helper delete click (sucess) => Should make server request and delete helper from list',
        (tester) async {
      when(() => httpMock.put(Uri.parse('pal-business/groups/testId/helpers')))
        .thenAnswer((_) => Future.delayed(Duration(seconds: 2), () => Response(mockHelpersList, 200)));
      when(() => httpMock.delete(Uri.parse('pal-business/editor/helpers/id1')))
        .thenAnswer((_) async => Response('''''', 200));

      when(() => httpMock.delete(Uri.parse('pal-business/groups/testId/helpers/id1')))
        .thenAnswer((_) => Future.value(Response(mockHelpersList, 200)));
      await _before(tester);

      await _goToHelpersList(tester);

      Finder helper = find.byType(GroupDetailsHelperTile).first;
      await tester.drag(helper, Offset(-100, 0));
      await tester.pump();

      Finder deleteButton = find.byKey(ValueKey('DeleteHelperButtonid1'));
      expect(deleteButton, findsOneWidget);
      var deleteButtonAction = deleteButton.evaluate().first.widget as ActionWidget;
      deleteButtonAction.onTap!();
      await tester.pump();

      verify(() => httpMock.delete(Uri.parse('pal-business/editor/helpers/id1'))).called(1);

      await tester.pumpAndSettle();
      Finder helpers = find.byType(GroupDetailsHelperTile);
      expect(helpers.evaluate().length, equals(2));
    });

    testWidgets('On Helper delete click (error) => Should make server request and show error message', 
      (tester) 
    async {
      when(() => httpMock.put(Uri.parse('pal-business/groups/testId/helpers')))
        .thenAnswer((_) => Future.delayed(Duration(seconds: 2), () => Response(mockHelpersList, 200)));

      when(() => httpMock.delete(Uri.parse('pal-business/editor/helpers/id1'))).thenThrow(InternalHttpError);
      await _before(tester);

      await _goToHelpersList(tester);

      Finder helper = find.byType(GroupDetailsHelperTile).first;
      await tester.drag(helper, Offset(-100, 0));
      await tester.pump();

      Finder deleteButton = find.byKey(ValueKey('DeleteHelperButtonid1'));
      await tester.tap(deleteButton);
      await tester.pump();

      verify(() => httpMock.delete(Uri.parse('pal-business/editor/helpers/id1'))).called(1);

      await tester.pumpAndSettle(Duration(milliseconds: 200));
      SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect(snackBar, isNotNull);
      expect(snackBar.backgroundColor, equals(Colors.redAccent));
      await tester.pumpAndSettle();
    });

    testWidgets(
        'On Group menu click (sucess) => Should show delete button and delete the group',
        (tester) async {
      when(() => httpMock.delete(Uri.parse('pal-business/editor/groups/testId')))
          .thenAnswer((_) => Future.value(Response('true', 200)));
      await _before(tester);
      expect(find.byType(GroupDetailsPage), findsOneWidget);

      Finder menuButton = find.byKey(ValueKey('MenuButton'));
      await tester.tap(menuButton);
      await tester.pumpAndSettle(Duration(milliseconds: 250));

      Finder deleteGroup = find.byKey(ValueKey('DeleteGroupButton'));
      await tester.tap(deleteGroup);
      await tester.pump(Duration(milliseconds: 250));

      verify(() => httpMock.delete(Uri.parse('pal-business/editor/groups/testId'))).called(1);
    });

    testWidgets(
        'On Group menu click (error) => Should show delete button and show error message',
        (tester) async {
      when(() => httpMock.delete(Uri.parse('pal-business/editor/groups/testId')))
          .thenThrow(InternalHttpError);
      await _before(tester);
      expect(find.byType(GroupDetailsPage), findsOneWidget);

      Finder menuButton = find.byKey(ValueKey('MenuButton'));
      await tester.tap(menuButton);
      await tester.pumpAndSettle(Duration(milliseconds: 250));

      Finder deleteGroup = find.byKey(ValueKey('DeleteGroupButton'));
      await tester.tap(deleteGroup);
      await tester.pump(Duration(milliseconds: 250));

      SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect(snackBar, isNotNull);
      expect(snackBar.backgroundColor, equals(Colors.redAccent));
      await tester.pumpAndSettle();
    });
  });
}
