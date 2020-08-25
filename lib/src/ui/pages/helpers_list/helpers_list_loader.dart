import 'package:palplugin/src/services/page_server.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal_viewmodel.dart';

class HelpersListModalLoader {
  final PageService _pageService;
  
  HelpersListModalLoader(
    this._pageService,
  );

  Future<void> load() {
    return Future.wait([
      this._pageService.getPages(''),
    ]).then((value) {
      var resViewModel = HelpersListModalModel();
      print(value[0]);

      return resViewModel;
    });
  }
}