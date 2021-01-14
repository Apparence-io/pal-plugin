import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class EditableTextField extends StatelessWidget {
  final TextFormFieldNotifier textNotifier;
  final ValueNotifier<CurrentEditableItem> currentEditableItemNotifier;

  const EditableTextField({
    Key key,
    @required this.textNotifier,
    @required this.currentEditableItemNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: textNotifier?.fontFamily?.value,
      fontWeight:
          FontWeightMapper.toFontWeight(textNotifier?.fontWeight?.value),
      fontSize: textNotifier?.fontSize?.value?.toDouble(),
      color: textNotifier?.fontColor?.value,
    ).merge(
      _googleCustomFont(textNotifier?.fontFamily?.value),
    );

    return BouncingWidget(
      onTap: () {
        this.currentEditableItemNotifier.value = CurrentEditableItem.textfield;
      },
      child: DottedBorder(
        dashPattern: [6, 3],
        color: Colors.white.withAlpha(80),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: UniqueKey(),
            initialValue: textNotifier?.text?.value,
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
