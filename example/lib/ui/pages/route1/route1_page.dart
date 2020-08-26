import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal_example/ui/pages/route1/route1_model.dart';
import 'package:pal_example/ui/pages/route1/route1_presenter.dart';

abstract class Route1View {
  void pushToRoute2(final BuildContext context);
}

class Route1Page extends StatelessWidget implements Route1View {
  Route1Page({Key key});

  @override
  Widget build(BuildContext context) {
    return MVVMPage<Route1Presenter, Route1Model>(
      key: ValueKey('Route1'),
      presenter: Route1Presenter(this),
      builder: (context, presenter, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Route 1'),
          ),
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final Route1Presenter presenter,
    final Route1Model model,
  ) {
    return Center(
      child: RaisedButton(
        key: ValueKey('childRoute2Push'),
        child: Text('Push to child route 2'),
        onPressed: () => pushToRoute2(context),
      ),
    );
  }

  @override
  void pushToRoute2(BuildContext context) {
    Navigator.pushNamed(context, '/route2');
  }
}
