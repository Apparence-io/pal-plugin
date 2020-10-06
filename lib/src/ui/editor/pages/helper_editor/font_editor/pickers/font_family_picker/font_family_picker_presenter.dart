import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_family_picker/font_family_picker.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_family_picker/font_family_picker_viewmodel.dart';

List<String> fontKeysConverter(int sar) {
  List<String> fontKeys = [];
  GoogleFonts.asMap().forEach((key, value) {
    fontKeys.add(key);
  });
  return fontKeys;
}

class FontFamilyPickerPresenter
    extends Presenter<FontFamilyPickerModel, FontFamilyPickerView> {
  FontFamilyPickerPresenter(
    FontFamilyPickerView viewInterface,
  ) : super(FontFamilyPickerModel(), viewInterface);

  @override
  void onInit() {
    this.viewModel.originalFonts = [];
    this.viewModel.fonts = [];

    this.setup();
  }

  setup() async {
    this.viewModel.isLoading = true;
    this.refreshView();
    
    // Create font textstyles map in background (other isolate)
    this.viewModel.originalFonts = await compute(fontKeysConverter, 0);
    this.viewModel.fonts = List.from(this.viewModel.originalFonts);

    this.viewModel.isLoading = false;
    this.refreshView();
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      this.viewModel.originalFonts.forEach((fontKey) {
        final lowerQuery = query.toLowerCase();
        final lowerFontName = fontKey.toLowerCase();

        if (lowerFontName.contains(lowerQuery)) {
          dummyListData.add(fontKey);
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
