import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class BorderedTextField extends StatelessWidget {
  final String hintText;
  final String Function(String) validator;
  final Function(String) onValueChanged;
  final TextEditingController controller;
  final TextInputType textInputType;
  final List<TextInputFormatter> inputFormatters;
  final bool enableSuggestions;
  final bool autovalidate;

  const BorderedTextField({
    Key key,
    @required this.hintText,
    @required this.validator,
    @required this.controller,
    this.inputFormatters,
    this.textInputType,
    this.enableSuggestions = false,
    this.autovalidate = false,
    this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: (autovalidate)
          ? AutovalidateMode.onUserInteraction
          : AutovalidateMode.disabled,
      controller: controller,
      enableSuggestions: enableSuggestions,
      keyboardType: textInputType,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(7.0))),
        hintText: hintText,
      ),
      inputFormatters: inputFormatters,
      validator: validator,
      onChanged: (String newValue) {
        if (this.onValueChanged != null) {
          this.onValueChanged(newValue);
        }
      },
    );
  }
}
