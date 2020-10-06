import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker.dart';
import 'package:palplugin/src/ui/editor/pages/helper_editor/font_editor/pickers/font_weight_picker/font_weight_picker_viewmodel.dart';

class FontWeightPickerPresenter extends Presenter<FontWeightPickerModel, FontWeightPickerView>{
  FontWeightPickerPresenter(
    FontWeightPickerView viewInterface,
  ) : super(FontWeightPickerModel(), viewInterface);

}