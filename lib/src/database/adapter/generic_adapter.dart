import 'dart:convert';

import 'package:palplugin/src/database/entity/pageable.dart';

/// GenericEntityAdapter interface
///
/// parse a string to an entity
/// convert an object to a JSON string format
abstract class GenericEntityAdapter<T> {
  String toJson(T model) => json.encode(model);

  T parse(String value) {
    Map<String, dynamic> map = json.decode(value);
    try {
      return parseMap(map);
    } catch (e) {
      print('ERROR WHILE parse JSON $e');
      throw Exception('ERROR WHILE parse JSON $e');
    }
  }

  List<T> parseArray(String value) {
    List<dynamic> lst = json.decode(value);
    List<T> result = List();
    lst.forEach((key) => result.add(parseMap(key)));
    return result;
  }

  Pageable<T> parsePage(String value) {
    Map page = json.decode(value);
    Pageable<T> result = Pageable(
        offset: page['pageable']['offset'],
        pageNumber: page['pageable']['pageNumber'],
        first: page['first'],
        last: page['last'],
        numberOfElements: page['numberOfElements'],
        totalPages: page['totalPages'],
        totalElements: page['totalElements'],
        pageSize: page['pageable']['pageSize']);
    result.entities = this.parseArray(json.encode(page['content']));
    return result;
  }

  Map<String, dynamic> decode(String value) {
    return json.decode(value);
  }

  String encode(Object object) {
    return json.encode(object);
  }

  T parseMap(Map<String, dynamic> map);

  static checkKey(Map<String, dynamic> map, String key) {
    return map.containsKey(key) && map[key] != null && map[key] != '';
  }
}
