import 'dart:ui';

import 'package:flutter/material.dart';

class EditableTextDialog extends StatelessWidget {

  final TextEditingController controller;
  final FocusNode focusNode = FocusNode();

  EditableTextDialog(String initialValue)
    : this.controller = TextEditingController.fromValue(
      TextEditingValue(
        text: initialValue,
        selection: TextSelection.fromPosition(TextPosition(offset: initialValue?.length ?? 0))
      )
    );

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: SingleChildScrollView(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
          child: Container(
            color: Colors.black12,
            padding: EdgeInsets.symmetric(
              horizontal: 32,
            ),
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: Center(
              child: TextFormField(
                key: ValueKey('EditableTextDialog_Field'),
                autofocus: true,
                controller: controller,
                focusNode: focusNode,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (value) {
                  Navigator.of(context).pop(value);
                },
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ),
    );
  }
}