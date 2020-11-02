import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_family_picker/font_family_picker_viewmodel.dart';

List<String> fontKeysConverter(int sar) {
  List<String> fontKeys = [];
  GoogleFonts.asMap().forEach((key, value) {
    fontKeys.add(key);
  });
  return fontKeys;
}

class FontFamilyPickerLoader {
  FontFamilyPickerLoader();

  Future<FontFamilyPickerModel> load() async {
    FontFamilyPickerModel viewModel = FontFamilyPickerModel();

    // Create font textstyles map in background (other isolate)
    viewModel.originalFonts = await compute(fontKeysConverter, 0);
    viewModel.fonts = List.from(viewModel.originalFonts);

    return viewModel;
  }
}