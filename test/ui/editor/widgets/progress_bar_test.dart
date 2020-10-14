import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/widgets/progress_widget/progress_bar_widget.dart';
import 'package:palplugin/src/ui/editor/widgets/progress_widget/pulsing_circle.dart';

void main() {
  group('Progress Bar', () {
    ValueNotifier<int> notifier;
    ProgressBarWidget widget;

    _setup(WidgetTester tester) async {
      notifier = ValueNotifier(2);
      widget = ProgressBarWidget(nbSteps: 5,step: notifier,);

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

      Finder bar = find.byKey(ValueKey('ProgressBar'));

      expect(bar, findsOneWidget);
      expect(find.byKey(ValueKey('PulsingCircle')), findsNWidgets(5));
    });

    testWidgets('only 2nd circle should be active', (WidgetTester tester) async {
      await _setup(tester);

      Finder circles = find.byKey(ValueKey('PulsingCircle'));
      PulsingCircleWidget circle = tester.widget(circles.at(2));

      expect(circle.active, isTrue);

      circle = tester.widget(circles.at(1));

      expect(circle.done, isTrue);

      circle = tester.widget(circles.at(3));

      expect(circle.active, isFalse);
    });

    testWidgets('should move from step 2 -> 3', (WidgetTester tester) async {
      await _setup(tester);

      Finder circles = find.byKey(ValueKey('PulsingCircle'));
      PulsingCircleWidget circle = tester.widget(circles.at(2));

      expect(circle.active, isTrue);
      notifier.value++;
      await tester.pump(Duration(seconds: 2));

      circle = tester.widget(circles.at(2));
      expect(widget.step.value,equals(3));
      expect(circle.active,isFalse);
      expect(circle.done,isTrue);

      circle = tester.widget(circles.at(3));
      expect(circle.active,isTrue);
    });

    testWidgets('should move from step 3 -> 2', (WidgetTester tester) async {
      await _setup(tester);

      Finder circles = find.byKey(ValueKey('PulsingCircle'));
      PulsingCircleWidget circle = tester.widget(circles.at(2));

      expect(circle.active, isTrue);

      notifier.value--;
      await tester.pump(Duration(seconds: 2));

      circle = tester.widget(circles.at(2));

      expect(widget.step.value,equals(1));
      expect(circle.active,isFalse);
      expect(circle.done,isFalse);

      circle = tester.widget(circles.at(1));
      expect(circle.active,isTrue);
    });
  });
}
