import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal_example/ui/pages/route2/route2_model.dart';
import 'package:pal_example/ui/pages/route2/route2_presenter.dart';

abstract class Route2View {
  void popBack(final BuildContext context);
}

class Route2Page extends StatelessWidget implements Route2View {
  Route2Page({Key key});

  @override
  Widget build(BuildContext context) {
    return MVVMPage<Route2Presenter, Route2Model>(
      key: ValueKey('Route2'),
      presenter: Route2Presenter(this),
      builder: (context, presenter, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Route 2'),
          ),
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final Route2Presenter presenter,
    final Route2Model model,
  ) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        RaisedButton(
          key: ValueKey('childRoutePop'),
          onPressed: () => popBack(context),
          child: Text('Go back!'),
        ),
        RaisedButton(
          key: ValueKey('childRouteToOne'),
          onPressed: () => Navigator.pushNamed(context, "/route1"),
          child: Text('Push page 1 !'),
        ),
      ],
    );
  }

  @override
  void popBack(BuildContext context) {
    Navigator.pop(context);
  }
}
