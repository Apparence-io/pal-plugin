import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/database/entity/helper/helper_entity.dart';
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

  Future<HelpersListModalModel> load() async {
    var resViewModel = HelpersListModalModel();

    String pageId = await getPageId();
    if (pageId != null && pageId.length > 0) {
      Pageable<HelperEntity> helpersPage = await this._helperService.getPageHelpers(pageId);
      resViewModel.helpers = helpersPage?.entities;
    }

    return resViewModel;
  }

  Future<String> getPageId() {
    // Getting child current route
    String routeName = PalController.instance?.routeName?.value;
    if (routeName == null || routeName.length <= 0) {
      return Future.value();
    }

    return this._pageService.getPage(routeName).then(
      (resPages) {
        String routeId;
        if (resPages != null && resPages.totalElements > 0) {
          routeId = resPages.entities[0].id;
        }
        return routeId;
      },
    );
  }
}
