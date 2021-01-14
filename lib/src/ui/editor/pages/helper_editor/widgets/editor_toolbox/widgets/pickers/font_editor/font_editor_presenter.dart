import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';

class FontEditorDialogPresenter
    extends Presenter<FontEditorDialogModel, FontEditorDialogView> {
  final TextStyle actualTextStyle;
  final String fontFamilyKey;

  FontEditorDialogPresenter(
    FontEditorDialogView viewInterface, {
    @required this.actualTextStyle,
    this.fontFamilyKey,
  }) : super(FontEditorDialogModel(), viewInterface);

  @override
  void onInit() {
    this.viewModel.modifiedTextStyle = TextStyle().merge(actualTextStyle);
    this.viewModel.fontKeys = FontKeys(
      fontFamilyNameKey: (fontFamilyKey != null && fontFamilyKey.length > 0) ? fontFamilyKey : 'Montserrat',
      fontWeightNameKey:
          FontWeightMapper.toFontKey(actualTextStyle.fontWeight),
    );

    WidgetsBinding.instance.addPostFrameCallback(afterFirstLayout);
  }

  void afterFirstLayout(Duration duration) {
    // Override color to be always visible!
    this.viewModel.modifiedTextStyle = this
        .viewModel
        .modifiedTextStyle
        .merge(this.viewInterface.defaultTextFieldPreviewColor());
    this.refreshView();
  }

  void changeFontSize(double fontSize) async {
    this.viewModel.modifiedTextStyle = this.viewModel.modifiedTextStyle.merge(
        TextStyle(fontSize: fontSize),
    );
    this.refreshView();
  }

  void changeFontFamily(BuildContext context) async {
    final String fontKey = await this.viewInterface.openFontFamilyPicker(
          context,
          this.viewModel.fontKeys,
        );

    if (fontKey == null) {
      return;
    }
    this.viewModel.fontKeys.fontFamilyNameKey = fontKey;
    this.viewModel.modifiedTextStyle = this
        .viewModel
        .modifiedTextStyle
        .merge(GoogleFonts.asMap()[fontKey].call());
    this.refreshView();
  }

  void changeFontWeight(BuildContext context) async {
    final MapEntry<String, FontWeight> fontWeightMap =
        await this.viewInterface.openFontWeightPicker(
              context,
              this.viewModel.fontKeys,
            );

    if (fontWeightMap == null) {
      return;
    }
    this.viewModel.fontKeys.fontWeightNameKey = fontWeightMap.key;
    this.viewModel.modifiedTextStyle = this.viewModel.modifiedTextStyle.merge(
          TextStyle(
            fontWeight: fontWeightMap.value,
          ),
        );
    this.refreshView();
  }
}
