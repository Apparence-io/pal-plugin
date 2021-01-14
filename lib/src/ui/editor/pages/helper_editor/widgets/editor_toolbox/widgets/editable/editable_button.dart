import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_notifiers.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/editor_toolbox_viewmodel.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class EditableButton extends StatelessWidget {
  final ButtonFormFieldNotifier buttonFormFieldNotifier;
  final ValueNotifier<CurrentEditableItem> currentEditableItemNotifier;

  const EditableButton({
    Key key,
    @required this.buttonFormFieldNotifier,
    @required this.currentEditableItemNotifier,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: buttonFormFieldNotifier?.fontFamily?.value,
      fontWeight:
          FontWeightMapper.toFontWeight(buttonFormFieldNotifier?.fontWeight?.value),
      fontSize: buttonFormFieldNotifier?.fontSize?.value?.toDouble(),
      color: buttonFormFieldNotifier?.text?.value != null ? buttonFormFieldNotifier?.fontColor?.value : buttonFormFieldNotifier?.fontColor?.value?.withAlpha(120),
    ).merge(
      _googleCustomFont(buttonFormFieldNotifier?.fontFamily?.value),
    );

    return BouncingWidget(
      onTap: () {
        this.currentEditableItemNotifier.value = CurrentEditableItem.button;
      },
      child: DottedBorder(
        dashPattern: [6, 3],
        color: Colors.white.withAlpha(80),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IgnorePointer(
            ignoring: true,
            child: SizedBox(
              width: double.infinity,
              child: RaisedButton(
                onPressed: () { },
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                color: buttonFormFieldNotifier?.backgroundColor?.value,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    buttonFormFieldNotifier?.text?.value ?? 'Edit me!',
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
