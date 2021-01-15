import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class EditableButton extends StatefulWidget {
  final ButtonFormFieldNotifier buttonFormFieldNotifier;
  final ValueNotifier<FormFieldNotifier> currentEditableItemNotifier;

  const EditableButton({
    Key key,
    @required this.buttonFormFieldNotifier,
    @required this.currentEditableItemNotifier,
  }) : super(key: key);

  @override
  _EditableButtonState createState() => _EditableButtonState();
}

class _EditableButtonState extends State<EditableButton> {

  @override
  void initState() {
    // TODO: Refacto en un seul TextStyle listener
    super.initState();
    widget.buttonFormFieldNotifier.fontSize.addListener(this.refreshView);
    widget.buttonFormFieldNotifier.fontFamily.addListener(this.refreshView);
    widget.buttonFormFieldNotifier.fontColor.addListener(this.refreshView);
    widget.buttonFormFieldNotifier.text.addListener(this.refreshView);
    widget.buttonFormFieldNotifier.fontWeight.addListener(this.refreshView);
    widget.buttonFormFieldNotifier.borderColor.addListener(this.refreshView);
    widget.buttonFormFieldNotifier.backgroundColor
        .addListener(this.refreshView);
        widget.buttonFormFieldNotifier.isSelected
        .addListener(this.refreshView);
  }

  @override
  void dispose() {
    widget.buttonFormFieldNotifier.fontSize.removeListener(this.refreshView);
    widget.buttonFormFieldNotifier.fontFamily.removeListener(this.refreshView);
    widget.buttonFormFieldNotifier.fontColor.removeListener(this.refreshView);
    widget.buttonFormFieldNotifier.text.removeListener(this.refreshView);
    widget.buttonFormFieldNotifier.fontWeight.removeListener(this.refreshView);
    widget.buttonFormFieldNotifier.borderColor.removeListener(this.refreshView);
    widget.buttonFormFieldNotifier.backgroundColor
        .removeListener(this.refreshView);
        widget.buttonFormFieldNotifier.isSelected
        .removeListener(this.refreshView);
    super.dispose();
  }

  void refreshView() {
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: widget.buttonFormFieldNotifier?.fontFamily?.value,
      fontWeight: FontWeightMapper.toFontWeight(
          widget.buttonFormFieldNotifier?.fontWeight?.value),
      fontSize: widget.buttonFormFieldNotifier?.fontSize?.value?.toDouble(),
      color: widget.buttonFormFieldNotifier?.text?.value != null
          ? widget.buttonFormFieldNotifier?.fontColor?.value
          : widget.buttonFormFieldNotifier?.fontColor?.value?.withAlpha(120),
    ).merge(
      _googleCustomFont(widget.buttonFormFieldNotifier?.fontFamily?.value),
    );

    return BouncingWidget(
      onTap: () {
        this.widget.currentEditableItemNotifier?.value?.isSelected?.value = false;
        this.widget.currentEditableItemNotifier.value =
            this.widget.buttonFormFieldNotifier;
        //  CurrentEditableItem(
        //   editableItemType: EditableItemType.button,
        //   itemKey: this.key,
        // );
      },
      child: DottedBorder(
        dashPattern: [6, 3],
        color: widget.buttonFormFieldNotifier.isSelected.value ? Colors.red : Colors.white.withAlpha(80),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IgnorePointer(
            ignoring: true,
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: widget.buttonFormFieldNotifier?.backgroundColor?.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    widget.buttonFormFieldNotifier?.text?.value ?? 'Edit me!',
                    style: textStyle,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle _googleCustomFont(String fontFamily) {
    return (fontFamily != null && fontFamily.length > 0)
        ? GoogleFonts.getFont(fontFamily)
        : null;
  }
}
