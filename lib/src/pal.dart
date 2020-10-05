library palplugin;

import 'package:flutter/material.dart';
import 'package:palplugin/palplugin.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_context.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/injectors/user_app/user_app_context.dart';
import 'package:palplugin/src/injectors/user_app/user_app_injector.dart';
import 'package:palplugin/src/ui/client/helper_orchestrator.dart';
import 'package:palplugin/src/ui/editor/pal_editmode_wrapper.dart';

import 'injectors/editor_app/editor_app_injector.dart';

// our production server address
const PAL_SERVER_URL = 'http://217.182.88.6:8050';

// Pal top widget
class Pal extends StatelessWidget {

  /// application child to display Pal over it.
  final MaterialApp child;

  // reference to the Navigator state of the child app
  final GlobalKey<NavigatorState> navigatorKey;

  // used to manage state of current page
  final PalNavigatorObserver navigatorObserver;

  /// disable or enable the editor mode.
  final bool editorModeEnabled;

  /// text direction of your application.
  final TextDirection textDirection;

  /// set the application token to interact with the server.
  final String appToken;

  Pal({
    Key key,
    @required this.child,
    @required this.appToken,
    this.editorModeEnabled = true,
    this.textDirection = TextDirection.ltr,
  }) : assert(child != null, 'Pal must embbed a client application'),
     assert(child.navigatorKey != null, 'Pal navigatorKey must not be null'),
     navigatorKey = child.navigatorKey,
     navigatorObserver = child.navigatorObservers.firstWhere((element) => element is PalNavigatorObserver),
     super(key: key) {
    assert(navigatorObserver != null, 'A navigator Observer of type PalObserver must be added to your MaterialApp');
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      child: (editorModeEnabled)
          ? buildEditorApp()
          : buildUserApp(),
    );
  }

  Widget buildEditorApp() {
    return EditorAppContext.create(
      url: PAL_SERVER_URL,
      token: this.appToken,
      child: Builder(builder: (context) => EditorInjector(
          routeObserver: navigatorObserver,
          child: PalEditModeWrapper(
            userApp: child,
            hostedAppNavigatorKey: navigatorKey,
          ),
          boundaryChildKey: navigatorKey, // FIXME: Need to send boundary here!
          appContext: EditorAppContext.of(context),
        )),
    );
  }

  Widget buildUserApp() {
    return UserAppContext.create(
      url: PAL_SERVER_URL,
      token: this.appToken,
      child: Builder(builder: (context) => UserInjector(
          routeObserver: navigatorObserver,
          child: Builder(
            builder: (context) => HelperOrchestrator(
              helperClientService: UserInjector.of(context).helperService,
              inAppUserClientService: UserInjector.of(context).inAppUserClientService,
              routeObserver: navigatorObserver,
              child: child
            ),
          ),
          appContext: UserAppContext.of(context),
        )),
    );
  }


}

