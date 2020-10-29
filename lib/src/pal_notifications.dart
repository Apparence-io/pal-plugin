import 'package:flutter/widgets.dart';

class ShowBubbleNotification extends PalGlobalNotification {
  final bool isVisible;
  ShowBubbleNotification(this.isVisible);
}

// Global notifications
class PalGlobalNotification extends Notification {}

class ShowHelpersListNotification extends PalGlobalNotification {}

// class ShowBubbleNotification extends PalGlobalNotification {}
// End
