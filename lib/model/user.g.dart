// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as int
    ..username = json['username'] as String
    ..fullName = json['fullName'] as String
    ..name = json['name'] as String
    ..email = json['email'] as String
    ..avatar = json['avatar'] as String
    ..bio = json['bio'] as String
    ..website = json['website'] as String
    ..cover = json['cover'] as String
    ..likedCount = json['likedCount'] as int
    ..likesCount = json['likesCount'] as int
    ..pictureCount = json['pictureCount'] as int
    ..followerCount = json['followerCount'] as int
    ..followedCount = json['followedCount'] as int
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String)
    ..updateTime = json['updateTime'] == null
        ? null
        : DateTime.parse(json['updateTime'] as String)
    ..pictures = (json['pictures'] as List<dynamic>)
        ?.map((dynamic e) =>
            e == null ? null : Picture.fromJson(e as Map<String, dynamic>))
        ?.toList()
    ..isFollowing = json['isFollowing'] as int;
}

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'fullName': instance.fullName,
      'name': instance.name,
      'email': instance.email,
      'avatar': instance.avatar,
      'bio': instance.bio,
      'website': instance.website,
      'cover': instance.cover,
      'likedCount': instance.likedCount,
      'likesCount': instance.likesCount,
      'pictureCount': instance.pictureCount,
      'followerCount': instance.followerCount,
      'followedCount': instance.followedCount,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
      'pictures': instance.pictures,
      'isFollowing': instance.isFollowing,
    };
