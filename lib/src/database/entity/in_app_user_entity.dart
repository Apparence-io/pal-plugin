class InAppUserEntity {
  String id;
  String userAppId;
  bool disabledHelpers;
  bool anonymous;

  InAppUserEntity(
      {this.id, this.userAppId, this.disabledHelpers, this.anonymous});

  Map<String, dynamic> toJson() {
    return {
      "id": this.id,
      "userAppId": this.userAppId,
      "disabledHelpers": this.disabledHelpers,
      "anonymous": this.anonymous,
    };
  }
}
