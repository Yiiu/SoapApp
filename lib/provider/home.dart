import 'package:flutter/material.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/repository/picture_repository.dart';

class HomeProvider with ChangeNotifier {
  HomeProvider({@required this.repository}) : assert(repository != null);
  final PictureRepository repository;

  List<Picture> _pictureList = [];
  List<Picture> get pictureList => _pictureList;

  Future<void> getPictureList() async {
    final result = await repository.getPictureList();
    if (result.data != null) {
      _pictureList = Picture.fromListJson(result.data['pictures']['data']);
      notifyListeners();
    }
  }
}
