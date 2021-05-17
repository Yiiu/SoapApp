import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AccountProvider {
  AccountProvider() {
    httpClient = Dio()
      ..options.baseUrl = env['API_URL']!
      ..options.connectTimeout = 5000;
  }

  late Dio httpClient;

  Future<Response> oauth(dynamic data) {
    final Map<String, String> map = {
      'Authorization': 'Basic ${env['BASIC_TOKEN']}'
    };
    return httpClient.post<dynamic>(
      '/oauth/token',
      data: data,
      options: Options(
        headers: map,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }

  Future<Response> oauthToken(String type, dynamic data) {
    final Map<String, String> map = {
      'Authorization': 'Basic ${env['BASIC_TOKEN']}'
    };
    return httpClient.post<dynamic>(
      '/oauth/$type/token',
      data: data,
      options: Options(
        headers: map,
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }
}
