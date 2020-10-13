import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

class FontSizePicker extends StatefulWidget {
  final TextStyle style;
  final Function(double) onFontSizeSelected;

  const FontSizePicker({
    Key key,
    this.style,
    this.onFontSizeSelected,
  }) : super(key: key);

  @override
  _FontSizePickerState createState() => _FontSizePickerState();
}

class _FontSizePickerState extends State<FontSizePicker> {
  double _currentSliderValue;
  bool _isHapticPlayed = false;

  @override
  void initState() {
    super.initState();

    _currentSliderValue = widget.style.fontSize ?? 20.0;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Slider(
          key: ValueKey('pal_FontSizePicker_Slider'),
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

            widget.onFontSizeSelected(value);
          },
        ),
        Text(
          '${_currentSliderValue.round().toString()}pt',
          key: ValueKey('pal_FontSizePicker_CurrentValue'),
        ),
      ],
    );
  }
}
