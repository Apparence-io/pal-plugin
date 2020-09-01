import 'package:flutter/material.dart';

class BorderedTextField extends StatelessWidget {
  final String label;
  final String hintText;
  final String Function(String) validator;
  final TextEditingController controller;

  const BorderedTextField({
    Key key,
    @required this.label,
    @required this.hintText,
    @required this.validator,
    @required this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          controller: controller,
          decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: const BorderRadius.all(Radius.circular(7.0))),
            hintText: hintText,
          ),
          validator: validator,
        ),
      ],
    );
  }
}
