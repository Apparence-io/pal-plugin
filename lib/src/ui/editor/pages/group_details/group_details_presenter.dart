import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal/src/database/entity/helper/helper_trigger_type.dart';

import 'group_details.dart';
import 'group_details_model.dart';

class GroupDetailsPresenter
    extends Presenter<GroupDetailsModel, GroupDetailsView> {
  GroupDetailsPresenter(
      GroupDetailsModel viewModel, GroupDetailsView viewInterface)
      : super(viewModel, viewInterface);

  void onTriggerChange(HelperTriggerType val) {
    this.viewModel.triggerType = val;
    this.refreshView();
  }
}
