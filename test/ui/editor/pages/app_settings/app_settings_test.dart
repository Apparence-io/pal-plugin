import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/services/editor/project/app_icon_grabber_delegate.dart';
import 'package:palplugin/src/services/editor/project/project_editor_service.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings.dart';

class PackageVersionReaderMock extends Mock implements PackageVersionReader {}

class AppIconGrabberDelegateMock extends Mock
    implements AppIconGrabberDelegate {}

class ProjectEditorServiceMock extends Mock implements ProjectEditorService {}

void main() {
  group('App settings', () {
    testWidgets('should create page correctly', (WidgetTester tester) async {
      await _beforeEach(tester);

      // Check if page exist
      expect(find.byKey(ValueKey('pal_AppSettingsPage_Stack')), findsOneWidget);
      expect(find.byKey(ValueKey('pal_AppSettingsPage_AppIcon')), findsOneWidget);
    });

    testWidgets('should show app infos', (WidgetTester tester) async {
      await _beforeEach(tester);

      expect(find.text('Pal example'), findsOneWidget);
      expect(find.text('Version 1.0.0'), findsOneWidget);

      expect(find.text('Beta account member'), findsOneWidget);
    });

    // testWidgets('should change app icon', (WidgetTester tester) async {
    //   await _beforeEach(tester);

    //   var updateAppIconButton = find.byKey(ValueKey('pal_AppSettingsPage_AnimatedAppIcon_RefreshButton'));
    //   await tester.tap(updateAppIconButton);
    //   await tester.pumpAndSettle();

    //   expect(find.byType(SnackBar), findsOneWidget);
    // });
  });
}

Future _beforeEach(
  WidgetTester tester,
) async {
  var packageVersionReaderService = PackageVersionReaderMock();
  var appIconGrabberDelegate = AppIconGrabberDelegateMock();
  var projectEditorService = ProjectEditorServiceMock();

  when(packageVersionReaderService.init()).thenAnswer((_) => Future.value());
  when(packageVersionReaderService.version).thenReturn('1.0.0');
  when(packageVersionReaderService.appName).thenReturn('Pal example');
  when(appIconGrabberDelegate.getClientAppIcon())
      .thenAnswer((_) => Future.value(Uint8List(32)));
  when(projectEditorService.sendAppIcon(any))
      .thenAnswer((_) => Future.value(true));

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
              projectEditorService: projectEditorService,
              testMode: true,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle(Duration(milliseconds: 700));
}
