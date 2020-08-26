library palplugin;

import 'package:flutter/material.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_context.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/injectors/user_app/user_app_context.dart';
import 'package:palplugin/src/injectors/user_app/user_app_injector.dart';
import 'package:palplugin/src/pal_controller.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';
import 'package:palplugin/src/services/pal/pal_state_service.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/client/helper_orchestrator.dart';
import 'package:palplugin/src/ui/helpers/fullscreen/fullscreen_helper_widget.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal.dart';
import 'package:palplugin/src/ui/widgets/bubble_overlay.dart';
import 'package:palplugin/src/router.dart';
import 'package:palplugin/src/ui/widgets/overlayed.dart';

import 'injectors/editor_app/editor_app_injector.dart';

class Pal extends StatefulWidget {
  /// application child to display Pal over it.
  final MaterialApp child;

  // reference to the Navigator state of the child app
  final GlobalKey<NavigatorState> navigatorKey;

  /// disable or enable the editor mode.
  final bool editorModeEnabled;

  /// text direction of your application.
  final TextDirection textDirection;

  /// set the application token to interact with the server.
  final String appToken;

  Pal({
    Key key,
    @required this.child,
    @required this.navigatorKey,
    @required this.appToken,
    this.editorModeEnabled = true,
    this.textDirection = TextDirection.ltr,
  }) : super(key: key);

  @override
  _PalState createState() => _PalState();
}

// TODO: Create editor state mode
class _PalState extends State<Pal> {

  final GlobalKey _repaintBoundaryKey = GlobalKey();

  PalEditModeStateService palEditModeStateService;

  // TODO: Flavor integration / inject it instead of creation here
  HttpClient _httpClient;

  @override
  void initState() {
    super.initState();

    // TODO: Wait for app to be initialized
    // TODO: Check if token is valid
    _httpClient = HttpClient.create(
      widget.appToken,
      baseUrl: 'http://217.182.88.6:8053',
    );

    // Register listener on route name change
    // PalController.instance.routeName.addListener(() {
    //   print(PalController.instance.routeName.value);
    // });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
//    palEditModeStateService = EditorInjector.of(context).palEditModeStateService; FIXME uncomment this when injector is working
//    palEditModeStateService.showEditorBubble.addListener(_onShowBubbleStateChanged); FIXME uncomment this when injector is working
  }


  @override
  void dispose() {
    // FIXME: Is it the right place ?
    // PalController.instance.routeName.dispose();
    palEditModeStateService?.showEditorBubble?.removeListener(_onShowBubbleStateChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: (widget.editorModeEnabled)
          ? EditorAppContext(
              httpClient: _httpClient,
              child: Builder(builder: (context) {
                return EditorInjector(
                  child: _buildWrapper(),
                  appContext: EditorAppContext.of(context),
                );
              }),
            )
          : UserAppContext(
              httpClient: _httpClient,
              child: Builder(builder: (context) {
                return UserInjector(
                  child: _buildClientWrapper(),
                  appContext: UserAppContext.of(context),
                );
              }),
            ),
    );
  }

  Widget _buildClientWrapper() {
    return HelperOrchestrator(child: widget.child);
  }

  Widget _buildWrapper() {
    return PalTheme(
      theme: PalThemeData.light(),
      child: Overlayed(
        child: Builder(
          builder: (context) => MaterialApp(
            debugShowCheckedModeBanner: false,
            onGenerateRoute: (RouteSettings settings) => route(settings),
            theme: PalTheme.of(context).buildTheme(),
            home: LayoutBuilder( //TODO put this in another file
              builder: (context, constraints) {
                return Stack(
                  key: ValueKey('palMainStack'),
                  children: [
                    // The app
                    RepaintBoundary(
                      key: _repaintBoundaryKey,
                      child: widget.child,
                    ),
                    // Build the floating widget above the app
//                    if(palEditModeStateService.showEditorBubble.value) //FIXME uncomment this when injector is working
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
            hostedAppNavigatorKey: widget.navigatorKey,
            repaintBoundaryKey: _repaintBoundaryKey,
          ),
        );
      },
    );
  }
}
