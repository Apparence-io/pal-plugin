import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

class FontWeightPickerModel extends MVVMModel {
  Map<String, FontWeight> fontWeights;
  String selectedFontWeightKey;

  FontWeightPickerModel({
    this.fontWeights,
    this.selectedFontWeightKey,
  });
}