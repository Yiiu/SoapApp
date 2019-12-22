import "package:json_annotation/json_annotation.dart";

import '../utils/picture.dart';
import './user.dart';

part 'picture.g.dart';

@JsonSerializable()
class Picture {
  String id;
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
  String color;
  bool isDark;
  int height;
  int width;
  String make;
  String model;
  DateTime createTime;
  DateTime updateTime;
  User user;

  Picture();

  String pictureUrl({PictureStyle style: PictureStyle.small}) {
    return getPictureUrl(key: key, style: style);
  }

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);
  static List<Picture> fromListJson(List<dynamic> list) =>
      list.map<Picture>((p) => new Picture.fromJson(p)).toList();
  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
