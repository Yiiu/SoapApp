import 'dart:convert';

import 'package:mobx/mobx.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/repository/account_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soap_app/utils/storage.dart';

part 'account_store.g.dart';

class AccountStore = _AccountStoreBase with _$AccountStore;

abstract class _AccountStoreBase with Store {
  AccountProvider accountProvider = AccountProvider();

  @observable
  String? accessToken;
  @observable
  DateTime? accessTokenExpiresAt;

  @observable
  User? userInfo;

  @computed
  bool get isLogin => accessToken != null && userInfo != null;

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
    await StorageUtil.preferences!
        .setString('account.accessToken', json.encode(data.data));
    getLoginInfo(data.data);
    await GraphqlConfig.graphQLClient.resetStore();
    // await getUserInfo();
  }

  void initialize() {
    final String? dataString =
        StorageUtil.preferences!.getString('account.accessToken');
    if (dataString != null) {
      final dynamic obj = json.decode(dataString);
      getLoginInfo(obj);
    }
  }

  @action
  void getLoginInfo(dynamic data) {
    accessToken = data['accessToken'] as String;
    accessTokenExpiresAt = DateTime.parse(data['createTime'] as String);
    userInfo = User.fromJson(data['user'] as Map<String, dynamic>);
  }

  @action
  Future<void> signup() async {
    accessToken = null;
    accessTokenExpiresAt = null;
    userInfo = null;
    await StorageUtil.preferences!.remove('account.accessToken');
    await GraphqlConfig.graphQLClient.resetStore();
  }
}
