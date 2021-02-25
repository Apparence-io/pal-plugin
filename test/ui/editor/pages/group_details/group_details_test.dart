import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/services/http_client/base_client.dart';
import 'package:pal/src/ui/editor/pages/group_details/group_details.dart';

class HttpClientMock extends Mock implements HttpClient {}

// MOCK DATA
const mockGroup =
    '''{"id":"JKLSDJDLS28", "priority":6, "name":"group 06", "triggerType":"ON_SCREEN_VISIT", "creationDate":"2020-12-23T18:25:43.511Z", "minVersion":"1.0.1", "maxVersion": "1.0.2"}''';
const mockHelpersList = '''[{
        'id': id1,
        'name': helper1,
        'type': HELPER_FULL_SCREEN,
        'creationDate': "2020-12-23T18:25:43.511Z",
        'lastUpdateDate': "2020-12-23T18:25:43.511Z",
        'priority': 1,
        },{
        'id': id2,
        'name': helper2,
        'type': HELPER_FULL_SCREEN,
        'creationDate': "2020-12-23T18:25:43.511Z",
        'lastUpdateDate': "2020-12-23T18:25:43.511Z",
        'priority': 2,
        },{
        'id': id2,
        'name': helper2,
        'type': HELPER_FULL_SCREEN,
        'creationDate': "2020-12-23T18:25:43.511Z",
        'lastUpdateDate': "2020-12-23T18:25:43.511Z",
        'priority': 3,
        },]''';

