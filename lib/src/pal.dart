library palplugin;

import 'package:flutter/material.dart';
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

  Pal({
    Key key,
    @required this.child,
    @required this.navigatorKey,
    this.editorModeEnabled = true,
  }) : super(key: key);

  @override
  _PalState createState() => _PalState();
}

// TODO: Create editor state mode
class _PalState extends State<Pal> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      // TODO: To be set on parameter ?
      textDirection: TextDirection.ltr,
      child: MaterialApp(
        onGenerateRoute: (RouteSettings settings) => route(settings),
        theme: ThemeData(
          primarySwatch: Colors.purple,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: LayoutBuilder(
          builder: (context, constraints) {
            return Stack(
              key: ValueKey('palMainStack'),
              children: [
                // The app
                widget.child,

                // Build the floating widget above the app
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
    );
  }

  _showHelpersListModal(BuildContext context) {
    double radius = 25.0;

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(radius),
          topRight: Radius.circular(radius),
        ),
      ),
      backgroundColor: Colors.white,
      builder: (context) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(radius),
          child: HelpersListModal(),
        );
      },
    );
  }
}
