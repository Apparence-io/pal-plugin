library pal;

import 'package:flutter/material.dart';
import 'package:pal/src/injectors/editor_app/editor_app_context.dart';
import 'package:pal/src/injectors/editor_app/editor_app_injector.dart';
import 'package:pal/src/injectors/user_app/user_app_context.dart';
import 'package:pal/src/injectors/user_app/user_app_injector.dart';
import 'package:pal/src/pal_database_initializer.dart';
import 'package:pal/src/services/locale_service/locale_service.dart';
import 'package:pal/src/ui/client/helper_orchestrator.dart';
import 'package:pal/src/ui/editor/pal_editmode_wrapper.dart';
import 'package:pal/src/ui/shared/widgets/overlayed.dart';

import 'injectors/editor_app/editor_app_injector.dart';
import 'pal_navigator_observer.dart';
import 'router.dart';

// our production server address
const String PAL_SERVER_URL = const String.fromEnvironment("SERVER_URL",
    defaultValue: "https://app.pal-plugin.tech/api");

/// defer your app building to (used for GetX or other plugins)
typedef ChildAppBuilder = Widget Function(BuildContext context);

// Pal top widget
class Pal extends StatelessWidget {
  /// application child to display Pal over it.
  final MaterialApp? childApp;

  /// build application child dynamically to display Pal over it. (used for GetX or other plugins)
  final ChildAppBuilder? childAppBuilder;

  /// reference to the Navigator state of the child app
  final GlobalKey<NavigatorState>? navigatorKey;

  /// used to manage state of current page
  final PalNavigatorObserver? navigatorObserver;

  /// disable or enable the editor mode.
  final bool editorModeEnabled;

  /// text direction of your application.
  final TextDirection textDirection;

  /// set the application token to interact with the server.
  final String appToken;

  Pal({
    Key? key,
    required MaterialApp this.childApp,
    this.childAppBuilder,
    required this.appToken,
    this.editorModeEnabled = true,
    this.textDirection = TextDirection.ltr,
  })  : assert(childApp != null, 'Pal must embed a client application'),
        assert(appToken.isNotEmpty,
            'Pal application token must be provided, create one in your web dashboard'),
        assert(
            childApp.navigatorKey != null, 'Pal navigatorKey must not be null'),
        navigatorKey = childApp.navigatorKey,
        navigatorObserver = childApp.navigatorObservers!
                .firstWhere((element) => element is PalNavigatorObserver)
            as PalNavigatorObserver?,
        super(key: key) {
    assert(navigatorObserver != null,
        'your app navigatorObservers must contain PalNavigatorObserver like this: navigatorObservers: [PalNavigatorObserver.instance()]');
    _init();
  }

  Pal._({
    Key? key,
    this.childApp,
    this.childAppBuilder,
    this.navigatorKey,
    this.navigatorObserver,
    required this.appToken,
    this.editorModeEnabled = true,
    this.textDirection = TextDirection.ltr,
  }) : super(key: key) {
    _init();
  }

  /// use this factory to use GetX for example
  /// YOU MUST Add in GetMaterialApp like a standard MaterialApp
  ///   - navigatorKey: navigatorKey,
  ///   - onGenerateRoute: routes,
  ///   - navigatorObservers: [PalNavigatorObserver.instance()],
  factory Pal.fromAppBuilder(
          {required ChildAppBuilder childAppBuilder,
          required String appToken,
          required bool editorModeEnabled,
          required GlobalKey<NavigatorState> navigatorKey}) =>
      Pal._(
        childAppBuilder: childAppBuilder,
        appToken: appToken,
        editorModeEnabled: editorModeEnabled,
        navigatorKey: navigatorKey,
        navigatorObserver: PalNavigatorObserver.instance(),
      );

  Pal.fromRouterApp({
    Key? key,
    this.childApp,
    this.childAppBuilder,
    required this.appToken,
    this.editorModeEnabled = true,
    required GlobalKey<NavigatorState> this.navigatorKey,
    this.textDirection = TextDirection.ltr,
  })  : assert(childApp != null || childAppBuilder != null,
            'Pal must embed a client application'),
        assert(navigatorKey != null, 'Pal navigatorKey must not be null'),
        navigatorObserver = PalNavigatorObserver.instance(),
        super(key: key) {
    assert(navigatorObserver != null,
        'A navigator Observer of type PalObserver must be added to your MaterialApp');
    _init();
  }

  _init() {
    debugPrint("-- init Pal plugin --");
    debugPrint("starting on server $PAL_SERVER_URL");
    // TODO refactoring split client Key and editor Key
    if (editorModeEnabled) {
      EditorAppContext.init(url: PAL_SERVER_URL, token: this.appToken);
    } else {
      UserAppContext.init(url: PAL_SERVER_URL, token: this.appToken);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: textDirection,
      // load asynchronous stuff in this class
      child: PalDatabaseInitializer(
        builder: (BuildContext context, snapshot) {
          if (snapshot.hasData) {
            // return client app WITH Pal if already loaded
            return (editorModeEnabled)
                ? buildEditorApp(
                    childApp == null ? childAppBuilder!(context) : childApp,
                  )
                : buildUserApp(
                    childApp == null ? childAppBuilder!(context) : childApp,
                  );
          } else {
            // return client app WITHOUT Pal if not already loaded
            return childApp!;
          }
        },
      ),
    );
  }

  Widget buildEditorApp(Widget? childApp) {
    return EditorInjector(
        routeObserver: navigatorObserver,
        hostedAppNavigatorKey: navigatorKey,
        palNavigatorKey: palNavigatorGlobalKey,
        child: PalEditModeWrapper(
          userApp: childApp,
          hostedAppNavigatorKey: navigatorKey,
        ),
        boundaryChildKey: navigatorKey,
        appContext: EditorAppContext.instance!);
  }

  Widget buildUserApp(Widget? childApp) {
    return UserInjector(
      appContext: UserAppContext.instance!,
      routeObserver: navigatorObserver,
      userLocale: LocaleService(hostedKey: navigatorKey),
      child: Builder(builder: (context) {
        HelperOrchestrator.getInstance(
            helperClientService: UserInjector.of(context)!.helperService,
            inAppUserClientService:
                UserInjector.of(context)!.inAppUserClientService,
            helpersSynchronizer:
                UserInjector.of(context)!.helpersSynchronizerService,
            routeObserver: navigatorObserver,
            packageVersionReader:
                UserInjector.of(context)!.packageVersionReader,
            navigatorKey: navigatorKey);
        return Overlayed(child: childApp!);
      }),
    );
  }
}
