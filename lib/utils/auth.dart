import 'package:soap_app/utils/storage.dart';

class AuthUtil {
  static String getToken() {
    return StorageUtil.getString('account.accessToken');
  }

  static Future<void> setToken(String value) async {
    await StorageUtil.setString('account.accessToken', value);
  }

  static void clear() {
    StorageUtil.remove('account.accessToken');
  }
}
