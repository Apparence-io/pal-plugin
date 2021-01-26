import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart';
import 'package:mockito/mockito.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/repository/editor/helper_group_repository.dart';
import 'package:pal/src/database/repository/project_repository.dart';
import 'package:pal/src/pal_navigator_observer.dart';
import 'package:pal/src/services/editor/project/project_editor_service.dart';
import 'package:pal/src/services/http_client/base_client.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_presenter.dart';
import 'package:pal/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_infos/select_helper_group.dart';
import 'package:pal/src/ui/editor/widgets/nested_navigator.dart';
import 'package:pal/src/ui/editor/widgets/progress_widget/progress_bar_widget.dart';

class _PackageVersionReaderMock extends Mock implements PackageVersionReader {}

class _HttpClientMock extends Mock implements HttpClient {}

class PalObserverMock implements PalRouteObserver {

  @override
  Stream<RouteSettings> get routeSettings =>  Stream.value(new RouteSettings(name: "test"));

}


void main() {

  final packageVersionReader = _PackageVersionReaderMock();

  final routeObserverMock = PalObserverMock();

  ProjectEditorService projectEditorService;

  HttpClient httpClientMock;

  CreateHelperPresenter presenter;

  Future _before(WidgetTester tester) async {
    httpClientMock = new _HttpClientMock();
    projectEditorService = ProjectEditorHttpService(
      ProjectRepository(httpClient: httpClientMock),
      EditorHelperGroupRepository(httpClient: httpClientMock)
    );
    var app = MediaQuery(
      data: MediaQueryData(),
      child: PalTheme(
        theme: PalThemeData.light(),
        child: Builder(
          builder: (context) => MaterialApp(
            theme: PalTheme.of(context).buildTheme(),
            home: CreateHelperPage(
              projectEditorService: projectEditorService,
              routeObserver: routeObserverMock,
              packageVersionReader: packageVersionReader,
            ),
          ),
        ),
      ),
    );
    await tester.pumpWidget(app);
    var presenterFinder = find.byKey(ValueKey("createHelperPresenter"));
    expect(presenterFinder, findsOneWidget);
    presenter = (presenterFinder.evaluate().first.widget as PresenterInherited<CreateHelperPresenter, CreateHelperModel>).presenter;
    expect(presenter, isNotNull);
    when(packageVersionReader.init()).thenAnswer((realInvocation) => Future.value());
    when(packageVersionReader.appName).thenReturn('test');
    when(packageVersionReader.version).thenReturn('1.0.0');
  }
  
  group('Create helper page', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _before(tester);
      expect(find.text('Create new helper'), findsOneWidget);
      expect(find.byKey(ValueKey('palCreateHelperScrollList')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_CreateHelper_TextField_Name')), findsOneWidget);
      expect(find.byKey(ValueKey('palCreateHelperNextButton')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_CreateHelper_Dropdown_Type')), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
      expect(find.byType(NestedNavigator), findsOneWidget);
      expect(find.byType(ProgressBarWidget), findsOneWidget);
    });

    testWidgets('should next button be active', (WidgetTester tester) async {
      await _before(tester);
      expect(tester.widget<RaisedButton>(find.byKey(ValueKey('palCreateHelperNextButton'))).enabled, isFalse);
      var helperName = find.byKey(ValueKey('pal_CreateHelper_TextField_Name'));
      await tester.enterText(helperName, 'My awesome helper');
      await tester.pump();
      expect(tester.widget<RaisedButton>(find.byKey(ValueKey('palCreateHelperNextButton'))).enabled, isTrue);
    });

    testWidgets('should next button be disabled', (WidgetTester tester) async {
      await _before(tester);
      var helperName = find.byKey(ValueKey('pal_CreateHelper_TextField_Name'));
      await tester.enterText(helperName, '');
      await tester.pump();
      expect(tester.widget<RaisedButton>(find.byKey(ValueKey('palCreateHelperNextButton'))).enabled, isFalse);
    });

    testWidgets('select trigger type AFTER_GROUP_HELPER => pops a new page to select a group helper then an helper', (WidgetTester tester) async {
      await _before(tester);
      var helperGroupListJson = '''[
          {"id":"jdlqsjdlq12", "priority": 0, "type": "ANCHORED_OVERLAYED_HELPER", "helpers": [{"name":"introduction"}]},
          {"id":"jdlqsjdlq132", "priority": 1, "type": "ANCHORED_OVERLAYED_HELPER", "helpers":[{"name":"test_intro2"}]}
        ]
      ''';
      when(httpClientMock.get('editor/groups?routeName=test')).thenAnswer((_) => Future.value(Response(helperGroupListJson, 200)));

      final drop = find.byKey(ValueKey('pal_CreateHelper_Dropdown_Type'));
      final dropText = find.text("On screen visit");
      var dropDownWidget = drop.evaluate().first.widget as DropdownButtonFormField;
      expect(dropText, findsOneWidget);
      await tester.tap(dropText);
      expect(find.text("On screen visit"), findsOneWidget);
      expect(find.text("After helper"), findsOneWidget);
      // not working
      await tester.tap(find.text('After helper').first);
      // as action is not called by test we call it manually
      presenter.onTriggerTypeChanged(HelperTriggerType.AFTER_GROUP_HELPER.toString().split(".")[1]);
      await tester.pump();
      await tester.pump(Duration(seconds: 1));
      await tester.pump(Duration(seconds: 1));
      expect(presenter.viewModel.selectedTriggerType, equals("AFTER_GROUP_HELPER"));
      expect(find.text("introduction"), findsOneWidget);
      expect(find.text("test_intro2"), findsOneWidget);
    });
  });
}
