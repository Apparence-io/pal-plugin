import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/services/page_server.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalLoader {
  final PageService _pageService;
  
  HelpersListModalLoader(
    this._pageService,
  );

  Future<void> load() {
    // Getting child current route
    String routeName = PalController.instance?.routeName?.value;
    if (routeName == null || routeName.length <= 0) {
      return Future.value();
    }

    return Future.wait([
      this._pageService.getPages(routeName),
    ]).then((value) {
      var resViewModel = HelpersListModalModel();
      print(value[0]);

      return resViewModel;
    });
  }
}