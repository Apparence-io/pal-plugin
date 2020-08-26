import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:pal_example/ui/pages/home/home_model.dart';
import 'package:pal_example/ui/pages/home/home_presenter.dart';

abstract class HomeView {
  void pushToRoute1(final BuildContext context);
  void pushToRoute2(final BuildContext context);
}

class HomePage extends StatelessWidget implements HomeView {
  HomePage({Key key});

  @override
  Widget build(BuildContext context) {
    return MVVMPage<HomePresenter, HomeModel>(
      key: ValueKey('Home'),
      presenter: HomePresenter(this),
      builder: (context, presenter, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Pal example'),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: presenter.incrementCounter,
            tooltip: 'Increment',
            child: Icon(Icons.add),
          ),
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final HomePresenter presenter,
    final HomeModel model,
  ) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            'You have pushed the button this many times:',
          ),
          Text(
            '${model.counter}',
            style: Theme.of(context).textTheme.headline4,
          ),
          SizedBox(
            height: 20.0,
          ),
          RaisedButton(
            key: ValueKey('childRoute1Push'),
            child: Text('Push to child route 1'),
            onPressed: () => pushToRoute1(context),
          ),
          RaisedButton(
            key: ValueKey('childRoute2Push'),
            child: Text('Push to child route 2'),
            onPressed: () => pushToRoute2(context),
          )
        ],
      ),
    );
  }

  @override
  void pushToRoute1(BuildContext context) {
    Navigator.pushNamed(context, '/route1');
  }

  @override
  void pushToRoute2(BuildContext context) {
    Navigator.pushNamed(context, '/route2');
  }
}
