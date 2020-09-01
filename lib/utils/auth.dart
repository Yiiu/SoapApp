import 'package:soap_app/utils/storage.dart';

class AuthUtil {
  static String getToken() {
    return StorageUtil.getString('account.accessToken');
  }

  static void setToken(String value) {
    StorageUtil.setString('account.accessToken', value);
  }

  static void clear() {
    StorageUtil.remove('account.accessToken');
  }
}
