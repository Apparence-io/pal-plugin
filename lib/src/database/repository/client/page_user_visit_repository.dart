
import 'dart:convert';

import 'package:http/http.dart';
import 'package:pal/src/database/adapter/helper_group_visit_entity_adapter.dart' as Adapter;
import 'package:pal/src/database/entity/helper/helper_entity.dart';
import 'package:pal/src/database/entity/page_user_visit_entity.dart';
import 'package:pal/src/services/http_client/base_client.dart';

import '../../hive_client.dart';
import '../base_repository.dart';


abstract class HelperGroupUserVisitRepository {

  Future<List<HelperGroupUserVisitEntity>> get(String? userId, String? minAppVersion);

  Future<void> saveAll(List<HelperGroupUserVisitEntity> visits);

  Future<void> add(HelperGroupUserVisitEntity visit, {
    required bool isLast, 
    required bool feedback, 
    required String inAppUserId, 
    required String languageCode, 
    required HelperEntity helper
  });

  Future<void> clear();
}

/// [HelperGroupUserVisitHttpRepository]
class HelperGroupUserVisitHttpRepository extends BaseHttpRepository implements HelperGroupUserVisitRepository {

  Adapter.HelperGroupUserVisitEntityAdapter _adapter = Adapter.HelperGroupUserVisitEntityAdapter();

  HelperGroupUserVisitHttpRepository({required HttpClient httpClient})
    : super(httpClient: httpClient);


  Future<List<HelperGroupUserVisitEntity>> get(String? userId, String? minAppVersion) async {
    final Response response = await this
      .httpClient
      .get(Uri.parse('pal-analytic/users/$userId/groups'));
    return _adapter.parseArray(response.body);
  }

  @override
  Future<void> saveAll(List<HelperGroupUserVisitEntity> visits) async {
    throw UnimplementedError();
  }

  @override
  Future<void> clear() {
    throw UnimplementedError();
  }

  @override
  Future<void> add(HelperGroupUserVisitEntity visit, 
    {
      required bool isLast, 
      required bool feedback, 
      required String inAppUserId, 
      required String languageCode, 
      required HelperEntity helper
    }) async  {
    var url = Uri.parse('pal-analytic/users/$inAppUserId/groups/${visit.helperGroupId}/helpers/${helper.id}');
    var body = jsonEncode({
      'answer': feedback,
      'isLast': isLast,
      'language': languageCode
    });
    await httpClient.post(url, body: body, headers: {"inAppUserId": inAppUserId});
  }
}

/// [HelperGroupUserVisitLocalRepository]
class HelperGroupUserVisitLocalRepository implements HelperGroupUserVisitRepository{

  LocalDbOpener<HelperGroupUserVisitEntity> _hiveBoxOpener;

  HelperGroupUserVisitLocalRepository({required LocalDbOpener<HelperGroupUserVisitEntity> hiveBoxOpener})
    : _hiveBoxOpener = hiveBoxOpener;

  Future<List<HelperGroupUserVisitEntity>> get(String? userId, String? minAppVersion)
    => _hiveBoxOpener().then((res) => res.values.toList());

  @override
  Future<void> saveAll(List<HelperGroupUserVisitEntity> visits)
    => _hiveBoxOpener().then((res) => res.addAll(visits));

  @override
  Future<void> clear() => _hiveBoxOpener().then((res) => res.clear());

  @override
  Future<void> add(HelperGroupUserVisitEntity visit, {
    bool? isLast, 
    bool? feedback, 
    String? inAppUserId, 
    HelperEntity? helper, 
    String? languageCode,  
  }) => _hiveBoxOpener().then((res) => res.add(visit));

}