class InAppUserEntity {
  String id;
  String inAppId;
  bool disabledHelpers;
  bool anonymous;

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
