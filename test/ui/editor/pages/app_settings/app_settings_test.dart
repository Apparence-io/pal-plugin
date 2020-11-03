import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/database/entity/app_icon_entity.dart';
import 'package:pal/src/services/editor/project/app_icon_grabber_delegate.dart';
import 'package:pal/src/services/editor/project/project_editor_service.dart';
import 'package:pal/src/services/package_version.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/app_settings/app_settings.dart';

class PackageVersionReaderMock extends Mock implements PackageVersionReader {}

class AppIconGrabberDelegateMock extends Mock
    implements AppIconGrabberDelegate {}

class ProjectEditorServiceMock extends Mock implements ProjectEditorService {}

void main() {
  group('App settings', () {
    Uint8List icon = Uint8List(32);
    AppIconEntity appIcon = AppIconEntity(id: "123", url: "url");
    ProjectEditorServiceMock _projectEditorService;

    Future _beforeEach(WidgetTester tester,
        {ProjectEditorServiceMock projectEditorMock}) async {
      var packageVersionReaderService = PackageVersionReaderMock();
      var appIconGrabberDelegate = AppIconGrabberDelegateMock();
      _projectEditorService = projectEditorMock ?? ProjectEditorServiceMock();

      when(packageVersionReaderService.init())
          .thenAnswer((_) => Future.value());
      when(packageVersionReaderService.version).thenReturn('1.0.0');
      when(packageVersionReaderService.appName).thenReturn('Pal example');
      when(appIconGrabberDelegate.getClientAppIcon())
          .thenAnswer((_) => Future.value(icon));
      if (projectEditorMock == null) {
        when(_projectEditorService.sendAppIcon(any, any))
            .thenAnswer((_) => Future.value(appIcon));
        when(_projectEditorService.updateAppIcon(any, any, any)).thenAnswer(
            (_) => Future.value(AppIconEntity(id: appIcon.id, url: "newUrl")));
        when(_projectEditorService.getAppIcon())
            .thenAnswer((_) => Future.value(appIcon));
      }

      await tester.pumpWidget(
        MediaQuery(
          data: MediaQueryData(),
          child: PalTheme(
            theme: PalThemeData.light(),
            child: Builder(
              builder: (context) => MaterialApp(
                theme: PalTheme.of(context).buildTheme(),
                home: AppSettingsPage(
                  packageVersionReader: packageVersionReaderService,
                  appIconGrabberDelegate: appIconGrabberDelegate,
                  projectEditorService: _projectEditorService,
                  testMode: true,
                ),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle(Duration(milliseconds: 700));
    }

    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _beforeEach(tester);

      // Check if page exist
      expect(find.byKey(ValueKey('pal_AppSettingsPage_Stack')), findsOneWidget);
      expect(
          find.byKey(ValueKey('pal_AppSettingsPage_AppIcon')), findsOneWidget);
    });

    testWidgets('should show app infos', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.text('Pal example'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);

      expect(find.text('Beta account member'), findsOneWidget);
    });

    testWidgets(
        'should update app icon if there is already an app icon configured',
        (WidgetTester tester) async {
      await _beforeEach(tester);

      var updateAppIconButton = find
          .byKey(ValueKey('pal_AppSettingsPage_AnimatedAppIcon_RefreshButton'));
      await tester.tap(updateAppIconButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      verify(_projectEditorService.updateAppIcon(appIcon.id, icon, "png"))
          .called(1);
    });

    testWidgets('should create app icon if there is no app icon configured',
        (WidgetTester tester) async {
      ProjectEditorServiceMock mock = ProjectEditorServiceMock();
      when(mock.sendAppIcon(any, any)).thenAnswer((_) => Future.value(appIcon));
      when(mock.updateAppIcon(any, any, any)).thenAnswer(
          (_) => Future.value(AppIconEntity(id: appIcon.id, url: "newUrl")));
      when(mock.getAppIcon()).thenAnswer((_) => Future.value(AppIconEntity(
            id: null,
            url: null,
          )));

      await _beforeEach(tester, projectEditorMock: mock);

      var updateAppIconButton = find
          .byKey(ValueKey('pal_AppSettingsPage_AnimatedAppIcon_RefreshButton'));
      await tester.tap(updateAppIconButton);
      await tester.pumpAndSettle();

      expect(find.byType(SnackBar), findsOneWidget);
      verify(mock.sendAppIcon(icon, "png")).called(1);
    });
  });
}
