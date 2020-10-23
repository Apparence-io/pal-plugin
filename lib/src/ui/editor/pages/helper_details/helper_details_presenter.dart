import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/services/editor/helper/helper_editor_service.dart';

import '../../../../database/entity/helper/helper_entity.dart';
import 'helper_details_model.dart';
import 'helper_details_view.dart';

class HelperDetailsPresenter extends Presenter<HelperDetailsModel,HelperDetailsInterface>{
  final EditorHelperService service;
  final HelperEntity helper;
  
  HelperDetailsPresenter(HelperDetailsModel viewModel, viewInterface, this.service, this.helper) : super(viewModel, viewInterface){
    viewModel.helperName = helper.name;
    viewModel.helperMinVer = helper.versionMin;
    viewModel.helperMaxVer = helper.versionMax;
    viewModel.helperTriggerType = helper.triggerType;
  }


  void deleteHelper() {
    this.service.deleteHelper("testId");
  }
}