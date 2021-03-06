import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


typedef OnValueChanged = void Function(String);
typedef TextFieldValidator = String? Function(String?);
typedef OnFieldSubmitted = void Function(String);

class BorderedTextField extends StatelessWidget {
  final String? hintText, initialValue;
  final TextFieldValidator? validator;
  final OnValueChanged? onValueChanged;
  final OnFieldSubmitted? onFieldSubmitted;
  final TextEditingController? controller;
  final TextInputType? textInputType;
  final List<TextInputFormatter>? inputFormatters;
  final bool enableSuggestions;
  final bool autovalidate;
  final bool isLoading;
  final TextCapitalization textCapitalization;

  const BorderedTextField({
    Key? key,
    this.hintText,
    this.validator,
    this.controller,
    this.inputFormatters,
    this.textInputType,
    this.enableSuggestions = false,
    this.autovalidate = false,
    this.onValueChanged,
    this.onFieldSubmitted,
    this.initialValue,
    this.isLoading = true,
    this.textCapitalization = TextCapitalization.none,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        TextFormField(
          autovalidateMode: (autovalidate)
              ? AutovalidateMode.onUserInteraction
              : AutovalidateMode.disabled,
          controller: controller,
          initialValue: initialValue,
          enableSuggestions: enableSuggestions,
          keyboardType: textInputType,
          textCapitalization: textCapitalization,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7.0))),
            hintText: hintText,
          ),
          inputFormatters: inputFormatters,
          validator: validator,
          onChanged: (String newValue) {
            if (this.onValueChanged != null) {
              this.onValueChanged!(newValue);
            }
          },
          onFieldSubmitted: this.onFieldSubmitted,
        ),
        if (isLoading && hintText == null)
          Positioned(
            top: 25.0,
            left: 15,
            child: SizedBox(
              height: 10.0,
              width: 10.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
              ),
            ),
          )
      ],
    );
  }
}
