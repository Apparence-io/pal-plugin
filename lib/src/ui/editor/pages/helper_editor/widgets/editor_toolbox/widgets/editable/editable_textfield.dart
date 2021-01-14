import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class EditableTextField extends StatefulWidget {
  final TextFormFieldNotifier textNotifier;
  final ValueNotifier<FormFieldNotifier> currentEditableItemNotifier;

  const EditableTextField({
    Key key,
    @required this.textNotifier,
    @required this.currentEditableItemNotifier,
  }) : super(key: key);

  @override
  _EditableTextFieldState createState() => _EditableTextFieldState();
}

class _EditableTextFieldState extends State<EditableTextField> {
  @override
  void initState() {
    // TODO: Refacto en un seul TextStyle listener
    super.initState();
    widget.textNotifier.fontSize.addListener(() {
      this.setState(() {});
    });
    widget.textNotifier.fontFamily.addListener(() {
      this.setState(() {});
    });
    widget.textNotifier.fontWeight.addListener(() {
      this.setState(() {});
    });
    widget.textNotifier.fontColor.addListener(() {
      this.setState(() {});
    });
    widget.textNotifier.text.addListener(() {
      this.setState(() {});
    });
  }

  @override
  void dispose() { 
    widget.textNotifier.fontSize.dispose();
    widget.textNotifier.fontFamily.dispose();
    widget.textNotifier.fontWeight.dispose();
    widget.textNotifier.fontColor.dispose();
    widget.textNotifier.text.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: widget.textNotifier?.fontFamily?.value,
      fontWeight:
          FontWeightMapper.toFontWeight(widget.textNotifier?.fontWeight?.value),
      fontSize: widget.textNotifier?.fontSize?.value?.toDouble(),
      color: widget.textNotifier?.fontColor?.value,
    ).merge(
      _googleCustomFont(widget.textNotifier?.fontFamily?.value),
    );

    return BouncingWidget(
      onTap: () {
        this.widget.currentEditableItemNotifier.value =
            this.widget.textNotifier;
      },
      child: DottedBorder(
        dashPattern: [6, 3],
        color: Colors.white.withAlpha(80),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: UniqueKey(),
            initialValue: widget.textNotifier?.text?.value,
            enabled: false,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: 'Edit me!',
              hintStyle: textStyle?.merge(
                TextStyle(
                  color: textStyle?.color?.withAlpha(80),
                ),
              ),
            ),
            style: textStyle,
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
