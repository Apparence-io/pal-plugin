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
    final InAppUserEntity inAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser != null) {
      return inAppUser;
    }

    return await this._inAppUserRepository.create(InAppUserEntity(disabledHelpers: false));
  }

  @override
  Future<InAppUserEntity> onConnect(final String inAppUserId) async {
    final InAppUserEntity savedInAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    if (savedInAppUser == null  || !savedInAppUser.anonymous) {
      return savedInAppUser;
    }

    return this._inAppUserRepository.update(InAppUserEntity(
      id: savedInAppUser.id,
      inAppId: inAppUserId
    ));
  }

  @override
  Future<InAppUserEntity> update(final bool disabledHelpers) async {
    final InAppUserEntity savedInAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();

    if (savedInAppUser == null) {
      return savedInAppUser;
    }

    return this._inAppUserRepository.update(InAppUserEntity(
        id: savedInAppUser.id,
        disabledHelpers: disabledHelpers
    ));
  }

  @override
  Future<InAppUserEntity> onDisconnect() async {
    InAppUserEntity inAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser == null || inAppUser.anonymous) {
      return inAppUser;
    }

    this._clientInAppUserStorageManager.clearInAppUser();
    return await this
        ._inAppUserRepository
        .create(InAppUserEntity(disabledHelpers: false));
  }
}
