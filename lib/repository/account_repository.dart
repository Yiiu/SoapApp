import 'package:dio/dio.dart';

class AccountRepository {
  Future<dynamic> oauth(dynamic data) async {
    try {
      final Response response = await Dio().post<dynamic>(
        'https://soapphoto.com/oauth/token',
        data: data,
        options: Options(
          headers: {
            'Authorization':
                'Basic NTczYjUxNTktNTRjYy00ODg2LWJiMmItMjgxY2U2Y2Q5ZWExOnRlc3Q'
          },
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
