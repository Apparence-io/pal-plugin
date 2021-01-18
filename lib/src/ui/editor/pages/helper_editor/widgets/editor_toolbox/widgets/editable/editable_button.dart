import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/helper_editor_data.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/shared/widgets/bouncing_widget.dart';

class EditableButton extends StatelessWidget {
  final EditableButtonFormData data;
  final Function(String) onTap;

  const EditableButton({Key key, @required this.data, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final textStyle = TextStyle(
      fontFamily: this.data?.fontFamily,
      fontWeight: FontWeightMapper.toFontWeight(this.data?.fontWeight),
      fontSize: this.data?.fontSize?.toDouble(),
      color: this.data?.text != null
          ? this.data?.fontColor?.value
          : this.data?.fontColor?.withAlpha(120),
    ).merge(
      _googleCustomFont(this.data?.fontFamily),
    );

    return BouncingWidget(
      onTap: () => this.onTap?.call(this.data.key),
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
                onPressed: () {},
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                color: this.data?.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 13.0),
                  child: Text(
                    this.data?.text ?? 'Edit me!',
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
