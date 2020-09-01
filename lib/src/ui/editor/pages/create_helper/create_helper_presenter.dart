import 'package:mvvm_builder/mvvm_builder.dart';
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
  }
}
