import 'package:palplugin/src/database/entity/in_app_user_entity.dart';
import 'package:palplugin/src/database/repository/in_app_user_repository.dart';
import 'package:palplugin/src/services/client/in_app_user/client_in_app_user_storage.dart';

abstract class ClientInAppUserService {
  Future<InAppUserEntity> create();

  Future<InAppUserEntity> onConnect(String inAppUserId);

  Future<InAppUserEntity> update(bool inAppUserId);

  Future<InAppUserEntity> onDisconnect();

  factory ClientInAppUserService.build(
      InAppUserRepository inAppUserRepository) =>
      _ClientInAppUserHttpService(inAppUserRepository);
}

class _ClientInAppUserHttpService implements ClientInAppUserService {
  final InAppUserRepository _inAppUserRepository;
  final ClientInAppUserStorageManager _clientInAppUserStorageManager;

  _ClientInAppUserHttpService(this._inAppUserRepository)
      : this._clientInAppUserStorageManager =
            ClientInAppUserStorageManager.build();

  @override
  Future<InAppUserEntity> create() async {
    final InAppUserEntity inAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser != null) {
      return inAppUser;
    }

    return this
        ._inAppUserRepository
        .create(InAppUserEntity(disabledHelpers: false));
  }

  @override
  Future<InAppUserEntity> onConnect(final String inAppUserId) async {
    final InAppUserEntity savedInAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    if (savedInAppUser != null && !savedInAppUser.anonymous) {
      return savedInAppUser;
    }

    return this._inAppUserRepository.update(savedInAppUser);
  }

  @override
  Future<InAppUserEntity> update(final bool disabledHelpers) async {
    final InAppUserEntity savedInAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    savedInAppUser.disabledHelpers = disabledHelpers;

    return this._inAppUserRepository.update(savedInAppUser);
  }

  @override
  Future<InAppUserEntity> onDisconnect() async {
    InAppUserEntity inAppUser =
        await this._clientInAppUserStorageManager.readInAppUser();
    if (inAppUser != null && inAppUser.anonymous) {
      return inAppUser;
    }

    this._clientInAppUserStorageManager.clearInAppUser();
    return this
        ._inAppUserRepository
        .create(InAppUserEntity(disabledHelpers: false));
  }
}
