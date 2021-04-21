import 'package:json_annotation/json_annotation.dart';
import 'package:soap_app/model/tag.dart';

// import '../utils/picture.dart';
import './user.dart';

part 'picture.g.dart';

@JsonSerializable()
class Picture {
  Picture({
    required this.id,
    required this.key,
    required this.hash,
    required this.title,
    required this.bio,
    required this.views,
    required this.originalname,
    required this.mimetype,
    required this.size,
    required this.isLike,
    required this.likedCount,
    required this.commentCount,
    required this.color,
    required this.isDark,
    required this.height,
    required this.width,
    required this.make,
    required this.model,
    required this.blurhash,
    required this.blurhashSrc,
    required this.createTime,
    required this.updateTime,
    required this.user,
    required this.tags,
  });

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

  List<Tag> tags;

  // String pictureUrl({PictureStyle style = PictureStyle.small}) {
  //   return getPictureUrl(key: key, style: style);
  // }

  static List<Picture> fromListJson(List<dynamic> list) => list
      .map<Picture>((dynamic p) => Picture.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
