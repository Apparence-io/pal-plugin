import 'package:flutter/material.dart';

class BorderedTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final String Function(String) validator;
  final Function(String) onValueChanged;
  final TextEditingController controller;
  final bool enableSuggestions;
  final bool autovalidate;

  const BorderedTextField({
    Key key,
    this.label,
    @required this.hintText,
    @required this.validator,
    @required this.controller,
    this.enableSuggestions = false,
    this.autovalidate = false,
    this.onValueChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (label != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 5.0),
            child: Text(
              label,
              style: TextStyle(
                fontSize: 10.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        TextFormField(
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
        ),
      ],
    );
  }
}
