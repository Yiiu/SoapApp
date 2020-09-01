import 'package:dio/dio.dart';

class AccountRepository {
  Future<dynamic> oauth(dynamic data) async {
    try {
      final Map<String, String> map = {
        'Authorization':
            'Basic NTczYjUxNTktNTRjYy00ODg2LWJiMmItMjgxY2U2Y2Q5ZWExOnRlc3Q'
      };
      final Response response = await Dio().post<dynamic>(
        'https://soapphoto.com/oauth/token',
        data: data,
        options: Options(
          headers: map,
          contentType: Headers.formUrlEncodedContentType,
        ),
      );
      return response.data;
    } on DioError catch (e) {
      if (e.response != null) {
        print(e.response.data);
      } else {
        print(e.request);
        print(e.message);
      }
    }
  }
}
