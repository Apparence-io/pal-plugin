import 'package:palplugin/src/database/adapter/in_app_user_storage_adapter.dart';
import 'package:palplugin/src/database/entity/in_app_user_entity.dart';
import 'package:palplugin/src/services/local_storage/local_storage_manager.dart';

class InAppUserStorageClientManager {
  final StorageManager _localStorageManager;
  final InAppUserEntityAdapter _adapter;
  InAppUserEntity _inAppUser;

  factory InAppUserStorageClientManager.build() =>
      InAppUserStorageClientManager._private(
          LocalStorageManager("in_app_user"), InAppUserEntityAdapter());

  InAppUserStorageClientManager._private(
      this._localStorageManager, this._adapter);

  Future storeInAppUser(final InAppUserEntity inAppUser) async {
    this._inAppUser = inAppUser;
    await this._localStorageManager.store(this._adapter.toJson(inAppUser));
  }

  Future<InAppUserEntity> readInAppUser() {
    if (this._inAppUser != null) {
      return Future.value(this._inAppUser);
    }
    return this._localStorageManager.read().then((res) {
      if (res != null && res.length > 0) {
        try {
          this._inAppUser = this._adapter.parse(res);
          return this._inAppUser;
        } catch (e) {
          return null;
        }
      }
      return null;
    });
  }

  Future<InAppUserEntity> clearInAppUser() async {
    await this._localStorageManager.deleteFile();
    InAppUserEntity deletedInAppUser = this._inAppUser;
    this._inAppUser = null;
    return deletedInAppUser;
  }
}
