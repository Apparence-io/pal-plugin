import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class EditableTextField extends StatelessWidget {
  final EditableTextFormData? data;
  final Function(EditableData?)? onTap;
  final bool isSelected;
  final Color? backgroundColor;

  const EditableTextField({
    Key? key,
    this.onTap,
    required this.data,
    required this.backgroundColor,
    this.isSelected = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: this.data?.fontFamily,
      fontWeight: FontWeightMapper.toFontWeight(this.data?.fontWeight),
      fontSize: this.data?.fontSize?.toDouble(),
      color: this.data?.fontColor,
    ).merge(
      _googleCustomFont(this.data?.fontFamily),
    );

    Color _borderColor = this.backgroundColor!.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;
    return BouncingWidget(
      onTap: () => this.onTap?.call(this.data),
      child: DottedBorder(
        dashPattern: [6, 3],
        color: this.isSelected
            ? _borderColor.withAlpha(200)
            : _borderColor.withAlpha(80),
        strokeWidth: this.isSelected ? 3.0 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            key: UniqueKey(),
            initialValue: this.data?.text,
            enabled: false,
            maxLines: 2,
            minLines: 1,
            textAlign: TextAlign.center,
            decoration: InputDecoration(
              border: InputBorder.none,
              enabledBorder: InputBorder.none,
              hintText: 'Edit me!',
              hintStyle: textStyle.merge(
                TextStyle(
                  color: textStyle.color?.withAlpha(80),
                ),
              ),
            ),
            style: textStyle,
          ),
        ),
      ),
    );
  }

  // TODO : move to extension
  TextStyle? _googleCustomFont(String? fontFamily) {
    return (fontFamily != null && fontFamily.length > 0)
        ? GoogleFonts.getFont(fontFamily)
        : null;
  }
}
