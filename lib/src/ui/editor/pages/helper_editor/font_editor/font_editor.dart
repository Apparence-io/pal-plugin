import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_editor_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_list_tile.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/font_size_picker.dart';

abstract class FontEditorDialogView {
  Future<String> openFontFamilyPicker(BuildContext context);
  Future<String> openFontWeightPicker(BuildContext context);
}

class FontEditorDialogPage extends StatelessWidget
    implements FontEditorDialogView {
  final TextStyle actualTextStyle;
  final Function(String) onFontSelected;
  FontEditorDialogPage({
    Key key,
    this.actualTextStyle,
    this.onFontSelected,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<FontEditorDialogPresenter, FontEditorDialogModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) =>
          FontEditorDialogPresenter(this, actualTextStyle: actualTextStyle),
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
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: AlertDialog(
        key: ValueKey('pal_FontEditorDialog'),
        content: SingleChildScrollView(
          child: Container(
            width: double.maxFinite,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // TODO: Move size changer
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
                  onFontSizeSelected: (double value) {
                    presenter.changeFontSize(value);
                  },
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
                        subTitle: model.fontFamilyName,
                        onTap: () async {
                          HapticFeedback.selectionClick();
                          presenter.changeFontFamily(context);
                        },
                      ),
                      FontListTile(
                        key: ValueKey('pal_FontEditorDialog_List_FontWeight'),
                        title: 'Font weight',
                        subTitle: 'Normal',
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
        actions: <Widget>[
          FlatButton(
            key: ValueKey('pal_FontEditorDialog_CancelButton'),
            child: Text('Cancel'),
            onPressed: () {
              HapticFeedback.selectionClick();
              Navigator.of(context).pop();
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
              //TODO:

              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  @override
  Future<String> openFontFamilyPicker(BuildContext context) async {
    return await Navigator.pushNamed(context, '/editor/new/font-family')
        as String;
  }

  @override
  Future<String> openFontWeightPicker(BuildContext context) async {
    return await Navigator.pushNamed(context, '/editor/new/font-weight')
        as String;
  }
}
