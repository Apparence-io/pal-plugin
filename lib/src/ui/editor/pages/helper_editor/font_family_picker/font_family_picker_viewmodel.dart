import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class FontFamilyPickerModel extends MVVMModel {
  Map<String, TextStyle> fonts;
  Map<String, TextStyle> originalFonts;
  bool isLoading;

  FontFamilyPickerModel({
    this.fonts,
    this.originalFonts,
    this.isLoading,
  });
}
