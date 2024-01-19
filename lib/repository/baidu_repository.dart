import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../store/index.dart';

class BaiduProvider {
  BaiduProvider();

  Future<Response> token() {
    final Dio httpClient = Dio()
      ..options.baseUrl = dotenv.env['API_URL']!
      ..options.connectTimeout = const Duration(seconds: 5);
    final Map<String, String> map = {
      'Authorization': 'Bearer ${accountStore.accessToken}',
      'accept': 'application/json',
    };
    return httpClient.get<dynamic>(
      '/api/picture/baidu/token',
      options: Options(
        headers: map,
      ),
    );
  }

  Future<Response?> getImageClassify(String image) async {
    final Response _token = await token();
    final Dio httpClient = Dio()
      ..options.baseUrl = 'https://aip.baidubce.com/rest/2.0'
      ..options.connectTimeout = const Duration(seconds: 5);
    final Map<String, String> data = {'image': image};
    final FormData form = FormData.fromMap(data);
    if (_token.data['access_token'] == null) {
      return null;
    }
    final Map<String, String> queryParameters = {
      'access_token': _token.data['access_token'] as String,
    };
    return httpClient.post<dynamic>(
      '/image-classify/v2/advanced_general',
      data: form,
      queryParameters: queryParameters,
      options: Options(
        contentType: Headers.formUrlEncodedContentType,
      ),
    );
  }
}
