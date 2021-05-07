import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class NestedNavigator extends StatelessWidget {
  final GlobalKey<NavigatorState> navigationKey;
  final String initialRoute;
  final Map<String, WidgetBuilder> routes;
  final Function()? onWillPop;

  NestedNavigator({
    required this.navigationKey,
    required this.initialRoute,
    required this.routes,
    this.onWillPop,
  });

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Navigator(
        key: navigationKey,
        initialRoute: initialRoute,
        onGenerateRoute: (RouteSettings routeSettings) {
          WidgetBuilder? builder = routes[routeSettings.name!];
          if (routeSettings.name == initialRoute) {
            return PageRouteBuilder(
              pageBuilder: (context, __, ___) => builder!(context),
              settings: routeSettings,
            );
          } else {
            return MaterialPageRoute(
              builder: builder!,
              settings: routeSettings,
            );
          }
        },
      ),
      onWillPop: () {
        if (this.onWillPop != null) {
          this.onWillPop!();
        }
        if (navigationKey.currentState!.canPop()) {
          navigationKey.currentState!.pop();
          return Future<bool>.value(false);
        }
        return Future<bool>.value(true);
      },
    );
  }
}
