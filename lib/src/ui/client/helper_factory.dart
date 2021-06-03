import 'package:flutter/material.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/helper/helper_type.dart';
import 'package:pal/src/extensions/color_extension.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/simple_helper.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/user_update_helper.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

import 'helpers/simple_helper/widget/simple_helper_layout.dart';
import 'helpers/user_anchored_helper/anchored_helper_widget.dart';

class HelperFactory {
  static Widget? build(final HelperEntity helper,
      {final Function(bool positiveFeedBack)? onTrigger,
      final Function? onError}) {
    switch (helper.type) {
      case HelperType.HELPER_FULL_SCREEN:
        return _createHelperFullScreen(helper, onTrigger);
      case HelperType.SIMPLE_HELPER:
        return _createSimpleHelper(helper, onTrigger);
      case HelperType.UPDATE_HELPER:
        return _createUpdateHelper(helper, onTrigger);
      case HelperType.ANCHORED_OVERLAYED_HELPER:
        return _createAnchoredHelper(helper, onTrigger, onError);
      case null:  
        return null;
    }
  }

  static Widget _createHelperFullScreen(
    final HelperEntity helper,
    final Function? onTrigger,
  ) {
    return UserFullScreenHelperPage(
      titleLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.TITLE_KEY,
        helper.helperTexts!,
      )!,
      descriptionLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.DESCRIPTION_KEY,
        helper.helperTexts!,
      )!,
      headerImageViewModel: HelperSharedFactory.parseImageUrl(
        FullscreenHelperKeys.IMAGE_KEY,
        helper.helperImages,
      ),
      helperBoxViewModel: HelperSharedFactory.parseBoxBackground(
        FullscreenHelperKeys.BACKGROUND_KEY,
        helper.helperBoxes!,
      )!,
      positivLabel: HelperSharedFactory.parseButtonLabel(
        FullscreenHelperKeys.POSITIV_KEY,
        helper.helperTexts!
      ),
      negativLabel: HelperSharedFactory.parseButtonLabel(
        FullscreenHelperKeys.NEGATIV_KEY,
        helper.helperTexts!,
      )!..buttonStyle = HelperButtonStyle.TEXT,
      onPositivButtonTap: () => onTrigger!(true),
      onNegativButtonTap: () => onTrigger!(false),
    );
  }

  static Widget _createSimpleHelper(
    final HelperEntity helper,
    final Function? onTrigger,
  ) {
    GlobalKey<SimpleHelperLayoutState> _simpleHelperLayoutKey = GlobalKey();
    return SimpleHelperLayout(
      key: _simpleHelperLayoutKey,
      toaster: SimpleHelperPage(
        descriptionLabel: HelperSharedFactory.parseTextLabel(
          SimpleHelperKeys.CONTENT_KEY,
          helper.helperTexts!,
        )!,
        // helperBoxViewModel: HelperSharedFactory.parseBoxBackground(
        //   SimpleHelperKeys.BACKGROUND_KEY,
        //   helper.helperBoxes,
        // ),
      ),
      onDismissed: (res) async {
        await _simpleHelperLayoutKey.currentState!.reverseAnimations();
        onTrigger!(res == DismissDirection.startToEnd);
      },
    );
  }

  static Widget _createUpdateHelper(
      final HelperEntity helper, final Function? onTrigger) {
    return UserUpdateHelperPage(
      onPositivButtonTap: () {
        onTrigger!(true);
      },
      helperBoxViewModel: HelperSharedFactory.parseBoxBackground(
        UpdatescreenHelperKeys.BACKGROUND_KEY,
        helper.helperBoxes!,
      )!,
      thanksButtonLabel: HelperSharedFactory.parseButtonLabel(
        UpdatescreenHelperKeys.POSITIV_KEY,
        helper.helperTexts!,
      ),
      titleLabel: HelperSharedFactory.parseTextLabel(
        UpdatescreenHelperKeys.TITLE_KEY,
        helper.helperTexts!,
      )!,
      changelogLabels: HelperSharedFactory.parseTextsLabel(
        UpdatescreenHelperKeys.LINES_KEY,
        helper.helperTexts!,
      ),
      helperImageViewModel: HelperSharedFactory.parseImageUrl(
        UpdatescreenHelperKeys.IMAGE_KEY,
        helper.helperImages,
      ),
    );
  }

  static Widget _createAnchoredHelper(final HelperEntity helper,
      final Function? onTrigger, final Function? onError) {
    return AnchoredHelper.fromEntity(
      titleLabel: HelperSharedFactory.parseTextLabel(
        AnchoredscreenHelperKeys.TITLE_KEY,
        helper.helperTexts!,
      ),
      descriptionLabel: HelperSharedFactory.parseTextLabel(
        AnchoredscreenHelperKeys.DESCRIPTION_KEY,
        helper.helperTexts!,
      ),
      helperBoxViewModel: HelperBoxViewModel(
        backgroundColor:
            HexColor.fromHex(helper.helperBoxes!.first.backgroundColor!),
        id: helper.helperBoxes!.first.id,
      ),
      anchorKey: helper.helperBoxes!.first.key,
      positivButtonLabel: HelperSharedFactory.parseButtonLabel(
        AnchoredscreenHelperKeys.POSITIV_KEY,
        helper.helperTexts!,
      ),
      negativButtonLabel: HelperSharedFactory.parseButtonLabel(
        AnchoredscreenHelperKeys.NEGATIV_KEY,
        helper.helperTexts!,
      ),
      onPositivButtonTap: () => onTrigger!(true),
      onNegativButtonTap: () => onTrigger!(false),
      onError: onError,
    );
  }
}
