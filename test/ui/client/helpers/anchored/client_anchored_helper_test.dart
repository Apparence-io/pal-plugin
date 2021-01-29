import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/router.dart';
import 'package:pal/src/ui/client/helpers/user_anchored_helper/anchored_helper_widget.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';
import '../../../../../lib/src/extensions/color_extension.dart';
import '../../../../pal_test_utilities.dart';
import './data.dart';

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

  Future beforeEach(WidgetTester tester, HelperEntity helperEntity) async {
    await initAppWithPal(tester, _myHomeTest, _navigatorKey,
        editorModeEnabled: false);
    showOverlayed(
        _navigatorKey,
        (context) => AnchoredHelper.fromEntity(
              titleLabel: HelperSharedFactory.parseTextLabel(
                AnchoredscreenHelperKeys.TITLE_KEY,
                helperEntity.helperTexts,
              ),
              descriptionLabel: HelperSharedFactory.parseTextLabel(
                AnchoredscreenHelperKeys.DESCRIPTION_KEY,
                helperEntity.helperTexts,
              ),
              // TODO: Create ID for box
              helperBoxViewModel: HelperBoxViewModel(
                backgroundColor: HexColor.fromHex(
                    helperEntity.helperBoxes.first.backgroundColor),
                id: helperEntity.helperBoxes.first.id,
              ),
              // TODO: Create on back correct way to save id
              anchorKey: helperEntity.helperBoxes.first.key,
              positivButtonLabel: HelperSharedFactory.parseButtonLabel(
                AnchoredscreenHelperKeys.POSITIV_KEY,
                helperEntity.helperTexts,
              ),
              negativButtonLabel: HelperSharedFactory.parseButtonLabel(
                AnchoredscreenHelperKeys.NEGATIV_KEY,
                helperEntity.helperTexts,
              ),
              onError: () {
                var key = OverlayKeys.PAGE_OVERLAY_KEY;
                Overlayed.of(_navigatorKey.currentState.context)
                    .entries[key]
                    .remove();
                Overlayed.of(_navigatorKey.currentState.context)
                    .entries
                    .remove(key);
              },
            ),
        key: OverlayKeys.PAGE_OVERLAY_KEY);
    await tester.pump(Duration(seconds: 2));
  }

  group('Client anchored helper', () {
    testWidgets(
        'valid anchored helper entity => show anchored helper as overlay',
        (WidgetTester tester) async {
      await beforeEach(tester, validAnchoredHelperEntity);
      expect(find.byType(AnchoredHelper), findsOneWidget);
      validAnchoredHelperEntity.helperTexts.forEach((element) {
        var textWidget =
            find.text(element.value).evaluate().first.widget as Text;
        expect(textWidget, isNotNull);
        expect(textWidget.style.color.toHex(), element.fontColor);
        expect(textWidget.style.fontWeight,
            FontWeightMapper.toFontWeight(element.fontWeight));
        expect(textWidget.style.fontFamily, contains(element.fontFamily));
        expect(textWidget.style.fontSize, element.fontSize);
      });
      await tester.pump();
    });

    testWidgets(
        'invalid anchored helper entity (key not found) => overlay is auto dismiss',
        (WidgetTester tester) async {
      await beforeEach(tester, helperEntityKeyNotFound);
      await tester.pump();
      await tester.pump();
      expect(find.byType(AnchoredHelper), findsNothing);
    });
  });
}
