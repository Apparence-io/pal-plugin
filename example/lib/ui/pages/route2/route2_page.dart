import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';

import 'route2_model.dart';
import 'route2_presenter.dart';

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
    return Center(
      child: RaisedButton(
        key: ValueKey('childRoutePop'),
        onPressed: () => Navigator.pop(context),
        child: Text('Go back!'),
      ),
    );
  }

  @override
  void popBack(BuildContext context) {
    Navigator.pop(context);
  }
}
