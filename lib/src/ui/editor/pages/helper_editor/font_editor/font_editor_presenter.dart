import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';

class FontEditorDialogPresenter
    extends Presenter<FontEditorDialogModel, FontEditorDialogView> {
  final TextStyle actualTextStyle;

  FontEditorDialogPresenter(
    FontEditorDialogView viewInterface, {
    @required this.actualTextStyle,
  }) : super(FontEditorDialogModel(), viewInterface);

  @override
  void onInit() {
    this.viewModel.modifiedTextStyle = TextStyle().merge(actualTextStyle);
    this.viewModel.fontFamilyName =
        this.viewModel.modifiedTextStyle.fontFamily != null
            ? this.viewModel.modifiedTextStyle.fontFamily.toString()
            : 'Default';

    WidgetsBinding.instance.addPostFrameCallback(afterFirstLayout);
  }

  void afterFirstLayout(Duration duration) {
    // Override color to be always visible!
    this.viewModel.modifiedTextStyle = this.viewModel.modifiedTextStyle.merge(
          TextStyle(
            color: Color(0xFF03045E),
          ),
        );
  }

  void changeFontFamily(BuildContext context) async {
    final String fontKey = await this.viewInterface.openFontFamilyPicker(context);

    if (fontKey == null) {
      return;
    }
    this.viewModel.fontFamilyName = fontKey;
    this.viewModel.modifiedTextStyle = this
        .viewModel
        .modifiedTextStyle
        .merge(GoogleFonts.asMap()[fontKey].call());
    this.refreshView();
  }

  void changeFontWeight(BuildContext context) async {
    final String fontWeightKey = await this.viewInterface.openFontWeightPicker(context);

    if (fontWeightKey == null) {
      return;
    }
    // TODO: 
  }
}
