import 'package:hive/hive.dart';
import 'package:pal/src/database/entity/in_app_user_entity.dart';
import 'package:pal/src/database/hive_client.dart';

class InAppUserStorageClientManager {
  final HiveClient _localStorageManager;
  late Box<InAppUserEntity> box;
  InAppUserEntity? _inAppUser;

  factory InAppUserStorageClientManager.build() =>
      InAppUserStorageClientManager._private(HiveClient());

  InAppUserStorageClientManager._private(this._localStorageManager) {
    this
        ._localStorageManager
        .openInAppUserBox()
        .then((value) => this.box = value);
  }

  Future storeInAppUser(final InAppUserEntity inAppUser) async {
    this._inAppUser = inAppUser;
    await this.box.put("user", inAppUser);
  }

  InAppUserEntity? readInAppUser() {
    if (this._inAppUser != null) {
      return this._inAppUser;
    }
    return this.box.get("user");
  }

  Future<InAppUserEntity?> clearInAppUser() async {
    await this.box.delete("user");
    InAppUserEntity? deletedInAppUser = this._inAppUser;
    this._inAppUser = null;
    return deletedInAppUser;
  }
}
