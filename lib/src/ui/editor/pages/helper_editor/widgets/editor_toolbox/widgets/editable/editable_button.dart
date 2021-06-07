import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class EditableButton extends StatelessWidget {
  final EditableButtonFormData? data;
  final Function(EditableData?)? onTap;
  final bool isSelected;
  final Color? backgroundColor;
  final bool outline;
  final double? width;
  
  const EditableButton({
    Key? key,
    required this.data,
    this.onTap,
    this.isSelected = false,
    this.backgroundColor,
    this.outline = false,
    this.width,
  }) : super(key: key);

  TextStyle? googleCustomFont(String? fontFamily) => 
    (fontFamily != null && fontFamily.length > 0)
        ? GoogleFonts.getFont(fontFamily)
        : null;

  TextStyle get textStyle => TextStyle(
      fontFamily: this.data?.fontFamily,
      fontWeight: FontWeightMapper.toFontWeight(this.data?.fontWeight),
      fontSize: this.data?.fontSize?.toDouble(),
      color: this.data?.text != null
          ? this.data?.fontColor
          : this.data?.fontColor?.withAlpha(120),
    ).merge(googleCustomFont(this.data?.fontFamily));
  
  Color get borderColor => this.backgroundColor!.computeLuminance() > 0.5
        ? Colors.black
        : Colors.white;

  @override
  Widget build(BuildContext context) => BouncingWidget(
      onTap: () => this.onTap?.call(this.data),
      child: DottedBorder(
        dashPattern: [6, 3],
        color: this.isSelected
            ? borderColor.withAlpha(200)
            : borderColor.withAlpha(80),
        strokeWidth: this.isSelected ? 3.0 : 1.0,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: IgnorePointer(
            ignoring: true,
            child: SizedBox(
              width: width,
              child: outline 
                ? _buildEditableBordered(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(data?.text ?? 'Edit me!', style: textStyle, textAlign: TextAlign.center),
                  ),
                )
                : _buildEditableBordered(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Text(data?.text ?? 'Edit me!', style: textStyle, textAlign: TextAlign.center),
                  ),
                ),
            ),
          ),
        ),
      ),
    );

  _buildEditableBordered({required Widget child}) {
    final ButtonStyle outlineButtonStyle = OutlinedButton.styleFrom(
      primary: borderColor,
      minimumSize: Size(88, 36),
      padding: EdgeInsets.symmetric(horizontal: 16),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5)),
      ),
      textStyle: textStyle
    ).copyWith(
      side: MaterialStateProperty.resolveWith<BorderSide>(
        (Set<MaterialState> states) => BorderSide(
          color: borderColor, 
          width: 1,
        ),
      ),
    );
    return OutlinedButton(
      onPressed: () {},
      style: outlineButtonStyle,
      child: child,
    );
  }

  
}
