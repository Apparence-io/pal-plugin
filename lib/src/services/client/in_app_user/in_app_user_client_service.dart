import 'package:pal/src/database/entity/in_app_user_entity.dart';
import 'package:pal/src/database/repository/in_app_user_repository.dart';
import 'package:pal/src/services/client/in_app_user/in_app_user_client_storage.dart';

abstract class InAppUserClientService {
  Future<InAppUserEntity> getOrCreate();

  Future<InAppUserEntity?> onConnect(String inAppUserId);

  Future<InAppUserEntity?> update(bool inAppUserId);

  Future<InAppUserEntity?> onDisconnect();
  
  factory InAppUserClientService.build(
      InAppUserRepository inAppUserRepository, final InAppUserLocalRepository inAppUserStorageClientManager) =>
      _ClientInAppUserHttpService(inAppUserRepository, inAppUserStorageClientManager);
}

class _ClientInAppUserHttpService implements InAppUserClientService {
  final InAppUserRepository _inAppUserRepository;
  final InAppUserLocalRepository _clientInAppUserStorageManager;

  _ClientInAppUserHttpService(this._inAppUserRepository, final InAppUserLocalRepository inAppUserStorageClientManager)
      : this._clientInAppUserStorageManager = inAppUserStorageClientManager;

  @override
  Future<InAppUserEntity> getOrCreate() async {
    InAppUserEntity? inAppUser = await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser != null) {
      return inAppUser;
    }

    inAppUser = await this._inAppUserRepository.create(InAppUserEntity(disabledHelpers: false));
    await this._clientInAppUserStorageManager.storeInAppUser(inAppUser);
    return inAppUser;
  }

  @override
  Future<InAppUserEntity?> onConnect(final String inAppUserId) async {
    InAppUserEntity? inAppUser = await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser == null  || !inAppUser.anonymous!) {
      return inAppUser;
    }

    inAppUser = await this._inAppUserRepository.update(InAppUserEntity(
      id: inAppUser.id,
      inAppId: inAppUserId
    ));
    await this._clientInAppUserStorageManager.clearInAppUser();
    await this._clientInAppUserStorageManager.storeInAppUser(inAppUser);
    return inAppUser;
  }

  @override
  Future<InAppUserEntity?> update(final bool disabledHelpers) async {
    InAppUserEntity? inAppUser = await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser == null) {
      return inAppUser;
    }

    inAppUser = await this._inAppUserRepository.update(InAppUserEntity(
        id: inAppUser.id,
        disabledHelpers: disabledHelpers
    ));
    await this._clientInAppUserStorageManager.clearInAppUser();
    await this._clientInAppUserStorageManager.storeInAppUser(inAppUser);
    return inAppUser;
  }

  @override
  Future<InAppUserEntity?> onDisconnect() async {
    InAppUserEntity? inAppUser = await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser == null || inAppUser.anonymous!) {
      return inAppUser;
    }

    await this._clientInAppUserStorageManager.clearInAppUser();
    inAppUser = await this
        ._inAppUserRepository
        .create(InAppUserEntity(disabledHelpers: false));
    await this._clientInAppUserStorageManager.storeInAppUser(inAppUser);
    return inAppUser;
  }
}
