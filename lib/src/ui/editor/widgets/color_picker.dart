import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:palplugin/src/extensions/color_extension.dart';
import 'package:palplugin/src/ui/editor/widgets/bordered_text_field.dart';

class ColorPickerDialog extends StatefulWidget {
  final Function(Color) onColorSelected;

  const ColorPickerDialog({
    Key key,
    @required this.onColorSelected,
  }) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _hexColorController = TextEditingController();
  Color _selectedColor = Color(0xFFa1e3f1);
  bool isFormValid = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        key: ValueKey('pal_ColorPickerAlertDialog'),
        title: const Text('Pick a color'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidate: true,
            onChanged: () {
              setState(() {
                isFormValid = _formKey?.currentState?.validate();
              });
            },
            child: Column(
              children: [
                ColorPicker(
                  pickerColor: _selectedColor,
                  onColorChanged: (Color selectedColor) {
                    _selectedColor = selectedColor;
                    _hexColorController.text =
                        '#${selectedColor.toHex().toUpperCase()}';
                  },
                  showLabel: false,
                  pickerAreaHeightPercent: 0.5,
                ),
                BorderedTextField(
                  key: ValueKey('pal_ColorPickerAlertDialog_HexColorTextField'),
                  controller: _hexColorController,
                  autovalidate: true,
                  hintText: '#FF4287F5',
                  validator: (String value) => (!HexColor.isHexColor(value))
                      ? 'Please enter valid color'
                      : null,
                  onValueChanged: (String newValue) {
                    Color newColor = HexColor.fromHex(newValue);

                    if (newColor != null) {
                      setState(() {
                        _selectedColor = newColor;
                      });
                    }
                  },
                )
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            key: ValueKey('pal_ColorPickerAlertDialog_CancelButton'),
            child: Text('Cancel'),
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            key: ValueKey('pal_ColorPickerAlertDialog_ValidateButton'),
            child: Text(
              'Validate',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: isFormValid
                ? () {
                    if (widget.onColorSelected != null) {
                      HapticFeedback.selectionClick();
                      widget.onColorSelected(_selectedColor);
                    }

                    Navigator.of(context).pop();
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
