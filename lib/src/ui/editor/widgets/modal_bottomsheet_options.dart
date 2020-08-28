import 'package:flutter/material.dart';
import 'package:palplugin/src/database/entity/helper/helper_type.dart';
import 'package:palplugin/src/theme.dart';

class SheetOption {
  HelperType type;
  String text;
  IconData icon;

  SheetOption({
    @required this.type,
    @required this.text,
    this.icon,
  });
}

typedef ModalBottomSheetOptionsBuilder = ModalBottomSheetOptions Function(
    BuildContext context);

/// use this method as showModalBottomSheet to a designed version of bottomSheet constructing a
/// [ModalBottomSheetOptions]
showModalBottomSheetOptions(
    BuildContext context, ModalBottomSheetOptionsBuilder builder) {
  showModalBottomSheet(
    context: context,
    useRootNavigator: true,
    isDismissible: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(25),
        topRight: Radius.circular(25),
      ),
    ),
    backgroundColor: PalTheme.of(context).colors.light,
    builder: builder,
  );
}

typedef OnValidate = void Function(SheetOption validatedOption);

typedef OnSelectOption = void Function(SheetOption option);

/// A designed content usable as bottom sheet
/// list of selectable options
/// cancel / validate will fire an event
class ModalBottomSheetOptions extends StatefulWidget {
  final List<SheetOption> options;

  final OnValidate onValidate;

  final OnSelectOption onSelectOption;

  ModalBottomSheetOptions(
      {@required this.options, @required this.onValidate, this.onSelectOption});

  @override
  _ModalBottomSheetOptionsState createState() =>
      _ModalBottomSheetOptionsState();
}

class _ModalBottomSheetOptionsState extends State<ModalBottomSheetOptions> {
  SheetOption _selected;

  @override
  Widget build(BuildContext context) {
    var color = PalTheme.of(context).colors.dark;
    var bgColor = PalTheme.of(context).colors.color4;
    return Stack(
      children: [
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          top: 24,
          child: ListView.builder(
            itemBuilder: (context, index) => Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              color: _selected == widget.options[index]
                  ? PalTheme.of(context).highlightColor
                  : Colors.transparent,
              child: ListTile(
                onTap: () {
                  setState(() {
                    _selected = widget.options[index];
                    if (widget.onSelectOption != null) {
                      widget.onSelectOption(_selected);
                    }
                  });
                },
                key: ValueKey("option$index"),
                leading: Icon(widget.options[index].icon, color: color),
                title: Text(widget.options[index].text),
              ),
            ),
            itemCount: widget.options.length,
          ),
        ),
        Positioned(
          bottom: 16,
          left: 16,
          right: 16,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FlatButton(
                  key: ValueKey('cancel'),
                  color: Colors.transparent,
                  splashColor: Colors.black26,
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancel',
                    style: TextStyle(
                      color: PalTheme.of(context).colors.dark,
                    ),
                  ),
                ),
                IgnorePointer(
                  ignoring: _selected == null,
                  child: Opacity(
                    opacity: _selected == null ? .5 : 1,
                    child: FlatButton(
                      key: ValueKey('validate'),
                      color: Colors.transparent,
                      splashColor: Colors.black26,
                      onPressed: () {
                        if (widget.onValidate != null) {
                          widget.onValidate(_selected);
                        }
                      },
                      child: Text(
                        'Validate',
                        style: TextStyle(
                          color: PalTheme.of(context).colors.dark,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
