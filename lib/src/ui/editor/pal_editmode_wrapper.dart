import 'package:flutter/material.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/pal_notifications.dart';
import 'package:pal/src/router.dart';
import 'package:pal/src/services/pal/pal_state_service.dart';
import 'package:pal/src/theme.dart';
import 'package:pal/src/ui/editor/pages/page_groups/page_group_list.dart';
import 'package:pal/src/ui/editor/widgets/bubble_overlay.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

class PalEditModeWrapper extends StatefulWidget {
  // this is the client embedded application that wanna use our Pal
  final Widget? userApp;

  final GlobalKey<NavigatorState>? hostedAppNavigatorKey;

  PalEditModeWrapper({required this.userApp, this.hostedAppNavigatorKey});

  @override
  _PalEditModeWrapperState createState() => _PalEditModeWrapperState();
}

class _PalEditModeWrapperState extends State<PalEditModeWrapper> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  PalEditModeStateService? palEditModeStateService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    palEditModeStateService =
        EditorInjector.of(context)!.palEditModeStateService;
    palEditModeStateService!.showEditorBubble
        .addListener(_onShowBubbleStateChanged);
  }

  @override
  void dispose() {
    super.dispose();
    if (palEditModeStateService != null) {
      palEditModeStateService!.showEditorBubble
          .removeListener(_onShowBubbleStateChanged);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PalTheme(
      theme: PalThemeData.light(),
      child: Overlayed(
        child: Builder(
          builder: (context) => MaterialApp(
            navigatorKey: palNavigatorGlobalKey,
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (RouteSettings settings) => route(settings),
            theme: PalTheme.of(context)!.buildTheme(),
            home: NotificationListener<PalGlobalNotification>(
              onNotification: (notification) {
                if (notification is ShowHelpersListNotification) {
                  _showGroupsList(EditorInjector.of(context)!.hostedAppNavigatorKey!.currentContext!);
                } else if (notification is ShowBubbleNotification) {
                  palEditModeStateService!.showEditorBubble.value =
                      notification.isVisible;
                }
                return true;
              },
              child: LayoutBuilder(
                builder: (_context, constraints) => Stack(
                  key: ValueKey('pal_MainStack'),
                  children: [
                    // The app
                    RepaintBoundary(
                      key: _repaintBoundaryKey,
                      child: widget.userApp,
                    ),
                    // Build the floating widget above the app
                    BubbleOverlayButton(
                      key: ValueKey('palBubbleOverlay'),
                      visibility: palEditModeStateService!.showEditorBubble,
                      screenSize: Size(
                        constraints.maxWidth,
                        constraints.maxHeight,
                      ),
                      onTapCallback: () {
                        palEditModeStateService!.showEditorBubble.value = false;
                        return _showGroupsList(_context);
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  _onShowBubbleStateChanged() {
    if (mounted) setState(() {});
  }

  _showGroupsList(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => PageGroupsListPage(),
    );
  }
}
