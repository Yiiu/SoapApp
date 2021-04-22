import 'package:dio/dio.dart';

class AccountProvider {
  AccountProvider() {
    httpClient = Dio()
      ..options.baseUrl = 'https://soapphoto.com'
      ..options.connectTimeout = 5000;
  }

  late Dio httpClient;

  Future<Response> oauth(dynamic data) {
    final Map<String, String> map = {
      'Authorization':
          'Basic NTczYjUxNTktNTRjYy00ODg2LWJiMmItMjgxY2U2Y2Q5ZWExOnRlc3Q'
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
}
