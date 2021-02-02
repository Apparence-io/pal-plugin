import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_sending_overlay.dart';

void main() {
  group('EditorSendingOverlay', () {

    var appContext;

    Widget myApp = PalTheme(
      theme: PalThemeData.light(),
      child: MaterialApp(
        home: Builder(
          builder: (context) {
            appContext = context;
            return Container(
              child: Text("my page content"),
            );
          },
        )
      ),
    );

    testWidgets('show loading overlay', (WidgetTester tester) async {
      await tester.pumpWidget(myApp);
      var valueNotifier = ValueNotifier(SendingStatus.SENDING);
      expect(find.text("loading"), findsNothing);
      expect(find.text("success"), findsNothing);
      expect(find.text("error"), findsNothing);
      var sendingOverlay = new EditorSendingOverlay(
        loadingMessage: "loading",
        successMessage: "success",
        errorMessage: "error",
        loadingOpacity: 1,
        status: valueNotifier
      );
      sendingOverlay.show(appContext);
      await tester.pump();
      expect(find.text("loading"), findsOneWidget);
    });

    testWidgets('show success overlay', (WidgetTester tester) async {
      await tester.pumpWidget(myApp);
      var valueNotifier = ValueNotifier(SendingStatus.SENT);
      expect(find.text("loading"), findsNothing);
      expect(find.text("success"), findsNothing);
      expect(find.text("error"), findsNothing);
      var sendingOverlay = new EditorSendingOverlay(
        loadingMessage: "loading",
        successMessage: "success",
        errorMessage: "error",
        loadingOpacity: 1,
        status: valueNotifier
      );
      sendingOverlay.show(appContext);
      await tester.pump();
      expect(find.text("success"), findsOneWidget);
    });

    testWidgets('show error overlay', (WidgetTester tester) async {
      await tester.pumpWidget(myApp);
      var valueNotifier = ValueNotifier(SendingStatus.ERROR);
      expect(find.text("loading"), findsNothing);
      expect(find.text("success"), findsNothing);
      expect(find.text("error"), findsNothing);
      var sendingOverlay = new EditorSendingOverlay(
        loadingMessage: "loading",
        successMessage: "success",
        errorMessage: "error",
        loadingOpacity: 1,
        status: valueNotifier
      );
      sendingOverlay.show(appContext);
      await tester.pump();
      expect(find.text("error"), findsOneWidget);
    });

    testWidgets('show loading overlay => then success => then dismiss', (WidgetTester tester) async {
      await tester.pumpWidget(myApp);
      var valueNotifier = ValueNotifier(SendingStatus.SENDING);
      expect(find.text("loading"), findsNothing);
      expect(find.text("success"), findsNothing);
      expect(find.text("error"), findsNothing);
      var sendingOverlay = new EditorSendingOverlay(
        loadingMessage: "loading",
        successMessage: "success",
        errorMessage: "error",
        loadingOpacity: 1,
        status: valueNotifier
      );
      sendingOverlay.show(appContext);
      await tester.pump();
      expect(find.text("loading"), findsOneWidget);

      valueNotifier.value = SendingStatus.SENT;
      await tester.pump();
      expect(find.text("success"), findsOneWidget);

      sendingOverlay.dismiss();
      await tester.pump();
      expect(find.text("loading"), findsNothing);
      expect(find.text("success"), findsNothing);
      expect(find.text("error"), findsNothing);
    });

  });
}