import 'package:json_annotation/json_annotation.dart';
import 'package:soap_app/model/tag.dart';
import 'package:soap_app/utils/picture.dart';

// import '../utils/picture.dart';
import './user.dart';

part 'picture.g.dart';

@JsonSerializable()
class Picture {
  Picture({
    required this.id,
    required this.key,
    this.hash,
    required this.title,
    required this.bio,
    required this.views,
    this.originalname,
    this.mimetype,
    required this.size,
    this.isLike = false,
    this.likedCount = 0,
    this.commentCount = 0,
    required this.color,
    required this.isDark,
    required this.height,
    required this.width,
    this.make,
    required this.model,
    required this.blurhash,
    this.blurhashSrc,
    required this.createTime,
    required this.updateTime,
    this.user,
    this.tags,
  });

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);

  final int id;
  final String key;
  final String? hash;
  final String title;
  final String bio;
  final int views;
  final String? originalname;
  final String? mimetype;
  final int size;
  final bool isLike;
  final int likedCount;
  final int? commentCount;
  final String color;
  final bool isDark;
  final int height;
  final int width;
  final String? make;
  final String? model;
  final String blurhash;
  final String? blurhashSrc;
  final DateTime createTime;
  final DateTime updateTime;
  final User? user;
  final List<Tag>? tags;

  String pictureUrl({PictureStyle style = PictureStyle.small}) {
    return getPictureUrl(key: key, style: style);
  }

  static List<Picture> fromListJson(List<dynamic> list) => list
      .map<Picture>((dynamic p) => Picture.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
