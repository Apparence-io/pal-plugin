import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_loader.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_toolbox/widgets/pickers/font_editor/pickers/font_weight_picker/font_weight_picker_viewmodel.dart';

class FontWeightPickerPresenter
    extends Presenter<FontWeightPickerModel, FontWeightPickerView> {

  final FontWeightPickerArguments arguments;

  FontWeightPickerPresenter(
    FontWeightPickerView viewInterface,
    this.arguments,
  ) : super(FontWeightPickerModel(), viewInterface);

  @override
  void onInit() {
    this.viewModel.fontWeights = FontWeightMapper.map;
    this.viewModel.selectedFontWeightKey = arguments.fontWeightName;
    // print(this.viewModel.selectedFontWeightKey);
  }
}
