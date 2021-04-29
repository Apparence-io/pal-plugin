import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_presenter.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_viewmodel.dart';

class FontWeightPickerArguments {
  String? fontFamilyName;
  String? fontWeightName;

  FontWeightPickerArguments({
    required this.fontFamilyName,
    required this.fontWeightName,
  });
}

abstract class FontWeightPickerView {}

/// Use this picker with FontEditor dialog only
class FontWeightPickerPage extends StatelessWidget
    implements FontWeightPickerView {
  final FontWeightPickerArguments? arguments;

  FontWeightPickerPage({
    Key? key,
    required this.arguments,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<FontWeightPickerPresenter, FontWeightPickerModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => FontWeightPickerPresenter(
        this,
        arguments,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          key: ValueKey('pal_FontWeightPicker'),
          appBar: AppBar(
            title: Text('Font weight'),
          ),
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final FontWeightPickerPresenter presenter,
    final FontWeightPickerModel model,
  ) {
    return ListView.builder(
      key: ValueKey('pal_FontWeightPicker_ListView'),
      shrinkWrap: true,
      itemCount: model.fontWeights!.length,
      itemBuilder: (context, index) {
        final map = model.fontWeights!.entries.elementAt(index);

        TextStyle originalFontStyle =
            GoogleFonts.getFont(arguments!.fontFamilyName!);
        TextStyle modifiedFontStyle = originalFontStyle.merge(
          TextStyle(
            fontSize: 23.0,
            fontWeight: map.value,
          ),
        );

        return ListTile(
          key: ValueKey('pal_FontWeightPicker_ListView_ListTile$index'),
          title: Text(
            map.key,
            style: modifiedFontStyle,
          ),
          trailing: (map.key == model.selectedFontWeightKey)
              ? Icon(
                  Icons.check,
                  key: ValueKey('pal_FontWeightPicker_ListView_ListTile_Check$index'),
                  color: PalTheme.of(context)!.colors.dark,
                )
              : null,
          onTap: () {
            Navigator.pop(context, map);
          },
        );
      },
    );
  }
}
