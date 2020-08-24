import 'package:palplugin/src/services/editor/helper/helper_service.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalLoader {
  final HelperService _helperService;
  
  HelpersListModalLoader(
    this._helperService,
  );

  Future<void> load() {
    return Future.wait([
      this._helperService.getPageHelpers('')
    ]).then((value) {
      var resViewModel = HelpersListModalModel();

      return resViewModel;
    });
  }
}