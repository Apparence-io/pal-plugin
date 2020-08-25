library palplugin;

import 'package:flutter/material.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_context.dart';
import 'package:palplugin/src/injectors/user_app/user_app_context.dart';
import 'package:palplugin/src/pal_controller.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/pages/helpers_list/helpers_list_modal.dart';
import 'package:palplugin/src/ui/widgets/bubble_overlay.dart';
import 'package:palplugin/src/router.dart';

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

  final RouteObserver<PageRoute> routeObserver;

  Pal({
    Key key,
    @required this.child,
    @required this.navigatorKey,
    @required this.appToken,
    @required this.routeObserver,
    this.editorModeEnabled = true,
    this.textDirection = TextDirection.ltr,
  }) : super(key: key);

  @override
  _PalState createState() => _PalState();
}

// TODO: Create editor state mode
class _PalState extends State<Pal> {
  final GlobalKey _repaintBoundaryKey = GlobalKey();

  // TODO: Flavor integration
  HttpClient _httpClient;

  @override
  void initState() {
    super.initState();

    // TODO: Wait for app to be initialized
    // TODO: Check if token is valid
    _httpClient = HttpClient.create(
      widget.appToken,
      baseUrl: 'http://217.182.88.6:8053/',
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Child app is now fully initializated
      print(widget.navigatorKey.currentContext);
    });

    // Register listener on route name change
    PalController.instance.routeName.addListener(() {
      print(PalController.instance.routeName.value);
    });
  }

  @override
  void dispose() {
    PalController.instance.routeName.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: widget.textDirection,
      child: (widget.editorModeEnabled)
          ? EditorAppContext(
              httpClient: _httpClient,
              child: _buildWrapper(),
            )
          : UserAppContext(
              httpClient: _httpClient,
              child: _buildWrapper(),
            ),
    );
  }

  Widget _buildWrapper() {
    return MaterialApp(
      onGenerateRoute: (RouteSettings settings) => route(settings),
      theme: PalTheme.light,
      home: LayoutBuilder(
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
              if (widget.editorModeEnabled)
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
    );
  }

  _showHelpersListModal(BuildContext context) {
    double radius = 25.0;

    var test = ModalRoute.of(widget.navigatorKey.currentState.context);
    print(test.settings.name);

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
