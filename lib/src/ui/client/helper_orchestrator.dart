import 'package:flutter/material.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/pal_navigator_observer.dart';
import 'package:palplugin/src/services/client/helper_client_service.dart';
import 'package:palplugin/src/services/client/page_client_service.dart';
import 'package:palplugin/src/ui/helpers/fullscreen/fullscreen_helper_widget.dart';

/// this class is the main intelligence wether or not we are gonna show an helper to user.
/// On each page visited we check if we have to show a new helper to user
/// There is a variety of Helper types.
/// it should be placed above MaterialApp
class HelperOrchestrator extends InheritedWidget {

  final HelperInstance helper = HelperInstance();

  final PalRouteObserver routeObserver;

  final HelperClientService helperClientService;

  HelperOrchestrator({
    Key key,
    @required MaterialApp child,
    @required this.routeObserver,
    @required this.helperClientService,
  }): assert(child != null),
    super(key: key, child: child) {
    _init();
  }

  static HelperOrchestrator of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(HelperOrchestrator old) {
    return false;
  }

  _init() {
    this.routeObserver.stream.listen((RouteSettings newRoute) async {
      var helpersToShow = await this.helperClientService.getPageHelpers(newRoute.name);
    });
  }

  // this method should be private
  // TODO make one for each strategy
  _showHelper(BuildContext context) {
    OverlayEntry entry = OverlayEntry(
      opaque: false,
      builder: (context) => FullscreenHelperWidget(
        helperText: "Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum",
        bgColor: Color(0xFF2C77B6),
        textColor: Color(0xFFFAFEFF),
        textSize: 18,
      )
    );
    var overlay = Overlay.of(context);
    overlay.insert(entry);
    helper.overlay = entry;
  }

  bool popHelper() => helper.pop();
}

class HelperInstance {

  OverlayEntry overlay;

  bool pop() {
    if(overlay != null) {
      overlay.remove();
      overlay = null;
      return true;
    }
    return false;
  }

}