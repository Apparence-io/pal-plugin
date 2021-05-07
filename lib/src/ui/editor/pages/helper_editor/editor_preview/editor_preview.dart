import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/extensions/color_extension.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/simple_helper.dart';
import 'package:pal/src/ui/client/helpers/simple_helper/widget/simple_helper_layout.dart';
import 'package:pal/src/ui/client/helpers/user_anchored_helper/anchored_helper_widget.dart';
import 'package:pal/src/ui/client/helpers/user_fullscreen_helper/user_fullscreen_helper.dart';
import 'package:pal/src/ui/client/helpers/user_update_helper/user_update_helper.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/helper_shared_factory.dart';
import 'package:pal/src/ui/shared/helper_shared_viewmodels.dart';

import 'editor_preview_presenter.dart';
import 'editor_preview_viewmodel.dart';

class EditorPreviewArguments {
  final String? helperId;
  final Widget? preBuiltHelper;
  final Function(BuildContext) onDismiss;

  EditorPreviewArguments(
    this.onDismiss, {
    this.preBuiltHelper,
    this.helperId,
  });
}

abstract class EditorPreviewView {
  Widget buildFullscreen(HelperEntity helperEntity, Function(BuildContext?) onDismiss);

  Widget buildSimple(HelperEntity helperEntity, Function(BuildContext?) onDismiss);

  Widget buildAnchored(HelperEntity helperEntity, Function(BuildContext?) onDismiss);

  Widget buildUpdate(HelperEntity helperEntity, Function(BuildContext?) onDismiss);
}

class EditorPreviewPage extends StatelessWidget implements EditorPreviewView {
  final EditorPreviewArguments? args;

  EditorPreviewPage({
    Key? key,
    required this.args,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<EditorPreviewPresenter, EditorPreviewModel>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: ValueKey('EditorPreviewPage_Builder'),
      context: context,
      presenterBuilder: (context) => EditorPreviewPresenter(this,
          args: this.args!,
          helperService: EditorInjector.of(context)!.helperService),
      builder: (context, presenter, model) {
        return Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final EditorPreviewPresenter presenter,
    final EditorPreviewModel model,
  ) {
    return model.loading
        ? Center(child: CircularProgressIndicator(value: null))
        : Stack(
            fit: StackFit.expand,
            children: [
              presenter.getHelper()!,
            ],
          );
  }

  @override
  Widget buildFullscreen(HelperEntity helperEntity, Function(BuildContext?) onDismiss) {
    return UserFullScreenHelperPage(
      helperBoxViewModel: HelperSharedFactory.parseBoxBackground(
        FullscreenHelperKeys.BACKGROUND_KEY,
        helperEntity.helperBoxes!,
      )!,
      titleLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.TITLE_KEY,
        helperEntity.helperTexts!,
      )!,
      descriptionLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.DESCRIPTION_KEY,
        helperEntity.helperTexts!,
      )!,
      headerImageViewModel: HelperSharedFactory.parseImageUrl(
        FullscreenHelperKeys.IMAGE_KEY,
        helperEntity.helperImages,
      ),
      negativLabel: HelperSharedFactory.parseButtonLabel(
        FullscreenHelperKeys.NEGATIV_KEY,
        helperEntity.helperTexts!,
      ),
      positivLabel: HelperSharedFactory.parseButtonLabel(
        FullscreenHelperKeys.POSITIV_KEY,
        helperEntity.helperTexts!,
      ),
      onNegativButtonTap: () => onDismiss(_scaffoldKey.currentContext),
      onPositivButtonTap: () => onDismiss(_scaffoldKey.currentContext),
    );
  }

  @override
  Widget buildSimple(HelperEntity helperEntity, Function(BuildContext?) onDismiss) {
    SimpleHelperPage content = SimpleHelperPage(
      // helperBoxViewModel: HelperSharedFactory.parseBoxNotifier(model.bodyBox),
      descriptionLabel: HelperSharedFactory.parseTextLabel(
        SimpleHelperKeys.CONTENT_KEY,
        helperEntity.helperTexts!,
      )!,
    );
    return SimpleHelperLayout(
      toaster: content,
      onDismissed: (res) => onDismiss(_scaffoldKey.currentContext),
    );
  }

  @override
  Widget buildAnchored(HelperEntity helperEntity, Function(BuildContext?) onDismiss) {
    return AnchoredHelper.fromEntity(
      finderService:
          EditorInjector.of(_scaffoldKey.currentContext!)!.finderService,
      positivButtonLabel: HelperSharedFactory.parseButtonLabel(
        FullscreenHelperKeys.POSITIV_KEY,
        helperEntity.helperTexts!,
      ),
      titleLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.TITLE_KEY,
        helperEntity.helperTexts!,
      ),
      descriptionLabel: HelperSharedFactory.parseTextLabel(
        FullscreenHelperKeys.DESCRIPTION_KEY,
        helperEntity.helperTexts!,
      ),
      negativButtonLabel: HelperSharedFactory.parseButtonLabel(
        FullscreenHelperKeys.NEGATIV_KEY,
        helperEntity.helperTexts!,
      ),
      helperBoxViewModel: HelperBoxViewModel(
          id: helperEntity.helperBoxes?.first.id,
          backgroundColor: HexColor.fromHex(
              helperEntity.helperBoxes!.first.backgroundColor!)),
      anchorKey: helperEntity.helperBoxes?.first.key,
      onNegativButtonTap: () => onDismiss(_scaffoldKey.currentContext),
      onPositivButtonTap: () => onDismiss(_scaffoldKey.currentContext),
    );
  }

  @override
  Widget buildUpdate(HelperEntity helperEntity, Function(BuildContext?) onDismiss) {
    Map<String, EditableTextFormData> changelogsMap = {};
    List<HelperTextViewModel> changelogs = HelperSharedFactory.parseTextsLabel(
      UpdatescreenHelperKeys.LINES_KEY,
      helperEntity.helperTexts!,
    );
    if (changelogs.length > 0) {
      int index = 0;
      for (var changelog in changelogs) {
        changelogsMap.putIfAbsent(
          'template_${changelog.id.toString()}',
          () => EditableTextFormData(
            changelog.id,
            '${UpdatescreenHelperKeys.LINES_KEY}_${index++}',
            text: changelog.text ?? '',
            fontColor: changelog.fontColor ?? Colors.white,
            fontSize: changelog.fontSize?.toInt() ?? 18,
            fontFamily: changelog.fontFamily,
            fontWeight: FontWeightMapper.toFontKey(changelog.fontWeight),
          ),
        );
      }
    }
    return UserUpdateHelperPage(
      helperBoxViewModel: HelperSharedFactory.parseBoxBackground(
        SimpleHelperKeys.BACKGROUND_KEY,
        helperEntity.helperBoxes!,
      )!,
      titleLabel: HelperSharedFactory.parseTextLabel(
        UpdatescreenHelperKeys.TITLE_KEY,
        helperEntity.helperTexts!,
      )!,
      thanksButtonLabel: HelperSharedFactory.parseButtonLabel(
        UpdatescreenHelperKeys.POSITIV_KEY,
        helperEntity.helperTexts!,
      ),
      changelogLabels: changelogs,
      helperImageViewModel: HelperSharedFactory.parseImageUrl(
        UpdatescreenHelperKeys.IMAGE_KEY,
        helperEntity.helperImages,
      ),
      onPositivButtonTap: () => onDismiss(_scaffoldKey.currentContext),
      packageVersionReader:
          EditorInjector.of(_scaffoldKey.currentContext!)!.packageVersionReader,
    );
  }
}
