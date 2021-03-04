import 'package:flutter/material.dart';

enum OverlayKeys {
  EDITOR_OVERLAY_KEY,
  PAGE_OVERLAY_KEY,
}

/// This helps manage [OverlayEntry] into the stack
/// You can call Overlayed.removeOverlay(context, key) just
/// as you do with navigator
class Overlayed extends InheritedWidget {
  final Map<OverlayKeys, EditorOverlayEntry> entries = new Map();

  Overlayed({
    Key key,
    @required Widget child,
  })  : assert(child != null),
        super(key: key, child: child);

  static Overlayed of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<Overlayed>();

  static void removeOverlay(BuildContext context, OverlayKeys key) {
    var instance = context.dependOnInheritedWidgetOfExactType<Overlayed>();
    instance?.entries[key]?.popFunction?.call();
    instance?.entries[key]?.remove();
    instance?.entries?.remove(key);
  }

  @override
  bool updateShouldNotify(Overlayed old) => false;
}

class EditorOverlayEntry extends OverlayEntry {
  final Function popFunction;

  EditorOverlayEntry(this.popFunction, {bool maintainState = false, bool opaque = false,
      Widget Function(BuildContext) builder})
      : super(builder: builder, maintainState: maintainState, opaque: opaque);
}
