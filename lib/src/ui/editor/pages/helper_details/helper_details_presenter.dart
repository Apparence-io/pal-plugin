import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/services/client/helper_client_service.dart';

import 'helper_details_model.dart';
import 'helper_details_view.dart';

class HelperDetailsPresenter extends Presenter<HelperDetailsModel,HelperDetailsInterface>{
  final HelperClientService service;
  
  HelperDetailsPresenter(MVVMModel viewModel, viewInterface, this.service) : super(viewModel, viewInterface);


  void deleteHelper() {
    this.service.deleteHelper();
  }
}