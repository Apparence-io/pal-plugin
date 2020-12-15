import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/router.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_tutorial.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import '../../../pal_test_utilities.dart';

void main() {

  final _navigatorKey = GlobalKey<NavigatorState>();

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

  Future beforeEach(WidgetTester tester) async {
    await initAppWithPal(tester, _myHomeTest, _navigatorKey);
    showOverlayedInContext(
      (context) => EditorTutorialOverlay(
        title: "First step",
        content: "Select the widget you want to explain.",
        onPressDismiss: () => print("nothing"),
      ),
      key: OverlayKeys.PAGE_OVERLAY_KEY
    );
    await tester.pump(Duration(seconds: 2));
  }

  group('editor tutorial test', () {
    testWidgets('create a tutorial with title and content', (WidgetTester tester) async {
      await beforeEach(tester);
      expect(find.text("First step"), findsOneWidget);
      expect(find.text("Select the widget you want to explain."), findsOneWidget);
      expect(find.byType(OutlineButton), findsOneWidget);
    });
  });  
}