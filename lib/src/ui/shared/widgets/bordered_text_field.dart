import 'package:flutter/material.dart';

class BorderedTextField extends StatelessWidget {
  final String hintText;
  final String Function(String) validator;
  final Function(String) onValueChanged;
  final TextEditingController controller;
  final bool enableSuggestions;
  final bool autovalidate;

  const BorderedTextField({
    Key key,
    @required this.hintText,
    @required this.validator,
    @required this.controller,
    this.enableSuggestions = false,
    this.autovalidate = false,
    this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidate: autovalidate,
      controller: controller,
      enableSuggestions: enableSuggestions,
      decoration: InputDecoration(
        border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(7.0))),
        hintText: hintText,
      ),
      validator: validator,
      onChanged: (String newValue) {
        if (this.onValueChanged != null) {
          this.onValueChanged(newValue);
        }
      },
    );
  }
}
