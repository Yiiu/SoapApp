import 'package:json_annotation/json_annotation.dart';

import '../utils/picture.dart';
import './user.dart';

part 'picture.g.dart';

@JsonSerializable()
class Picture {
  Picture();

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);

  int id;
  String key;
  String hash;
  String title;
  String bio;
  int views;
  String originalname;
  String mimetype;
  int size;
  bool isLike;
  int likedCount;
  int commentCount;
  String color;
  bool isDark;
  int height;
  int width;
  String make;
  String model;
  String blurhash;
  String blurhashSrc;
  DateTime createTime;
  DateTime updateTime;
  User user;

  String pictureUrl({PictureStyle style = PictureStyle.small}) {
    return getPictureUrl(key: key, style: style);
  }

  static List<Picture> fromListJson(List<dynamic> list) => list
      .map<Picture>((dynamic p) => Picture.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
