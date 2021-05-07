import 'package:pal/src/pal_navigator_observer.dart';

class PalEvents {

  static PalEvents? _instance;

  PalEvents._();

  factory PalEvents.instance() {
    if(_instance == null) {
      _instance = PalEvents._();
    }
    return _instance!;
  }

  void pushPage(String routeName, {Map<String, String>? arguments})
    => PalNavigatorObserver.instance().changePage(routeName, arguments: arguments);


}