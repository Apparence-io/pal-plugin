import 'package:pal/src/services/client/in_app_user/in_app_user_client_service.dart';


void setInAppUserManagerService(InAppUserClientService inAppUserClientService){
  InAppUserManager.instance._inAppUserClientService = inAppUserClientService;
}


class InAppUserManager {

  static InAppUserManager _instance = InAppUserManager._();

  InAppUserClientService? _inAppUserClientService;

  InAppUserManager._();

  /// In edition mode, always return true
  Future<bool> connect(final String inAppUserId) async {
    try {
      if (this._inAppUserClientService == null) { // TODO change with config
        return true;
      }
      await this._inAppUserClientService!.onConnect(inAppUserId);
      return true;
    } catch (e){
      return false;
    }
  }

  /// In edition mode, always return true
  Future<bool> disconnect() async {
    try {
      if (this._inAppUserClientService == null) { // TODO change with config
        return true;
      }
      await this._inAppUserClientService!.onDisconnect();
      return true;
    } catch (e){
      return false;
    }
  }

  static InAppUserManager get instance => _instance;
}