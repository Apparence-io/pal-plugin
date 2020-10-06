import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FontSizePickerDialog extends StatefulWidget {
  final double fontSize;
  final Function(double) onFontSizeSelected;

  const FontSizePickerDialog({
    Key key,
    this.fontSize,
    this.onFontSizeSelected,
  }) : super(key: key);

  @override
  _FontSizePickerDialogState createState() => _FontSizePickerDialogState();
}

class _FontSizePickerDialogState extends State<FontSizePickerDialog> {
  double _currentSliderValue;
  bool _isHapticPlayed = false;

  @override
  void initState() {
    super.initState();

    _currentSliderValue = widget.fontSize ?? 20.0;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        key: ValueKey('pal_FontSizePickerDialog'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Preview',
                key: ValueKey('pal_FontSizePickerDialog_PreviewText'),
                style: TextStyle(
                  fontSize: _currentSliderValue,
                ),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Slider(
                key: ValueKey('pal_FontSizePickerDialog_Slider'),
                value: _currentSliderValue,
                min: 10,
                max: 80,
                label: _currentSliderValue.round().toString(),
                onChanged: (double value) {
                  num section = (value % 10).round();
                  if (section == 0 && !_isHapticPlayed) {
                    HapticFeedback.selectionClick();
                    _isHapticPlayed = true;
                  } else {
                    _isHapticPlayed = false;
                  }

                  setState(() {
                    _currentSliderValue = value;
                  });
                },
              ),
              Text(
                _currentSliderValue.round().toString() + 'px',
                key: ValueKey('pal_FontSizePickerDialog_CurrentValue'),
              ),
            ],
          ),
        ),
        actions: <Widget>[
          FlatButton(
            key: ValueKey('pal_FontSizePickerDialog_CancelButton'),
            child: Text('Cancel'),
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            key: ValueKey('pal_FontSizePickerDialog_ValidateButton'),
            child: Text(
              'Validate',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (widget.onFontSizeSelected != null) {
                HapticFeedback.selectionClick();
                widget.onFontSizeSelected(_currentSliderValue);
              }

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
