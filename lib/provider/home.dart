import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/repository/picture_repository.dart';
import 'package:soap_app/utils/auth.dart';
import 'package:soap_app/utils/storage.dart';

class HomeProvider with ChangeNotifier {
  HomeProvider({@required this.repository}) : assert(repository != null) {
    setup();
  }

  final PictureRepository repository;

  Key key = Key(getRandom(30));

  int timestamp = DateTime.now().millisecondsSinceEpoch;

  int page = 1;

  bool loading = true;

  String error = '';

  dynamic data;

  List<Picture> get pictureList {
    return Picture.fromListJson(
      data != null ? data['pictures']['data'] as List<dynamic> : <dynamic>[],
    );
  }

  int get count {
    return data != null ? data['pictures']['count'] as int : 0;
  }

  Future<void> setup() async {
    // final String _data = StorageUtil.getString('home.data');
    // if (_data != null) {
    //   data = json.decode(_data);
    // }
    // notifyListeners();
  }

  Future<void> init({bool init = false}) async {
    timestamp = DateTime.now().millisecondsSinceEpoch;
    try {
      loading = true;
      final QueryResult result = await repository.getPictureList(
        page: 1,
        timestamp: timestamp,
      );
      if (result.data != null) {
        data = result.data;
        setCache(data, page);
      }
      if (result.exception != null) {
        error = result.exception.toString();
      }
      loading = false;
    } on Exception catch (err) {
      error = err.toString();
      debugPrint('$err');
    } finally {
      loading = false;
    }
    notifyListeners();
  }

  Future<void> onLoading() async {
    if (!loading) {
      try {
        page = page + 1;
        loading = true;
        final QueryResult result = await repository.getPictureList(
          page: page,
          timestamp: timestamp,
        );
        if (result.data != null) {
          data['pictures']['data'] = <dynamic>[
            ...data['pictures']['data'] as List<dynamic>,
            ...result.data['pictures']['data'] as List<dynamic>
          ];
          setCache(data, page);
          loading = false;
        }
      } finally {
        loading = false;
      }
    }
    notifyListeners();
  }

  void reset() {
    key = Key(getRandom(30));
  }

  Future<void> setCache(dynamic data, int page) async {
    StorageUtil.setString('home.data', json.encode(data));
    StorageUtil.setString('home.page', json.encode(page));
  }

  static String getRandom(int len) {
    const String alphabet =
        'qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM';
    final int strlenght = len ?? 30;

    /// 生成的字符串固定长度
    String left = '';
    for (int i = 0; i < strlenght; i++) {
      left = left + alphabet[Random().nextInt(alphabet.length)];
    }
    return left;
  }
}
