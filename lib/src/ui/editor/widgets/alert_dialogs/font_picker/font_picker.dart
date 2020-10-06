import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/widgets/alert_dialogs/font_picker/font_list_tile.dart';

class FontPickerDialog extends StatefulWidget {
  final TextStyle actualTextStyle;
  final Function(String) onFontSelected;

  const FontPickerDialog({
    Key key,
    this.actualTextStyle,
    this.onFontSelected,
  }) : super(key: key);

  @override
  _FontPickerDialogState createState() => _FontPickerDialogState();
}

class _FontPickerDialogState extends State<FontPickerDialog> {
  TextStyle _modifiedTextStyle;

  @override
  void initState() {
    super.initState();

    _modifiedTextStyle = widget.actualTextStyle ?? TextStyle();

    WidgetsBinding.instance.addPostFrameCallback(afterFirstLayout);
  }

  void afterFirstLayout(Duration duration) {
    // Override color to be always visible!
    _modifiedTextStyle = _modifiedTextStyle.merge(
      TextStyle(
        color: PalTheme.of(context).colors.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        key: ValueKey('pal_FontPickerDialog'),
        content: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Preview',
                  key: ValueKey('pal_FontPickerDialog_Preview'),
                  style: _modifiedTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                Divider(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView(
                    key: ValueKey('pal_FontPickerDialog_List'),
                    shrinkWrap: true,
                    children: [
                      FontListTile(
                        key: ValueKey('pal_FontPickerDialog_List_FontFamily'),
                        title: 'Font family',
                        subTitle: 'Roboto',
                        onTap: () {},
                      ),
                      FontListTile(
                        key: ValueKey('pal_FontPickerDialog_List_FontWeight'),
                        title: 'Font weight',
                        subTitle: 'Normal',
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: <Widget>[
          FlatButton(
            key: ValueKey('pal_FontPickerDialog_CancelButton'),
            child: Text('Cancel'),
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop();
            },
          ),
          FlatButton(
            key: ValueKey('pal_FontPickerDialog_ValidateButton'),
            child: Text(
              'Validate',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () {
              if (widget.onFontSelected != null) {
                HapticFeedback.selectionClick();
                widget.onFontSelected('');
              }

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}
