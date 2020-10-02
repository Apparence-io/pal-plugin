import 'package:flutter/material.dart';
import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/injectors/editor_app/editor_app_injector.dart';
import 'package:palplugin/src/services/editor/project/app_icon_grabber_delegate.dart';
import 'package:palplugin/src/services/package_version.dart';
import 'package:palplugin/src/theme.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_presenter.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_viewmodel.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/widgets/animated_app_icon.dart';

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
  final PackageVersionReader packageVersionReader;

  AppSettingsPage({
    Key key,
    this.appIconGrabberDelegate,
    this.packageVersionReader,
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
        packageVersionReader: packageVersionReader ??
            EditorInjector.of(context).packageVersionReader,
      ),
      singleAnimControllerBuilder: (tickerProvider) {
        return AnimationController(
          vsync: tickerProvider,
          duration: Duration(
            milliseconds: 800,
          ),
        );
      },
      animListener: (context, presenter, model) {
        if (model.appIconAnimation) {
          context.animationController
              .forward()
              .then((value) => presenter.onAppIconAnimationEnd());
        }
      },
      builder: (context, presenter, model) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            title: Text('Pal settings'),
            elevation: 0,
            backgroundColor: Colors.transparent,
          ),
          body: this._buildPage(context, presenter, model),
        );
      },
    );
  }

  Widget _buildAppIconButton(
    MvvmContext context,
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
        child: AnimatedAppIcon(
          radius: logoSize / 2,
          animationController: context.animationController,
          onTap: presenter.refreshAppIcon,
        ),
      ),
    );
  }

  Widget _buildHeaderGradient(
    final BuildContext context,
    final AppSettingsModel model,
  ) {
    return Container(
      key: model.headerKey,
      decoration: BoxDecoration(
        gradient: PalTheme.of(context).settingsSilverGradient,
      ),
    );
  }

  Widget _buildPage(
    final MvvmContext context,
    final AppSettingsPresenter presenter,
    final AppSettingsModel model,
  ) {
    return Stack(
      children: [
        Column(
          children: [
            Flexible(
              flex: 9,
              child: _buildHeaderGradient(context.buildContext, model),
            ),
            Expanded(
              flex: 25,
              child: _buildBody(context.buildContext, model),
            ),
            // Container(
            //   width: double.infinity,
            //   child: Padding(
            //     padding: const EdgeInsets.only(
            //       left: 16.0,
            //       right: 16.0,
            //       bottom: 16.0,
            //     ),
            //     child: SafeArea(
            //       top: false,
            //       child: _buildSaveButton(context, model),
            //     ),
            //   ),
            // ),
          ],
        ),
        if (model.headerSize != null)
          this._buildAppIconButton(context, model, presenter),
      ],
    );
  }

  Widget _buildBody(
    final BuildContext context,
    final AppSettingsModel model,
  ) {
    return ListView(
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
            'Version ${model.appVersion}',
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
          child: IgnorePointer(
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
        ),
      ],
    );
  }

  // Widget _buildSaveButton(BuildContext context, final AppSettingsModel model) {
  //   return RaisedButton(
  //     key: ValueKey('pal_AppSettingsPage_SaveButton'),
  //     disabledColor: PalTheme.of(context).colors.color4,
  //     child: Text(
  //       'Save',
  //       style: TextStyle(
  //         color: Colors.white,
  //       ),
  //     ),
  //     color: PalTheme.of(context).colors.color1,
  //     onPressed: () {},
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(8.0),
  //     ),
  //   );
  // }
}
