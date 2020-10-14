import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/helper_details/helper_details_view.dart';

class MockHelperService extends Mock implements HelperService{}

main() {
  group('Helper Details', () {
    MockHelperService service = MockHelperService();

    HelperEntity helper = HelperEntity(
      name: 'testName',
      triggerType: HelperTriggerType.ON_SCREEN_VISIT,
      type: HelperType.SIMPLE_HELPER,
      versionMax: '2',
      versionMin: '1');

    Future _initPage(WidgetTester tester,) async {
      HelperDetailsComponent component = HelperDetailsComponent(helper: helper,testHelperService:service,);

      var app = new MediaQuery(
          data: MediaQueryData(),
          child: PalTheme(
            theme: PalThemeData.light(),
            child: Builder(
              builder: (context) => MaterialApp(
                theme: PalTheme.of(context).buildTheme(),
                home: Scaffold(body: component)
              ),
            ),
          ));
      await tester.pumpWidget(app);
    }
    
    testWidgets("Loads properly", (tester) async {
      await _initPage(tester);
      expect(find.byKey(ValueKey('helperDetails')),findsOneWidget);
    });

    testWidgets("Finds versions and trigger type", (tester) async {
      await _initPage(tester);
      Text versions = tester.widget(find.byKey(ValueKey('versions'))) ;
      expect(versions.data,equals('1 - 2'));

      Text triggerMode = tester.widget(find.byKey(ValueKey('triggerMode')));
      expect(triggerMode.data, equals(getHelperTriggerTypeDescription(helper.triggerType)));
    });

    testWidgets("Calls service on delete click", (tester) async {
      await _initPage(tester);
      
      when(service.deleteHelper("testId")).thenAnswer((realInvocation) => Future.value(null));

      Finder delete = find.byKey(ValueKey('deleteHelper'));
      await tester.tap(delete);

      await tester.pump();

      verify(service.deleteHelper("testId")).called(1);
    });
  });
}