import 'package:json_annotation/json_annotation.dart';
import 'package:soap_app/model/exif.dart';
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
    required this.title,
    required this.bio,
    required this.views,
    required this.size,
    required this.color,
    required this.isDark,
    required this.height,
    required this.width,
    required this.model,
    required this.blurhash,
    required this.createTime,
    required this.updateTime,
    this.hash,
    this.originalname,
    this.mimetype,
    this.isLike = false,
    this.likedCount = 0,
    this.commentCount = 0,
    this.make,
    this.user,
    this.tags,
    this.exif,
  });

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);

  final int id;
  final String key, title, bio, blurhash, color;
  final String? hash, originalname, mimetype, make, model;
  final int views, size, height, width;
  final int? commentCount, likedCount;
  final bool? isLike;
  final bool isDark;
  final DateTime createTime, updateTime;

  final User? user;
  final List<Tag>? tags;
  final Exif? exif;

  String pictureUrl({PictureStyle? style = PictureStyle.small}) {
    if (RegExp('^photo\/').hasMatch(key)) {
      return getPictureUrl(key: key, style: style!);
    }
    return getPictureUrl(key: 'photo/' + key, style: style!);
  }

  static List<Picture> fromListJson(List<dynamic> list) => list
      .map<Picture>((dynamic p) => Picture.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$PictureToJson(this);
}
