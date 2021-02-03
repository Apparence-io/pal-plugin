import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_details/helper_details_view.dart';

class MockHelperService extends Mock implements EditorHelperService {}

main() {
  group('Helper Details', () {
    MockHelperService service = MockHelperService();

    HelperEntity helper = HelperEntity(
      name: 'testName',
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      type: HelperType.SIMPLE_HELPER,
      // versionMax: '2', //FIXME
      // versionMin: '1',
    );

    Future _initPage(
      WidgetTester tester,
    ) async {
      HelperDetailsComponent component = HelperDetailsComponent(
        arguments: HelperDetailsComponentArguments(null, helper, 'page-id', '/pageRoute'),
        testHelperService: service,
      );

      var app = new MediaQuery(
          data: MediaQueryData(),
          child: PalTheme(
            theme: PalThemeData.light(),
            child: Builder(
              builder: (context) => MaterialApp(
                  theme: PalTheme.of(context).buildTheme(),
                  home: Scaffold(body: component)),
            ),
          ));
      await tester.pumpWidget(app);
    }

    testWidgets('should load properly', (tester) async {
      await _initPage(tester);
      
      expect(find.byKey(ValueKey('pal_HelperDetailsComponent_Builder')), findsOneWidget);
      expect(find.byKey(ValueKey('deleteHelper')), findsOneWidget);
      expect(find.text('Available on version'), findsOneWidget);
      expect(find.text('Trigger mode'), findsOneWidget);
    });

    testWidgets("Finds versions and trigger type", (tester) async {
      await _initPage(tester);
      Text versions = tester.widget(find.byKey(ValueKey('versions')));
      expect(versions.data, equals('1 - 2'));

      Text triggerMode = tester.widget(find.byKey(ValueKey('triggerMode')));
      expect(triggerMode.data,
          equals(getHelperTriggerTypeDescription(helper.triggerType)));
    });

    testWidgets('should remove helper', (tester) async {
      await _initPage(tester);

      when(service.deleteHelper('page-id', helper.id))
          .thenAnswer((realInvocation) => Future.value(null));

      Finder delete = find.byKey(ValueKey('deleteHelper'));
      await tester.tap(delete);
      await tester.pumpAndSettle();

      expect(
          find.byKey(
              ValueKey('pal_HelperDetailsComponent_DeleteDialog_Android')),
          findsOneWidget);

      final approveButton = find.byKey(
          ValueKey('pal_HelperDetailsComponent_DeleteDialog_Android_Approve'));
      await tester.tap(approveButton);
      await tester.pumpAndSettle();

      verify(service.deleteHelper('page-id', helper.id)).called(1);
    });

    testWidgets('should edit an helper', (tester) async {
      await _initPage(tester);

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });

    testWidgets('should cancel dialog', (tester) async {
      await _initPage(tester);

      Finder delete = find.byKey(ValueKey('deleteHelper'));
      await tester.tap(delete);
      await tester.pumpAndSettle();

      expect(
          find.byKey(
              ValueKey('pal_HelperDetailsComponent_DeleteDialog_Android')),
          findsOneWidget);

      final approveButton = find.byKey(
          ValueKey('pal_HelperDetailsComponent_DeleteDialog_Android_Cancel'));
      await tester.tap(approveButton);
      await tester.pumpAndSettle();

      expect(
          find.byKey(
              ValueKey('pal_HelperDetailsComponent_DeleteDialog_Android')),
          findsNothing);
    });
  });
}
