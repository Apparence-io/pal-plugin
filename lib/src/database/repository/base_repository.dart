import 'package:palplugin/src/services/http_client/base_client.dart';

class BaseHttpRepository {
  final HttpClient httpClient;

  const BaseHttpRepository({this.httpClient});
}
