import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:mobx/mobx.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/config/jpush.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/repository/account_repository.dart';
import 'package:soap_app/utils/storage.dart';
import 'package:soap_app/widget/soap_toast.dart';

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
    await getUserInfo();
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
    getUserInfo();
  }

  void initializeSentry() {
    setSentrtyInfo(userInfo);
  }

  void setSentrtyInfo(User? user) {
    if (user != null) {
      Sentry.configureScope(
        (scope) => scope.user = SentryUser(
          id: user.id.toString(),
          username: user.username,
          email: user.email,
        ),
      );
    } else {
      Sentry.configureScope((scope) => scope.user = null);
    }
  }

  void setJPushInfo(User? user) {
    if (user != null) {
      jpush.setAlias(user.id.toString());
    }
  }

  Future<void> getUserInfo() async {
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
    setSentrtyInfo(userInfo);
    setJPushInfo(userInfo);
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
    setSentrtyInfo(userInfo);
    await StorageUtil.preferences!.remove('account.accessToken');
    await StorageUtil.preferences!.remove('account.userInfo');
    await GraphqlConfig.graphQLClient.resetStore();
  }

  @action
  Future<bool> oauthCallback(Uri uri) async {
    final Map<String, String> query = Uri.splitQueryString(uri.query);
    if (query['action'] != null && query['action'] == 'active') {
      SoapToast.error('此账户没有绑定账号!');
      return false;
    }
    if (query['code'] != null) {
      try {
        await codeLogin(
          code: query['code']!,
          type: query['type']!,
        );
        return true;
      } on DioError catch (e) {
        if (e.response?.data['message'] != null) {
          print(e.response?.data['message']);
        }
        return false;
      }
    } else {
      return false;
    }
  }

  @action
  Future<void> codeLogin({required String code, required String type}) async {
    final Map<String, String> params = {
      'code': code,
      'grant_type': 'authorization_code',
    };
    final dynamic data = await accountProvider.oauthToken(type, params);
    await GraphqlConfig.graphQLClient.resetStore();
    await StorageUtil.preferences!
        .setString('account.accessToken', json.encode(data.data));
    setLoginInfo(data.data);
    await getUserInfo();
  }
}