main() {
  HttpClientMock httpMock = HttpClientMock();
  GroupDetailsPage component;
  group('Group Details Tests', () {
    Future _before(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: GroupDetailsPage(
            groupId: 'testid',
          ),
        ),
      );
      tester.pumpAndSettle();
      component = tester.widget(find.byType(GroupDetailsPage));
    }

    TextFormField groupName(WidgetTester tester) =>
        tester.widget(find.byKey(ValueKey('GroupNameField')));
    DropdownButton triggerType(WidgetTester tester) =>
        tester.widget(find.byKey(ValueKey('TriggerTypeField')));
    TextFormField minVer(WidgetTester tester) =>
        tester.widget(find.byKey(ValueKey('MinVersionField')));
    TextFormField maxVer(WidgetTester tester) =>
        tester.widget(find.byKey(ValueKey('MaxVersionField')));

    setUp(() {
      reset(httpMock);
      when(httpMock.get('pal-business/groups/testId'))
          .thenAnswer((_) => Future.value(Response(mockGroup, 200)));

      when(httpMock.put('pal-business/groups/testId')).thenAnswer((_) =>
          Future.delayed(Duration(seconds: 2), () => Response(mockGroup, 200)));
    });

    testWidgets('should create => init is called with right values',
        (tester) async {
      await _before(tester);
      expect(find.byType(GroupDetailsPage), findsOneWidget);

      expect(groupName(tester).controller.text, equals('group 06'));
      expect(triggerType(tester).value, equals('ON_SCREEN_VISIT'));
      expect(minVer(tester).controller.text, equals('1.0.1'));
      expect(maxVer(tester).controller.text, equals('1.0.2'));
    });

    testWidgets(
        'On save button click (sucess) => should make server \'save\' request',
        (tester) async {
      await _before(tester);
      expect(find.byType(GroupDetailsPage), findsOneWidget);

      groupName(tester).controller.text = 'newTest';
      component.getPageBuilder.presenter.onNewTrigger(HelperTriggerType.ON_NEW_UPDATE);
      minVer(tester).controller.text = '1.0.2';
      maxVer(tester).controller.text = '1.0.3';
      await tester.pump();

      await tester.tap(tester.widget(find.byKey(ValueKey("saveButton"))));
      await tester.pump(Duration(seconds: 1));

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      verify(httpMock.put('pal-buisness/groups/testId', body: {
        "name": "newTest",
        "triggerType": "ON_NEW_UPDATE",
        "minVersion": "1.0.2",
        "maxVersion": "1.0.3"
      })).called(1);

      await tester.pump(Duration(seconds: 1));
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });

    testWidgets(
        'On save button click (error) => should make server \'save\' request',
        (tester) async {
      when(httpMock.put('pal-business/groups/testId'))
          .thenThrow(InternalHttpError);
      await _before(tester);

      groupName(tester).controller.text = 'newTest';
      component.getPageBuilder.presenter.onNewTrigger(HelperTriggerType.ON_NEW_UPDATE);
      minVer(tester).controller.text = '1.0.2';
      maxVer(tester).controller.text = '1.0.3';
      await tester.pump();

      await tester.tap(tester.widget(find.byKey(ValueKey("saveButton"))));
      await tester.pump(Duration(milliseconds: 500));

      expect(find.byType(CircularProgressIndicator), findsNothing);
      SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect(snackBar, findsOneWidget);
      expect(snackBar.backgroundColor, equals(Colors.red));
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
      when(httpMock.put('pal-business/groups/testId/helpers')).thenAnswer((_) =>
          Future.delayed(
              Duration(seconds: 2), () => Response(mockHelpersList, 200)));
      await _before(tester);

      await _goToHelpersList(tester);

      Finder helpers = find.byType(GroupDetailsHelperTile);
      expect(helpers.evaluate().length, equals(3));
    });

    testWidgets(
        'On Helper delete click (sucess) => Should make server request and delete helper from list',
        (tester) async {
      when(httpMock.put('pal-business/groups/testId/helpers')).thenAnswer((_) =>
          Future.delayed(
              Duration(seconds: 2), () => Response(mockHelpersList, 200)));

      when(httpMock.delete('pal-business/groups/testId/helpers/id1'))
          .thenAnswer((_) => Future.value(Response(mockHelpersList, 200)));
      await _before(tester);

      await _goToHelpersList(tester);

      Finder helper = find.byType(GroupDetailsHelperTile).first;
      await tester.drag(helper, Offset(-100, 0));
      await tester.pump();

      Finder deleteButton = find.byKey(ValueKey('DeleteHelperButton'));
      await tester.tap(deleteButton);
      await tester.pump();

      verify(httpMock.delete('pal-business/groups/testId/helpers/id1'))
          .called(1);

      Finder helpers = find.byType(GroupDetailsHelperTile);
      expect(helpers.evaluate().length, equals(2));
    });

    testWidgets(
        'On Helper delete click (error) => Should make server request and show error message',
        (tester) async {
      when(httpMock.put('pal-business/groups/testId/helpers')).thenAnswer((_) =>
          Future.delayed(
              Duration(seconds: 2), () => Response(mockHelpersList, 200)));

      when(httpMock.delete('pal-business/groups/testId/helpers/id1'))
          .thenThrow(InternalHttpError);
      await _before(tester);

      await _goToHelpersList(tester);

      Finder helper = find.byType(GroupDetailsHelperTile).first;
      await tester.drag(helper, Offset(-100, 0));
      await tester.pump();

      Finder deleteButton = find.byKey(ValueKey('DeleteHelperButton'));
      await tester.tap(deleteButton);
      await tester.pump();

      verify(httpMock.delete('pal-business/groups/testId/helpers/id1'))
          .called(1);

      SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect(snackBar, findsOneWidget);
      expect(snackBar.backgroundColor, equals(Colors.red));
      await tester.pumpAndSettle();
    });

    testWidgets('On Helper preview click => Should show preview page',
        (tester) async {
      when(httpMock.put('pal-business/groups/testId/helpers')).thenAnswer((_) =>
          Future.delayed(
              Duration(seconds: 2), () => Response(mockHelpersList, 200)));

      await _before(tester);

      await _goToHelpersList(tester);

      Finder helper = find.byType(GroupDetailsHelperTile).first;
      await tester.drag(helper, Offset(-100, 0));
      await tester.pump();

      Finder previewButton = find.byKey(ValueKey('PreviewHelperButton'));
      await tester.tap(previewButton);
      await tester.pumpAndSettle();

      // TODO : Expect transition
    });

    testWidgets('On Helper edit click => Should show edit page',
        (tester) async {
      when(httpMock.put('pal-business/groups/testId/helpers')).thenAnswer((_) =>
          Future.delayed(
              Duration(seconds: 2), () => Response(mockHelpersList, 200)));

      await _before(tester);

      await _goToHelpersList(tester);

      Finder helper = find.byType(GroupDetailsHelperTile).first;
      await tester.drag(helper, Offset(-100, 0));
      await tester.pump();

      Finder editButton = find.byKey(ValueKey('EditHelperButton'));
      await tester.tap(editButton);
      await tester.pumpAndSettle();

      // TODO : Expect transition
    });

    testWidgets(
        'On Group menu click (sucess) => Should show delete button and delete the group',
        (tester) async {
      when(httpMock.delete('pal-business/groups/testId'))
          .thenAnswer((_) => Future.value(Response('true', 200)));
      await _before(tester);
      expect(find.byType(GroupDetailsPage), findsOneWidget);

      Finder menuButton = find.byKey(ValueKey('MenuButton'));
      await tester.tap(menuButton);
      await tester.pump();

      Finder deleteGroup = find.byKey(ValueKey('DeleteGroupButton'));
      await tester.tap(deleteGroup);
      await tester.pump();

      verify(httpMock.delete('pal-business/groups/testId')).called(1);
    });

    testWidgets(
        'On Group menu click (error) => Should show delete button and show error message',
        (tester) async {
      when(httpMock.delete('pal-business/groups/testId'))
          .thenThrow(InternalHttpError);
      await _before(tester);
      expect(find.byType(GroupDetailsPage), findsOneWidget);

      Finder menuButton = find.byKey(ValueKey('MenuButton'));
      await tester.tap(menuButton);
      await tester.pump();

      Finder deleteGroup = find.byKey(ValueKey('DeleteGroupButton'));
      await tester.tap(deleteGroup);
      await tester.pump();

      SnackBar snackBar = tester.widget(find.byType(SnackBar));
      expect(snackBar, findsOneWidget);
      expect(snackBar.backgroundColor, equals(Colors.red));
      await tester.pumpAndSettle();
    });
  });
}
