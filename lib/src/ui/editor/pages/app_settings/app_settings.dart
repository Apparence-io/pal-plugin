import 'package:application_icon/application_icon.dart';
import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/services/editor/project/app_icon_grabber_delegate.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_viewmodel.dart';
import 'package:palplugin/src/ui/shared/widgets/circle_button.dart';

class AppSettingsPageArguments {
  final String pageId;

  AppSettingsPageArguments(
    this.pageId,
  );
}

abstract class AppSettingsView {}

const logoSize = 120.0;

class AppSettingsPage extends StatelessWidget implements AppSettingsView {
  final AppIconGrabberDelegate appIconGrabberDelegate;

  AppSettingsPage({
    Key key,
    this.appIconGrabberDelegate,
  });

  final _mvvmPageBuilder =
      MVVMPageBuilder<AppSettingsPresenter, AppSettingsModel>();

  @override
  Widget build(BuildContext context) {
    return _mvvmPageBuilder.build(
      key: UniqueKey(),
      context: context,
      presenterBuilder: (context) => AppSettingsPresenter(
        this,
        appIconGrabberDelegate: appIconGrabberDelegate ??
            EditorInjector.of(context).appIconGrabberDelegate,
      ),
      builder: (context, presenter, model) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text('Pal settings'),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: this._buildPage(context.buildContext, presenter, model),
        );
      },
    );
  }

  Widget _buildHeader(
    BuildContext context,
    final AppSettingsModel model,
    final AppSettingsPresenter presenter,
  ) {
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: EdgeInsets.only(
          top: (model.headerSize.height / 2) +
              ((model.headerSize.height - logoSize) / 2),
        ),
        child: Container(
          width: logoSize,
          height: logoSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                spreadRadius: 4,
                blurRadius: 4,
                offset: Offset(0, 2), // changes position of shadow
              ),
            ],
          ),
          child: Stack(
            children: [
              ClipOval(child: AppIconImage()),
              Align(
                alignment: Alignment.bottomRight,
                child: CircleIconButton(
                  icon: Icon(
                    Icons.refresh,
                    color: PalTheme.of(context).colors.light,
                  ),
                  backgroundColor: PalTheme.of(context).colors.dark,
                  onTapCallback: presenter.refreshAppIcon,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPage(
    final BuildContext context,
    final AppSettingsPresenter presenter,
    final AppSettingsModel model,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            Flexible(
              flex: 9,
              child: Container(
                key: model.headerKey,
                decoration: BoxDecoration(
                  gradient: PalTheme.of(context).settingsSilverGradient,
                ),
              ),
            ),
            Expanded(
              flex: 25,
              child: ListView(
                padding: EdgeInsets.only(top: (logoSize / 2) + 30.0),
                children: [
                  Center(
                    child: Text(
                      'My Application name',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 20,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 8.0,
                  ),
                  Center(
                    child: Text(
                      'Version 0.0.0',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 10.0,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 32.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: OutlineButton(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: Text(
                          'Beta account member',
                          style: TextStyle(
                            color: PalTheme.of(context).colors.color1,
                          ),
                        ),
                      ),
                      borderSide: BorderSide(
                        color: PalTheme.of(context).colors.color1,
                      ),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(
                          color: PalTheme.of(context).colors.color1,
                          width: 3,
                          style: BorderStyle.solid,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
            ),
            Container(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 16.0,
                  right: 16.0,
                  bottom: 16.0,
                ),
                child: SafeArea(
                  top: false,
                  child: _buildSaveButton(context, model),
                ),
              ),
            ),
          ],
        ),
        if (model.headerSize != null)
          this._buildHeader(context, model, presenter),
      ],
    );
  }

  Widget _buildSaveButton(BuildContext context, final AppSettingsModel model) {
    return RaisedButton(
      key: ValueKey('pal_AppSettingsPage_SaveButton'),
      disabledColor: PalTheme.of(context).colors.color4,
      child: Text(
        'Save',
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      color: PalTheme.of(context).colors.color1,
      onPressed: () {},
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8.0),
      ),
    );
  }
}
