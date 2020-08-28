import 'package:flutter/material.dart';
import 'package:palplugin/src/ui/client/helpers/user_fullscreen_helper_widget.dart';

/// this class is the main intelligence wether or not we are gonna show an helper to user.
/// On each page visited we check if we have to show a new helper to user
/// There is a variety of Helper types.
class HelperOrchestrator extends InheritedWidget {

  final _HelperManager helper = _HelperManager();

  HelperOrchestrator({
    Key key,
    @required Widget child,
  })
    : assert(child != null),
      super(key: key, child: child);

  static HelperOrchestrator of(BuildContext context) => context.dependOnInheritedWidgetOfExactType();

  @override
  bool updateShouldNotify(HelperOrchestrator old) {
    return false;
  }

  // TODO make one for each strategy
  // this method should be private
  showHelper(BuildContext context) {
    OverlayEntry entry = OverlayEntry(
      opaque: false,
      builder: (context) => UserFullscreenHelperWidget(
        helperText: "Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum",
        bgColor: Color(0xFF2C77B6),
        textColor: Color(0xFFFAFEFF),
        textSize: 18,
      )
    );
    var overlay = Overlay.of(context);
    overlay.insert(entry);
  }
}

class _HelperManager {

  OverlayEntry current;

  createOverlay(BuildContext context) {
    current = OverlayEntry(
      opaque: false,
      builder: (context) => UserFullscreenHelperWidget(
        helperText: "Lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum lorem ipsum",
        bgColor: Color(0xFF2C77B6),
        textColor: Color(0xFFFAFEFF),
        textSize: 18,
      )
    );
  }

}