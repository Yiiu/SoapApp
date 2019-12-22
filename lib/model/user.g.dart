// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) {
  return User()
    ..id = json['id'] as String
    ..username = json['username'] as String
    ..fullName = json['fullName'] as String
    ..name = json['name'] as String
    ..email = json['email'] as String
    ..avatar = json['avatar'] as String
    ..bio = json['bio'] as String
    ..website = json['website'] as String
    ..likedCount = json['likedCount'] as int
    ..pictureCount = json['pictureCount'] as int
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String)
    ..updateTime = json['updateTime'] == null
        ? null
        : DateTime.parse(json['updateTime'] as String);
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
      'likedCount': instance.likedCount,
      'pictureCount': instance.pictureCount,
      'createTime': instance.createTime?.toIso8601String(),
      'updateTime': instance.updateTime?.toIso8601String(),
    };
