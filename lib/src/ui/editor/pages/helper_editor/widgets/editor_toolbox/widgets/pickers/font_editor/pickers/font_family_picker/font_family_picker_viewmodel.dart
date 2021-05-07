import 'package:mvvm_builder/mvvm_builder.dart';

class FontFamilyPickerModel extends MVVMModel {
  List<String>? fonts;
  List<String>? originalFonts;
  bool? isLoading;
  String? selectedFontFamilyKey;

  FontFamilyPickerModel({
    this.fonts,
    this.originalFonts,
    this.isLoading,
    this.selectedFontFamilyKey,
  });
}
