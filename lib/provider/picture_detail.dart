import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:graphql/client.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/repository/picture_repository.dart';
import 'package:soap_app/utils/storage.dart';

class PictureDetailProvider with ChangeNotifier {
  Picture picture;

  void init(Picture data) {
    final String dataJson = StorageUtil.getString('pictureDetail.${data.id}');
    if (dataJson != null) {
      final Picture _picture =
          Picture.fromJson(json.decode(dataJson) as Map<String, dynamic>);
      picture = _picture;
    } else {
      picture = data;
    }
  }

  Future<void> getDetail() async {
    final QueryResult data = await PictureRepository().getPicture(picture.id);
    if (data.data['picture'] != null) {
      await StorageUtil.setString(
          'pictureDetail.${picture.id}', json.encode(data.data['picture']));
      picture = Picture.fromJson(data.data['picture'] as Map<String, dynamic>);
    }
    notifyListeners();
  }
}
