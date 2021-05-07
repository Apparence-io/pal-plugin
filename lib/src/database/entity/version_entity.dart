/// User Application version
class VersionEntity {
  int? id;
  String? name;

  VersionEntity({this.id, this.name});

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name
  };
}