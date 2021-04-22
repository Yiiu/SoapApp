import 'package:mobx/mobx.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/repository/account_repository.dart';

part 'account_store.g.dart';

class AccountStore = _AccountStoreBase with _$AccountStore;

abstract class _AccountStoreBase with Store {
  AccountProvider accountProvider = AccountProvider();

  @observable
  late User userInfo;

  Future<void> login(
    String username,
    String password,
  ) async {
    final Map<String, String> params = {
      'username': username,
      'password': password,
      'grant_type': 'password',
    };
    final dynamic data = await accountProvider.oauth(params);
    final User user = User.fromJson(data['user'] as Map<String, dynamic>);
    print(user);
    // await getUserInfo();
  }
}
