import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/shared/widgets/progress_widget/progress_bar.dart';

void main() {
  group('Progress Bar', () {
    ProgressWidget widget = ProgressWidget(nbSteps: 5,step: 2,);

    _setup(WidgetTester tester) async {
      var app = new MediaQuery(
        data: MediaQueryData(),
        child: PalTheme(
          theme: PalThemeData.light(),
          child: Builder(
            builder: (context) => MaterialApp(
              theme: PalTheme.of(context).buildTheme(),
              home: widget,
            ),
          ),
        ),
      );
      await tester.pumpWidget(app);
    }

    testWidgets('should display correctly', (WidgetTester tester) async {
      await _setup(tester);

      expect(find.byKey(ValueKey('ProgressBar')), findsOneWidget);
      expect(find.byKey(ValueKey('PulsingCircle')), findsNWidgets(5));
    });
  });
}
