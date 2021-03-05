import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:pal/src/extensions/color_extension.dart';
import 'package:pal/src/ui/editor/widgets/bordered_text_field.dart';

class ColorPickerDialog extends StatefulWidget {
  final Color placeholderColor;

  const ColorPickerDialog({
    Key key,
    this.placeholderColor,
  }) : super(key: key);

  @override
  _ColorPickerDialogState createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  final GlobalKey<FormState> _formKey = new GlobalKey<FormState>();
  final _hexColorController = TextEditingController();
  Color _selectedColor;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();

    _selectedColor = widget.placeholderColor ?? Color(0xFFa1e3f1);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        key: ValueKey('pal_ColorPickerAlertDialog'),
        content: SingleChildScrollView(
          child: Form(
            key: _formKey,
            autovalidateMode: AutovalidateMode.onUserInteraction,
            onChanged: () {
              setState(() {
                _isFormValid = _formKey?.currentState?.validate();
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
                    Color newColor;
                    try {
                      newColor = HexColor.fromHex(newValue);
                    } catch (e) {
                      
                    }

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
              // widget.onCancel();
              Navigator.pop(context);
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
            onPressed: _isFormValid
                ? () {
                    HapticFeedback.selectionClick();
                    Navigator.pop(context, _selectedColor);
                  }
                : null,
          ),
        ],
      ),
    );
  }
}
