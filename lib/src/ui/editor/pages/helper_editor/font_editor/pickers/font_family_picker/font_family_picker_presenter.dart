import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_family_picker/font_family_picker.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_family_picker/font_family_picker_loader.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_family_picker/font_family_picker_viewmodel.dart';

class FontFamilyPickerPresenter
    extends Presenter<FontFamilyPickerModel, FontFamilyPickerView> {
  final FontFamilyPickerLoader loader;
  final FontFamilyPickerArguments arguments;

  FontFamilyPickerPresenter(
    FontFamilyPickerView viewInterface,
    this.loader,
    this.arguments,
  ) : super(FontFamilyPickerModel(), viewInterface);

  @override
  void onInit() {
    this.viewModel.originalFonts = [];
    this.viewModel.fonts = [];
    this.viewModel.isLoading = false;
    this.viewModel.selectedFontFamilyKey = arguments.fontFamilyName;

    this.setup();
  }

  setup() async {
    this.viewModel.isLoading = true;
    this.refreshView();

    FontFamilyPickerModel loadedViewModel = await this.loader.load();
    this.viewModel.fonts = loadedViewModel.fonts;
    this.viewModel.originalFonts = loadedViewModel.originalFonts;

    this.viewModel.isLoading = false;
    this.refreshView();
  }

  void filterSearchResults(String query) {
    if (query.isNotEmpty) {
      List<String> dummyListData = [];
      this.viewModel.originalFonts.forEach((fontKey) {
        final lowerQuery = query.toLowerCase();
        final lowerFontName = fontKey.toLowerCase();

        if (lowerFontName.contains(lowerQuery)) {
          dummyListData.add(fontKey);
        }
      });
      this.viewModel.fonts.clear();
      this.viewModel.fonts.addAll(dummyListData);
    } else {
      this.viewModel.fonts.clear();
      this.viewModel.fonts.addAll(this.viewModel.originalFonts);
    }

    this.refreshView();
  }
}
