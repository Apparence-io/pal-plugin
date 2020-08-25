import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/database/adapter/page_entity_adapter%20copy.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
import 'package:palplugin/src/database/entity/page_entity.dart';
import 'package:palplugin/src/database/entity/pageable.dart';
import 'package:palplugin/src/services/helper_service.dart';
import 'package:palplugin/src/services/page_server.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalLoader {
  final PageService _pageService;
  final HelperService _helperService;

  HelpersListModalLoader(
    this._pageService,
    this._helperService,
  );

  Future<void> load() {
    // Getting child current route
    String routeName = PalController.instance?.routeName?.value;
    if (routeName == null || routeName.length <= 0) {
      return Future.value();
    }

    return this
        ._pageService
        .getPage(routeName)
        .then((Pageable<PageEntity> resPages) {
      if (resPages != null && resPages.totalElements > 0) {
        return this._helperService.getPageHelpers(resPages.entities[0].id);
      } else {
        return Future.value(null);
      }
    }).then((Pageable<HelperEntity> resHelpers) {
      var resViewModel = HelpersListModalModel();
      if (resHelpers != null) {
        resViewModel.helpers = resHelpers.entities;
      }
      return resViewModel;
    });
  }
}
