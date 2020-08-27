import 'package:flutter/material.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/router.dart';
import 'package:palplugin/src/services/pal/pal_state_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal.dart';
import 'package:palplugin/src/ui/widgets/bubble_overlay.dart';
import 'package:palplugin/src/ui/widgets/overlayed.dart';


class PalEditModeWrapper extends StatefulWidget {

  // this is the client embedded application that wanna use our Pal
  final MaterialApp userApp;

  final GlobalKey<NavigatorState> hostedAppNavigatorKey;

  PalEditModeWrapper({@required this.userApp, this.hostedAppNavigatorKey});

  @override
  _PalEditModeWrapperState createState() => _PalEditModeWrapperState();
}

class _PalEditModeWrapperState extends State<PalEditModeWrapper> {

  final GlobalKey _repaintBoundaryKey = GlobalKey();

  PalEditModeStateService palEditModeStateService;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    palEditModeStateService = EditorInjector.of(context).palEditModeStateService;
    palEditModeStateService.showEditorBubble.addListener(_onShowBubbleStateChanged);
  }

  @override
  void dispose() {
    super.dispose();
    if(palEditModeStateService != null) {
      palEditModeStateService.showEditorBubble.removeListener(_onShowBubbleStateChanged);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PalTheme(
      theme: PalThemeData.light(),
      child: Overlayed(
        child: Builder(
          builder: (context) =>
            MaterialApp(
              debugShowCheckedModeBanner: false,
              onGenerateRoute: (RouteSettings settings) => route(settings),
              theme: PalTheme.of(context).buildTheme(),
              home: LayoutBuilder(
                builder: (context, constraints) {
                  return Stack(
                    key: ValueKey('palMainStack'),
                    children: [
                      // The app
                      RepaintBoundary(
                        key: _repaintBoundaryKey,
                        child: widget.userApp,
                      ),
                      // Build the floating widget above the app
                      if(palEditModeStateService.showEditorBubble.value)
                        BubbleOverlayButton(
                          key: ValueKey('palBubbleOverlay'),
                          screenSize: Size(
                            constraints.maxWidth,
                            constraints.maxHeight,
                          ),
                          onTapCallback: () => _showHelpersListModal(context),
                        ),
                    ],
                  );
                },
              ),
            ),
          ),
      ),
    );
  }

  _onShowBubbleStateChanged() {
    if(mounted)
      setState(() {});
  }

  _showHelpersListModal(BuildContext context) {
    double radius = 25.0;
    showModalBottomSheet(
      context: context,
      barrierColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: HelpersListModal(
            repaintBoundaryKey: _repaintBoundaryKey,
            hostedAppNavigatorKey: widget.hostedAppNavigatorKey,
          ),
        );
      },
    );
  }
}
