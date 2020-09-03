import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/database/entity/helper/helper_trigger_type.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper.dart';
import 'package:palplugin/src/ui/editor/pages/create_helper/create_helper_viewmodel.dart';

class CreateHelperPresenter
    extends Presenter<CreateHelperModel, CreateHelperView> {
  CreateHelperPresenter(
    CreateHelperView viewInterface,
  ) : super(CreateHelperModel(), viewInterface);

  @override
  Future onInit() async {
    this.viewModel.isFormValid = false;

    this.viewModel.triggerTypes = [];
    HelperTriggerType.values.forEach((HelperTriggerType type) {
      this.viewModel.triggerTypes.add(
        HelperTriggerTypeDisplay(
          key: helperTriggerTypeToString(type),
          description: getHelperTriggerTypeDescription(type),
        ),
      );
    });
    this.viewModel.selectedTriggerType = this.viewModel.triggerTypes?.first?.key;
  }

  selectTriggerHelperType(String newValue) {
    this.viewModel.selectedTriggerType = newValue;
    this.refreshView();
  }
}
