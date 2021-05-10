import 'dart:convert';

import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:mobx/mobx.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/repository/account_repository.dart';
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
    await GraphqlConfig.graphQLClient.resetStore();
    await StorageUtil.preferences!
        .setString('account.accessToken', json.encode(data.data));
    setLoginInfo(data.data);
    await getUserInfo(data.data['user']['username'] as String);
  }

  void initialize() {
    final String? dataString =
        StorageUtil.preferences!.getString('account.accessToken');
    final String? userString =
        StorageUtil.preferences!.getString('account.userInfo');
    if (dataString != null) {
      final dynamic obj = json.decode(dataString);
      setLoginInfo(obj);
    }
    if (userString != null) {
      setUserInfo(
          User.fromJson(json.decode(userString) as Map<String, dynamic>));
    }
  }

  Future<void> getUserInfo(String username) async {
    final graphql.QueryResult result = await GraphqlConfig.graphQLClient.query(
      graphql.QueryOptions(
        document: addFragments(
          query.whoami,
          [...userDetailFragmentDocumentNode],
        ),
      ),
    );
    if (result.data?['whoami'] != null) {
      setUserInfo(
          User.fromJson(result.data?['whoami'] as Map<String, dynamic>));
    }
  }

  @action
  void setLoginInfo(dynamic data) {
    accessToken = data['accessToken'] as String;
    accessTokenExpiresAt = DateTime.parse(data['createTime'] as String);
  }

  @action
  Future<void> setUserInfo(User user) async {
    userInfo = user;
    await StorageUtil.preferences!
        .setString('account.userInfo', json.encode(user));
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
