import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/repository/account_repository.dart';
import 'package:soap_app/repository/user_repository.dart';
import 'package:soap_app/utils/auth.dart';
import 'package:soap_app/utils/storage.dart';

class AccountProvider with ChangeNotifier {
  AccountProvider({@required this.repository}) : assert(repository != null) {
    setup();
  }

  final AccountRepository repository;

  String accessToken = '';

  User user;

  bool get isAccount => user != null;

  Future<void> setup() async {
    final String _user = StorageUtil.getString('account.user');
    if (_user != null) {
      user = User.fromJson(json.decode(_user) as Map<String, dynamic>);
    }
    notifyListeners();
  }

  Future<bool> login(
    String username,
    String password,
  ) async {
    final Map<String, String> params = {
      'username': username,
      'password': password,
      'grant_type': 'password',
    };
    final dynamic data = await repository.oauth(params);
    user = User.fromJson(data['user'] as Map<String, dynamic>);
    StorageUtil.setString('account.user', json.encode(data['user']));
    await AuthUtil.setToken(data['accessToken'] as String);
    await getUserInfo();
    notifyListeners();
    return true;
  }

  Future<void> getUserInfo() async {
    final QueryResult data = await UserRepository.whoami();
    if (data.data != null && data.data['whoami'] != null) {
      user = User.fromJson(data.data['whoami'] as Map<String, dynamic>);
    }
    notifyListeners();
  }

  void logout() {
    user = null;
    accessToken = '';
    StorageUtil.remove('account.user');
    AuthUtil.clear();
    notifyListeners();
  }
}
