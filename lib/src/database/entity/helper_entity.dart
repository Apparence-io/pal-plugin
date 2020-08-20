class HelperEntity {
  String id;
  String name;
  String type;
  DateTime creationDate;
  DateTime lastUpdateDate;
  int priority;
  String pageId;
  int versionId;
  String versionMin;
  String versionMax;

  HelperEntity(
      {this.id,
      this.name,
      this.type,
      this.creationDate,
      this.lastUpdateDate,
      this.priority,
      this.pageId,
      this.versionId,
      this.versionMin,
      this.versionMax});
}
