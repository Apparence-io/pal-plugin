import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/services/editor/helper/helper_editor_service.dart';

import 'helper_details_model.dart';
import 'helper_details_view.dart';

class HelperDetailsPresenter extends Presenter<HelperDetailsModel, HelperDetailsInterface> {

  final EditorHelperService editorHelperService;

  final HelperDetailsComponentArguments arguments;

  HelperDetailsPresenter(
    HelperDetailsModel viewModel,
    viewInterface,
    this.editorHelperService,
    this.arguments,
  ) : super(viewModel, viewInterface) {
    this.viewModel.isDeleting = false;
    this.viewModel.isDeleteSuccess = false;
    this.viewModel.helperName = arguments?.helper?.name;
    this.viewModel.helperTriggerType = arguments?.helper?.triggerType;
  }

  Future deleteHelper() async {
    this.viewModel.isDeleting = true;
    this.viewModel.isDeleteSuccess = false;
    this.refreshView();
    try {
      await this.editorHelperService
          .deleteHelper(arguments?.helper?.id);
      this.viewModel.isDeleteSuccess = true;
      this.viewInterface.showMessage('Helper successfully deleted 😎', true);
      await Future.delayed(Duration(milliseconds: 2500));
      this.viewInterface.popBackToList();
    } catch (err) {
      this.viewModel.isDeleteSuccess = false;
      this.viewInterface.showMessage('Error when removing helper. Please try again.', false);
    }
    this.viewModel.isDeleting = false;
    this.refreshView();
  }

  void callEditHelper() {
    if(viewModel.isDeleting) {
      return;
    }
    this.viewInterface.launchHelperEditor(arguments.pageRouteName);
  }
}
