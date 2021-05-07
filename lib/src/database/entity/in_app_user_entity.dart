import 'package:hive/hive.dart';

part 'in_app_user_entity.g.dart';

@HiveType(typeId: 12)
class InAppUserEntity {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? inAppId;
  @HiveField(2)
  bool? disabledHelpers;
  @HiveField(3)
  bool? anonymous;

  InAppUserEntity(
      {this.id, this.inAppId, this.disabledHelpers, this.anonymous});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "inAppId": this.inAppId,
      "disabledHelpers": this.disabledHelpers,
      "anonymous": this.anonymous,
    };
  }
}
