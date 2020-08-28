import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/ui/client/helper_orchestrator.dart';

void main() {
  group('HelperOrchestrator', () {

    testWidgets('should create properly and accessible from children', (WidgetTester tester) async {
      HelperOrchestrator orchestatorInstance;
      HelperOrchestrator orchestator = HelperOrchestrator(
        child: Scaffold(
          body: Builder(
            builder: (context) {
              orchestatorInstance = HelperOrchestrator.of(context);
              return Container(key: ValueKey("paged"));
            },
          )
        ),
      );
      var app = new MediaQuery(data: MediaQueryData(),
        child: MaterialApp(home: orchestator)
      );
      await tester.pumpWidget(app);
      expect(orchestatorInstance, isNotNull);
    });



  });
}