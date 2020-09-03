import 'package:palplugin/src/database/entity/in_app_user_entity.dart';
import 'package:palplugin/src/database/repository/in_app_user_repository.dart';
import 'package:palplugin/src/services/client/in_app_user/in_app_user_client_storage.dart';

abstract class InAppUserClientService {
  Future<InAppUserEntity> getOrCreate();

  Future<InAppUserEntity> onConnect(String inAppUserId);

  Future<InAppUserEntity> update(bool inAppUserId);

  Future<InAppUserEntity> onDisconnect();
  
  factory InAppUserClientService.build(
      InAppUserRepository inAppUserRepository, {final InAppUserStorageClientManager inAppUserStorageClientManager}) =>
      _ClientInAppUserHttpService(inAppUserRepository, inAppUserStorageClientManager: inAppUserStorageClientManager);
}

class _ClientInAppUserHttpService implements InAppUserClientService {
  final InAppUserRepository _inAppUserRepository;
  final InAppUserStorageClientManager _clientInAppUserStorageManager;

  _ClientInAppUserHttpService(this._inAppUserRepository, {final InAppUserStorageClientManager inAppUserStorageClientManager})
      : this._clientInAppUserStorageManager = inAppUserStorageClientManager ?? InAppUserStorageClientManager.build();

  @override
  Future<InAppUserEntity> getOrCreate() async {
    InAppUserEntity inAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser != null) {
      return inAppUser;
    }

    inAppUser = await this._inAppUserRepository.create(InAppUserEntity(disabledHelpers: false));
    this._clientInAppUserStorageManager.storeInAppUser(inAppUser);
    return inAppUser;
  }

  @override
  Future<InAppUserEntity> onConnect(final String inAppUserId) async {
    InAppUserEntity inAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser == null  || !inAppUser.anonymous) {
      return inAppUser;
    }

    inAppUser = await this._inAppUserRepository.update(InAppUserEntity(
      id: inAppUser.id,
      inAppId: inAppUserId
    ));

    this._clientInAppUserStorageManager.clearInAppUser();
    this._clientInAppUserStorageManager.storeInAppUser(inAppUser);
    return inAppUser;
  }

  @override
  Future<InAppUserEntity> update(final bool disabledHelpers) async {
    InAppUserEntity inAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();

    if (inAppUser == null) {
      return inAppUser;
    }

    inAppUser = await this._inAppUserRepository.update(InAppUserEntity(
        id: inAppUser.id,
        disabledHelpers: disabledHelpers
    ));

    this._clientInAppUserStorageManager.clearInAppUser();
    this._clientInAppUserStorageManager.storeInAppUser(inAppUser);
    return inAppUser;
  }

  @override
  Future<InAppUserEntity> onDisconnect() async {
    InAppUserEntity inAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser == null || inAppUser.anonymous) {
      return inAppUser;
    }

    this._clientInAppUserStorageManager.clearInAppUser();

    inAppUser = await this
        ._inAppUserRepository
        .create(InAppUserEntity(disabledHelpers: false));

    this._clientInAppUserStorageManager.storeInAppUser(inAppUser);

    return inAppUser;
  }
}
