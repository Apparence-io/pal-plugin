import 'package:mvvm_builder/mvvm_builder.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings.dart';
import 'package:palplugin/src/ui/editor/pages/app_settings/app_settings_viewmodel.dart';

class AppSettingsPresenter extends Presenter<AppSettingsModel, AppSettingsView>{
  AppSettingsPresenter(
    AppSettingsView viewInterface,
  ) : super(AppSettingsModel(), viewInterface);

}