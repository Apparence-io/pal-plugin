import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_family_picker/font_family_picker_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_family_picker/font_family_picker_viewmodel.dart';

abstract class FontFamilyPickerView {}

class FontFamilyPickerPage extends StatelessWidget
    implements FontFamilyPickerView {
  FontFamilyPickerPage({Key key});

  final _mvvmPageBuilder =
      MVVMPageBuilder<FontFamilyPickerPresenter, FontFamilyPickerModel>();
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => FontFamilyPickerPresenter(
        this,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          key: ValueKey('FontFamilyPicker'),
          appBar: AppBar(
            title: Text('Font family'),
          ),
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final FontFamilyPickerPresenter presenter,
    final FontFamilyPickerModel model,
  ) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(13.0),
            child: TextField(
              controller: _searchController,
              onChanged: (String newValue) {
                presenter.filterSearchResults(newValue);
              },
              decoration: InputDecoration(
                labelText: 'Search',
                hintText: 'Search',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(
                    Radius.circular(25.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: !model.isLoading
                ? ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.fonts.length,
                    itemBuilder: (context, index) {
                      final String key = model.fonts[index];

                      TextStyle originalFontStyle =
                          GoogleFonts.asMap()[key].call();

                      TextStyle modifiedFontStyle = originalFontStyle.merge(
                        TextStyle(fontSize: 23.0),
                      );

                      return ListTile(
                        title: Text(
                          key,
                          style: modifiedFontStyle,
                        ),
                        onTap: () {
                          Navigator.pop(
                            context,
                            key,
                          );
                        },
                      );
                    },
                  )
                : Center(
                    child: CircularProgressIndicator(),
                  ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 20.0, top: 20.0),
            child: Text(
              '${model.fonts.length.toString()} ${(model.fonts.length <= 1 ? 'result' : 'results')}',
            ),
          ),
        ],
      ),
    );
  }
}
