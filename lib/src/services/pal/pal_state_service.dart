import 'package:flutter/cupertino.dart';

abstract class PalEditModeStateService {

  factory PalEditModeStateService.build() => _PalEditModeStateService();

  /// returns whether or not we show the [BubbleOverlayButton] above the user app
  ValueNotifier<bool> get showEditorBubble => throw "not implemented yet";
}

class _PalEditModeStateService implements PalEditModeStateService {

  ValueNotifier<bool> _showEditorBubbleNotifier = ValueNotifier(true);

  @override
  ValueNotifier<bool> get showEditorBubble => _showEditorBubbleNotifier;

}