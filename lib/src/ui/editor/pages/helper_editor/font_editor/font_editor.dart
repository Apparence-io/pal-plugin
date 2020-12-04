import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_presenter.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_list_tile.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/font_size_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_family_picker/font_family_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker.dart';

typedef OnCancelPicker = void Function();

typedef OnValidatePicker = void Function();

abstract class FontEditorDialogView {
  Future<String> openFontFamilyPicker(
    BuildContext context,
    FontKeys fontKeys,
  );
  Future<MapEntry<String, FontWeight>> openFontWeightPicker(
    BuildContext context,
    FontKeys fontKeys,
  );
  TextStyle defaultTextFieldPreviewColor();
}



class FontEditorDialogPage extends StatelessWidget implements FontEditorDialogView {

  final OnCancelPicker onCancelPicker;

  final OnValidatePicker onValidatePicker;

  final TextStyle actualTextStyle;

  final String fontFamilyKey;

  final Function(TextStyle, FontKeys) onFontModified;

  FontEditorDialogPage({
    Key key,
    @required TextStyle actualTextStyle,
    this.fontFamilyKey,
    this.onCancelPicker,
    this.onFontModified,
    this.onValidatePicker,
  }) : this.actualTextStyle = actualTextStyle.copyWith(),
       super(key: key);

  final _mvvmPageBuilder = MVVMPageBuilder<FontEditorDialogPresenter, FontEditorDialogModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => FontEditorDialogPresenter(
        this,
        actualTextStyle: actualTextStyle,
        fontFamilyKey: fontFamilyKey,
      ),
      builder: (context, presenter, model) {
        return this._buildPage(
          context.buildContext,
          presenter,
          model,
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final FontEditorDialogPresenter presenter,
    final FontEditorDialogModel model,
  ) {
    return AlertDialog(
      key: ValueKey('pal_FontEditorDialog'),
      actions: _buildActions(model),
      content: SingleChildScrollView(
        child: Container(
          width: double.maxFinite,
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Preview',
                  key: ValueKey('pal_FontEditorDialog_Preview'),
                  style: model.modifiedTextStyle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                ),
                FontSizePicker(
                  style: model.modifiedTextStyle,
                  onFontSizeSelected: presenter.changeFontSize,
                ),
                Divider(),
                ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.4,
                  ),
                  child: ListView(
                    key: ValueKey('pal_FontEditorDialog_List'),
                    shrinkWrap: true,
                    children: [
                      FontListTile(
                        key: ValueKey('pal_FontEditorDialog_List_FontFamily'),
                        title: 'Font family',
                        subTitle: model.fontKeys.fontFamilyNameKey,
                        onTap: () async {
                          HapticFeedback.selectionClick();
                          presenter.changeFontFamily(context);
                        },
                      ),
                      FontListTile(
                        key: ValueKey('pal_FontEditorDialog_List_FontWeight'),
                        title: 'Font weight',
                        subTitle: model.fontKeys.fontWeightNameKey,
                        onTap: () async {
                          HapticFeedback.selectionClick();
                          presenter.changeFontWeight(context);
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
    );
  }

  _buildActions(final FontEditorDialogModel model) {
    return [
      FlatButton(
        key: ValueKey('pal_FontEditorDialog_CancelButton'),
        child: Text('Cancel'),
        onPressed: () {
          HapticFeedback.selectionClick();
          this.onCancelPicker();
        },
      ),
      FlatButton(
        key: ValueKey('pal_FontEditorDialog_ValidateButton'),
        child: Text(
          'Validate',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        onPressed: () {
          HapticFeedback.selectionClick();
          if (onFontModified != null) {
            onFontModified(
              model.modifiedTextStyle.merge(TextStyle(color: actualTextStyle.color)),
              model.fontKeys,
            );
          }
          onValidatePicker();
        },
      ),
    ];
  }

  @override
  Future<String> openFontFamilyPicker(
    BuildContext context,
    FontKeys fontKeys,
  ) async {
    return await Navigator.pushNamed(
      context,
      '/editor/new/font-family',
      arguments: FontFamilyPickerArguments(
        fontFamilyName: fontKeys.fontFamilyNameKey,
        fontWeightName: fontKeys.fontWeightNameKey,
      ),
    ) as String;
  }

  @override
  Future<MapEntry<String, FontWeight>> openFontWeightPicker(
    BuildContext context,
    FontKeys fontKeys,
  ) async {
    return await Navigator.pushNamed(
      context,
      '/editor/new/font-weight',
      arguments: FontWeightPickerArguments(
        fontFamilyName: fontKeys.fontFamilyNameKey,
        fontWeightName: fontKeys.fontWeightNameKey,
      ),
    ) as MapEntry<String, FontWeight>;
  }

  @override
  TextStyle defaultTextFieldPreviewColor() => TextStyle(color: Color(0xFF03045E));
}
