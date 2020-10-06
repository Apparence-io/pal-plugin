import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_family_picker/font_family_picker.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_family_picker/font_family_picker_viewmodel.dart';

class FontFamilyPickerPresenter
    extends Presenter<FontFamilyPickerModel, FontFamilyPickerView> {
  FontFamilyPickerPresenter(
    FontFamilyPickerView viewInterface,
  ) : super(FontFamilyPickerModel(), viewInterface);

  @override
  void onInit() {
    this.viewModel.originalFonts = {};
    this.viewModel.fonts = {};

    this.viewModel.isLoading = true;
    this.refreshView();
    GoogleFonts.asMap().forEach((key, value) {
      TextStyle textStyle = value.call();
      this.viewModel.originalFonts.putIfAbsent(key, () => textStyle);
      this.viewModel.fonts.putIfAbsent(key, () => textStyle);
    });
    this.viewModel.isLoading = false;
    this.refreshView();
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      Map<String, TextStyle> dummyListData = {};
      this.viewModel.originalFonts.forEach((key, value) {
        final fontFamily = value.fontFamily.toString();
        final fontName = fontFamily.split('_regular').first;
        final lowerQuery = query.toLowerCase();
        final lowerFontName = fontName.toLowerCase();

        if (lowerFontName.contains(lowerQuery)) {
          dummyListData.putIfAbsent(key, () => value);
        }
      });
      this.viewModel.fonts.clear();
      this.viewModel.fonts.addAll(dummyListData);
    } else {
      this.viewModel.fonts.clear();
      this.viewModel.fonts.addAll(this.viewModel.originalFonts);
    }

    this.refreshView();
  }
}
