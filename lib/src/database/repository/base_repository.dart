import 'package:pal/src/services/http_client/base_client.dart';

class BaseHttpRepository {
  final HttpClient httpClient;

  const BaseHttpRepository({required this.httpClient});
}
