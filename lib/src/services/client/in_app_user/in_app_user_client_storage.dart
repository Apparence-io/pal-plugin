import 'package:pal/src/database/entity/in_app_user_entity.dart';
import 'package:pal/src/database/hive_client.dart';

class InAppUserLocalRepository {
  late LocalDbOpener<InAppUserEntity> _boxOpener;
  InAppUserEntity? _inAppUser;

  InAppUserLocalRepository(this._boxOpener);

  Future storeInAppUser(final InAppUserEntity inAppUser) async {
    this._inAppUser = inAppUser;
    await this._boxOpener().then((box) async {
      await box.put("user", inAppUser);
    });
  }

  Future<InAppUserEntity?> readInAppUser() async {
    if (this._inAppUser != null) {
      return Future.value(this._inAppUser);
    }

    return await this._boxOpener().then((box) {
      return box.get("user");
    });
  }

  Future<InAppUserEntity?> clearInAppUser() async {
    return await this._boxOpener().then((box) async {
      await box.delete("user");
      InAppUserEntity? deletedInAppUser = this._inAppUser;
      this._inAppUser = null;
      return deletedInAppUser;
    });
  }
}
