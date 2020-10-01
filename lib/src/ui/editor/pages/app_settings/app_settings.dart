import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_viewmodel.dart';

class AppSettingsPageArguments {
  final String pageId;

  AppSettingsPageArguments(
    this.pageId,
  );
}

abstract class AppSettingsView {}

class AppSettingsPage extends StatelessWidget implements AppSettingsView {
  AppSettingsPage({Key key});

  final _mvvmPageBuilder =
      MVVMPageBuilder<AppSettingsPresenter, AppSettingsModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => AppSettingsPresenter(
        this,
      ),
      builder: (context, presenter, model) {
        return CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              title: Text('Pal settings'),
              expandedHeight: 200.0,
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient:
                      PalTheme.of(context.buildContext).settingsSilverGradient,
                ),
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Transform.translate(
                    offset: Offset(0, 25),
                      child: Icon(
                    Icons.ac_unit,
                    size: 50,
                  )),
                ),
              ),
            ),
            SliverFixedExtentList(
              itemExtent: 150.0,
              delegate: this._buildPage(context.buildContext, presenter, model),
            ),
          ],
        );
      },
    );
  }

  SliverChildListDelegate _buildPage(
    final BuildContext context,
    final AppSettingsPresenter presenter,
    final AppSettingsModel model,
  ) {
    return SliverChildListDelegate(
      [
        Container(color: Colors.red),
        Container(color: Colors.purple),
        Container(color: Colors.green),
        Container(color: Colors.orange),
        Container(color: Colors.yellow),
        Container(color: Colors.pink),
      ],
    );
  }
}
