library pal;

import 'package:flutter/material.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/injectors/user_app/user_app_context.dart';
import 'package:pal/src/injectors/user_app/user_app_injector.dart';
import 'package:pal/src/router.dart';
import 'package:pal/src/ui/client/helper_orchestrator.dart';
import 'package:pal/src/ui/editor/pages/helper_editor/widgets/editor_tutorial.dart';
import 'package:pal/src/ui/editor/pal_editmode_wrapper.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import 'injectors/editor_app/editor_app_injector.dart';
import 'pal_navigator_observer.dart';

// our production server address
const String PAL_SERVER_URL = const String.fromEnvironment("SERVER_URL", defaultValue: "http://217.182.88.6:9040");

// Pal top widget
class Pal extends StatelessWidget {

  /// application child to display Pal over it.
  final MaterialApp childApp;

  /// reference to the Navigator state of the child app
  final GlobalKey<NavigatorState> navigatorKey;

  /// used to manage state of current page
  final PalNavigatorObserver navigatorObserver;

  /// disable or enable the editor mode.
  final bool editorModeEnabled;

  /// text direction of your application.
  final TextDirection textDirection;

  /// set the application token to interact with the server.
  final String appToken;

  Pal({
    Key key,
    @required this.childApp,
    @required this.appToken,
    this.editorModeEnabled = true,
    this.textDirection = TextDirection.ltr,
  }) : assert(childApp != null, 'Pal must embbed a client application'),
     assert(childApp.navigatorKey != null, 'Pal navigatorKey must not be null'),
     navigatorKey = childApp.navigatorKey,
     navigatorObserver = childApp.navigatorObservers.firstWhere((element) => element is PalNavigatorObserver),
     super(key: key) {
     assert(navigatorObserver != null, 'A navigator Observer of type PalObserver must be added to your MaterialApp');
     _init();
  }

  Pal.fromRouterApp({
    Key key,
    @required this.childApp,
    @required this.appToken,
    this.editorModeEnabled = true,
    this.navigatorKey,
    this.textDirection = TextDirection.ltr,
  }) : assert(childApp != null, 'Pal must embbed a client application'),
      assert(navigatorKey != null, 'Pal navigatorKey must not be null'),
      navigatorObserver = PalNavigatorObserver.instance(),
      super(key: key) {
    assert(navigatorObserver != null, 'A navigator Observer of type PalObserver must be added to your MaterialApp');
    _init();
  }

  _init() {
    debugPrint("-- init Pal plugin --");
    debugPrint("starting on server $PAL_SERVER_URL");
    // TODO refactoring split client Key and editor Key
    if(editorModeEnabled) {
      EditorAppContext.init(url: PAL_SERVER_URL, token: this.appToken);
    } else {
      UserAppContext.init(url: PAL_SERVER_URL, token: this.appToken);
    }
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
    return EditorInjector(
      routeObserver: navigatorObserver,
      hostedAppNavigatorKey: navigatorKey,
      child: PalEditModeWrapper(
        userApp: childApp,
        hostedAppNavigatorKey: navigatorKey,
      ),
      boundaryChildKey: navigatorKey,
      appContext: EditorAppContext.instance
    );
  }

  Widget buildUserApp() {
    return UserInjector(
        routeObserver: navigatorObserver,
        child: Builder(
          builder: (context) {
            HelperOrchestrator.getInstance(
              helperClientService: UserInjector.of(context).helperService,
              inAppUserClientService: UserInjector.of(context).inAppUserClientService,
              helpersSynchronizer: UserInjector.of(context).helpersSynchronizerService,
              routeObserver: navigatorObserver,
              navigatorKey: navigatorKey
            );
            return Overlayed(child: childApp);
          }
        ),
        appContext: UserAppContext.instance,
      );
  }


}

