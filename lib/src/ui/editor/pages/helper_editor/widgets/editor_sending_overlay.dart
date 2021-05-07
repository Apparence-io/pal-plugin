import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

enum SendingStatus {
  SENDING,
  ERROR,
  SENT
}

/// use this to add a standard sending progress overlay function to all helper editors
/// class _EditorSimpleHelperPage with EditorSendingOverlayMixin implements EditorSimpleHelperView
///   _EditorSimpleHelperPage(this.context, this.scaffoldKey) {
///     this.overlayContext = this.context;
///   }
/// ...
/// }
mixin EditorSendingOverlayMixin {
  EditorSendingOverlay? sendingOverlay;
  BuildContext? overlayContext;

  void closeLoadingScreen() => sendingOverlay!.dismiss();

  Future showLoadingScreen(ValueNotifier<SendingStatus> status) async {
    sendingOverlay = EditorSendingOverlay(
      loadingOpacity: 1,
      loadingMessage: "Saving... please wait",
      successMessage: "Helper saved",
      errorMessage: "Error occured, please try again later",
      status: status
    );
    await sendingOverlay!.show(overlayContext!);
  }
}


class EditorSendingOverlay {

  double loadingOpacity;
  String loadingMessage;
  String successMessage;
  String errorMessage;
  ValueNotifier<SendingStatus> status;

  OverlayEntry? _entry;

  EditorSendingOverlay({
    required this.loadingOpacity,
    required this.loadingMessage,
    required this.successMessage,
    required this.errorMessage,
    required this.status
  });

  Future show(BuildContext context) async {
    if(_entry == null) {
      this._entry = OverlayEntry(
        opaque: false,
        maintainState: true,
        builder: (_) => Material(
          type: MaterialType.transparency,
          child: _build()
        )
      );
    }
    Overlay.of(context)!.insert(_entry!);
  }

  dismiss() {
    if(_entry != null) {
      _entry!.remove();
      _entry = null;
    }
  }

  Widget _build() {
    return ValueListenableBuilder<SendingStatus>(
      valueListenable: status,
      builder: (BuildContext context, SendingStatus currentStatus, Widget? child)
        => AnimatedOpacity(
          duration: Duration(milliseconds: 400),
          opacity: loadingOpacity,
          child: Stack(
            children: [
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
                child: Container(
                  color: Colors.black54,
                ),
              ),
              Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _getContent()
                ),
              ),
            ],
          ),
        )
    );
  }

  List<Widget> _getContent() {
    switch(status.value) {
      case SendingStatus.SENDING:
        return _buildLoadingScreen();
      case SendingStatus.ERROR:
        HapticFeedback.lightImpact();
        return _buildCreationStatusScreen(false);
      case SendingStatus.SENT:
        HapticFeedback.mediumImpact();
        return _buildCreationStatusScreen(true);
      default:
        return [];
    }
  }

  List<Widget> _buildLoadingScreen() => [
      CircularProgressIndicator(
        valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
      ),
      SizedBox(height: 25.0),
      Text(this.loadingMessage,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
      ),
    ];

  List<Widget> _buildCreationStatusScreen(bool success) {
    return [
      success
        ? Icon(Icons.check, color: Colors.green, size: 100.0)
        : Icon(Icons.close, color: Colors.red, size: 100.0,
      ),
      SizedBox(height: 25.0),
      Text(
        success ? successMessage : errorMessage,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: Colors.white,
          fontSize: 22.0,
        ),
      ),
    ];
  }
}

