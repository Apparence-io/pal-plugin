library palplugin;

import 'package:flutter/material.dart';
import 'package:palplugin/src/pal_editmode_wrapper.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_context.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/injectors/user_app/user_app_context.dart';
import 'package:palplugin/src/injectors/user_app/user_app_injector.dart';
import 'package:palplugin/src/services/http_client/base_client.dart';
import 'package:palplugin/src/ui/client/helper_orchestrator.dart';

// our production server adress
const PAL_SERVER_URL = 'http://217.182.88.6:8053';

// Pal top widget
class Pal extends StatelessWidget {
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

  final HttpClient _httpClient;

  Pal({
    Key key,
    @required this.child,
    @required this.navigatorKey,
    @required this.appToken,
    this.editorModeEnabled = true,
    this.textDirection = TextDirection.ltr,
  })  : _httpClient = HttpClient.create(appToken, baseUrl: PAL_SERVER_URL),
        assert(child != null, 'Pal must embbed a client application'),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: (editorModeEnabled)
          ? EditorAppContext(
              httpClient: _httpClient,
              child: Builder(builder: (context) {
                return EditorInjector(
                  child: PalEditModeWrapper(
                    userApp: child,
                    hostedAppNavigatorKey: navigatorKey,
                  ),
                  appContext: EditorAppContext.of(context),
                );
              }),
            )
          : UserAppContext(
              httpClient: _httpClient,
              child: Builder(builder: (context) {
                return UserInjector(
                  child: HelperOrchestrator(child: child),
                  appContext: UserAppContext.of(context),
                );
              }),
            ),
    );
  }
}
