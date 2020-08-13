import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/repository/picture_repository.dart';

class HomeProvider with ChangeNotifier {
  HomeProvider({@required this.repository}) : assert(repository != null);
  final PictureRepository repository;

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

  Future<void> init() async {
    try {
      loading = true;
      final QueryResult result = await repository.getPictureList(page: 1);
      if (result.data != null) {
        data = result.data;
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
        final QueryResult result = await repository.getPictureList(page: page);
        if (result.data != null) {
          data['pictures']['data'] = <dynamic>[
            ...data['pictures']['data'] as List<dynamic>,
            ...result.data['pictures']['data'] as List<dynamic>
          ];
          print(data['pictures']['data'].length);
          loading = false;
        }
      } finally {
        loading = false;
      }
    }
    notifyListeners();
  }
}
