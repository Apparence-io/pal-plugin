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
import 'package:pal/src/ui/editor/pages/create_helper/steps/create_helper_group/create_helper_group.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/select_group_position/helper_position_setup.dart';
import 'package:pal/src/ui/editor/pages/create_helper/steps/setup_group/select_helper_group.dart';
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

  final HttpClient httpClientMock = _HttpClientMock();

  ProjectEditorService projectEditorService;

  CreateHelperPresenter presenter;

  Future _before(WidgetTester tester) async {
    reset(httpClientMock);
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

    // ------------------------------------------------------
    // STEP 1 Tests
    // ------------------------------------------------------

    testWidgets('[step 1] 2 groups are available on page => click on one then call next goes to step 2', (WidgetTester tester) async {
      var helperGroupListJson = '''[
          {"id":"jdlqsjdlq12", "priority": 0, "type": "ANCHORED_OVERLAYED_HELPER", "helpers": [{"name":"introduction"}, {"name":"shop button"}]},
          {"id":"jdlqsjdlq132", "priority": 1, "type": "ANCHORED_OVERLAYED_HELPER", "helpers":[{"name":"test_intro2"}]}
        ]
      ''';
      when(httpClientMock.get('editor/groups?routeName=test')).thenAnswer((_) => Future.value(Response(helperGroupListJson, 200)));
      await _before(tester);
      await tester.pump();
      await tester.pump(Duration(seconds: 1));
      // helper group selection is active
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text("introduction"), findsOneWidget);
      expect(find.text("test_intro2"), findsOneWidget);
      // tap on helper group then go next
      await tester.tap(find.text("test_intro2"));
      await tester.pump();
      expect(tester.widget<RaisedButton>(find.byKey(ValueKey('palCreateHelperNextButton'))).enabled, isTrue);
      await tester.tap(find.text("Next"));
      await tester.pump();
      // current step is 1
      expect(presenter.viewModel.step.value, 1);
    });

    testWidgets('[step 1] 2 groups are available on page, click on first, click on second => second only is selected', (WidgetTester tester) async {
      var helperGroupListJson = '''[
          {"id":"jdlqsjdlq12", "priority": 0, "type": "ANCHORED_OVERLAYED_HELPER", "helpers": [{"name":"introduction"}, {"name":"shop button"}]},
          {"id":"jdlqsjdlq132", "priority": 1, "type": "ANCHORED_OVERLAYED_HELPER", "helpers":[{"name":"test_intro2"}]}
        ]
      ''';
      when(httpClientMock.get('editor/groups?routeName=test')).thenAnswer((_) => Future.value(Response(helperGroupListJson, 200)));
      await _before(tester);
      await tester.pump();
      await tester.pump(Duration(seconds: 1));
      // helper group selection is active
      expect(find.byType(ListTile), findsNWidgets(2));
      expect(find.text("introduction"), findsOneWidget);
      expect(find.text("test_intro2"), findsOneWidget);
      // tap on helper group then go next
      await tester.tap(find.text("test_intro2"));
      await tester.pump();
      await tester.tap(find.text("introduction"));
      await tester.pump();
      await tester.pump(Duration(seconds: 1));
      expect(find.byType(HelperGroupItemLine), findsNWidgets(2));
      var lineWidget1 = find.byType(HelperGroupItemLine).evaluate().first.widget as HelperGroupItemLine;
      var lineWidget2 = find.byType(HelperGroupItemLine).evaluate().elementAt(1).widget as HelperGroupItemLine;
      expect(presenter.viewModel.helperGroups[0].selected, isTrue);
      expect(presenter.viewModel.helperGroups[1].selected, isFalse);
      expect(lineWidget1.model.selected, isTrue);
      expect(lineWidget2.model.selected, isFalse);
    });

    testWidgets('[step 1] 2 groups available on page => can create a group', (WidgetTester tester) async {
      var helperGroupListJson = '''[
          {"id":"jdlqsjdlq12", "priority": 0, "type": "ANCHORED_OVERLAYED_HELPER", "helpers": [{"name":"introduction"}, {"name":"shop button"}]},
          {"id":"jdlqsjdlq132", "priority": 1, "type": "ANCHORED_OVERLAYED_HELPER", "helpers":[{"name":"test_intro2"}]}
        ]
      ''';
      when(httpClientMock.get('editor/groups?routeName=test')).thenAnswer((_) => Future.value(Response(helperGroupListJson, 200)));
      await _before(tester);
      await tester.pump();
      await tester.pump(Duration(seconds: 1));
      // helper group selection is active
      expect(find.text("introduction"), findsOneWidget);
      expect(find.text("test_intro2"), findsOneWidget);
      // click on Add
      await tester.tap(find.text("Create new group"));
      await tester.pump();
      // click on Add and see create page
      await tester.tap(find.text("Create new group"));
      await tester.pump();
      expect(find.byType(CreateHelperGroup), findsOneWidget);
    });

    testWidgets('[step 1] no groups available on page => click on create new group and create a group', (WidgetTester tester) async {
      var helperGroupListJson = '''[]''';
      var myNewHelperGroupName = 'My Helper Group Name';
      when(httpClientMock.get('editor/groups?routeName=test')).thenAnswer((_) => Future.value(Response(helperGroupListJson, 200)));
      await _before(tester);
      await tester.pump(Duration(seconds: 1));
      await tester.pump(Duration(seconds: 1));
      // Circle progress is not visible
      expect(find.byType(CircularProgressIndicator), findsNothing);
      // click on Add
      await tester.tap(find.text("Create new group"));
      await tester.pump();
      // create a group
      expect(find.byType(CreateHelperGroup), findsOneWidget);
      await tester.enterText(find.byKey(ValueKey('pal_CreateHelperGroup_TextField_Name')), myNewHelperGroupName);
      expect(presenter.viewModel.selectedHelperGroup.title, equals(myNewHelperGroupName));
      // go next step
      await tester.pump();
      expect(tester.widget<RaisedButton>(find.byKey(ValueKey('palCreateHelperNextButton'))).enabled, isTrue);
      await tester.tap(find.text("Next"));
      await tester.pump();
      // current step is 1
      expect(presenter.viewModel.step.value, 1);
      expect(tester.widget<RaisedButton>(find.byKey(ValueKey('palCreateHelperNextButton'))).enabled, isFalse);
    });

    // ------------------------------------------------------
    // STEP 2 Tests
    // ------------------------------------------------------

    testWidgets('[step 2] an existing group is selected, click on helper position => show group helpers list, by default ou helper is last', (WidgetTester tester) async {
      var groupHelperListJson = '''[
        {"id":"8290832093", "name":"my helper 1", "priority": 1},
        {"id":"8290832093", "name":"my helper 2", "priority": 2},
        {"id":"8290832093", "name":"my helper 3", "priority": 3},
        {"id":"8290832093", "name":"my helper 4", "priority": 4}
      ]''';
      await _before(tester);
      presenter.viewModel.step.value = 1;
      presenter.refreshView();
      await tester.pump(Duration(seconds: 1));
      await tester.pump(Duration(seconds: 1));
      // current step is 1
      expect(presenter.viewModel.step.value, 1);
      await tester.enterText(find.byKey(ValueKey('pal_CreateHelperGroup_TextField_Name')), 'my helper test');
      await tester.tap(find.byKey(ValueKey('pal_helperposition_group_field')));
      await tester.pump(Duration(seconds: 1));
      // select helper position in group
      expect(find.byType(HelperPositionPage), findsOneWidget);
      expect(find.byType(ListTile), findsNWidgets(5));
      // validate helper position in group
      await tester.tap(find.text("Validate position"));
      await tester.pump();
    });

  });
}
