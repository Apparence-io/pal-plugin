import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalPresenter
    extends Presenter<HelpersListModalModel, HelpersListModalView> {
  HelpersListModalPresenter(
    HelpersListModalView viewInterface,
  ) : super(HelpersListModalModel(), viewInterface);
}
