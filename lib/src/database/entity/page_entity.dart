import 'package:hive/hive.dart';

part 'page_entity.g.dart';

@HiveType(typeId: 8)
class PageEntity {

  @HiveField(0)
  String? id;

  @HiveField(1)
  DateTime? creationDate;

  @HiveField(2)
  DateTime? lastUpdateDate;

  @HiveField(3)
  String? route;

  PageEntity({
    this.id,
    this.creationDate,
    this.lastUpdateDate,
    this.route,
  });

  Map<String, dynamic> toJson() => {
    'id': id ?? "",
    'creationDate': creationDate != null ? creationDate!.toIso8601String() : null,
    'lastUpdateDate': lastUpdateDate != null ? lastUpdateDate!.toIso8601String() : null,
    'route': route
  };
}
