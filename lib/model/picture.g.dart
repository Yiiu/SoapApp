// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'picture.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Picture _$PictureFromJson(Map<String, dynamic> json) {
  return Picture()
    ..id = json['id'] as int
    ..key = json['key'] as String
    ..hash = json['hash'] as String
    ..title = json['title'] as String
    ..bio = json['bio'] as String
    ..views = json['views'] as int
    ..originalname = json['originalname'] as String
    ..mimetype = json['mimetype'] as String
    ..size = json['size'] as int
    ..isLike = json['isLike'] as bool
    ..likedCount = json['likedCount'] as int
    ..commentCount = json['commentCount'] as int
    ..color = json['color'] as String
    ..isDark = json['isDark'] as bool
    ..height = json['height'] as int
    ..width = json['width'] as int
    ..make = json['make'] as String
    ..model = json['model'] as String
    ..blurhash = json['blurhash'] as String
    ..blurhashSrc = json['blurhashSrc'] as String
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String)
    ..updateTime = json['updateTime'] == null
        ? null
        : DateTime.parse(json['updateTime'] as String)
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..tags = (json['tags'] as List)
        ?.map((dynamic e) =>
            e == null ? null : Tag.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$PictureToJson(Picture instance) => <String, dynamic>{
      'id': instance.id,
      'key': instance.key,
      'hash': instance.hash,
      'title': instance.title,
      'bio': instance.bio,
      'views': instance.views,
      'originalname': instance.originalname,
      'mimetype': instance.mimetype,
      'size': instance.size,
      'isLike': instance.isLike,
      'likedCount': instance.likedCount,
      'commentCount': instance.commentCount,
      'color': instance.color,
      'isDark': instance.isDark,
      'height': instance.height,
      'width': instance.width,
      'make': instance.make,
      'model': instance.model,
      'blurhash': instance.blurhash,
      'blurhashSrc': instance.blurhashSrc,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
      'user': instance.user,
      'tags': instance.tags,
    };
