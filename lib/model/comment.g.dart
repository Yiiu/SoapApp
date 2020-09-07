// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'comment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Comment _$CommentFromJson(Map<String, dynamic> json) {
  return Comment()
    ..id = json['id'] as int
    ..createTime = json['createTime'] == null
        ? null
        : DateTime.parse(json['createTime'] as String)
    ..content = json['content'] as String
    ..ip = json['ip'] as String
    ..ip_location = json['ip_location']
    ..userAgent = json['userAgent'] as String
    ..user = json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>)
    ..replyUser = json['replyUser'] == null
        ? null
        : User.fromJson(json['replyUser'] as Map<String, dynamic>)
    ..picture = json['picture'] == null
        ? null
        : Picture.fromJson(json['picture'] as Map<String, dynamic>)
    ..parentComment = json['parentComment'] == null
        ? null
        : Comment.fromJson(json['parentComment'] as Map<String, dynamic>)
    ..replyComment = json['replyComment'] == null
        ? null
        : Comment.fromJson(json['replyComment'] as Map<String, dynamic>)
    ..subCount = json['subCount'] as int
    ..childComments = (json['childComments'] as List)
        ?.map((dynamic e) =>
            e == null ? null : Comment.fromJson(e as Map<String, dynamic>))
        ?.toList();
}

Map<String, dynamic> _$CommentToJson(Comment instance) => <String, dynamic>{
      'id': instance.id,
      'createTime': instance.createTime?.toIso8601String(),
      'content': instance.content,
      'ip': instance.ip,
      'ip_location': instance.ip_location,
      'userAgent': instance.userAgent,
      'user': instance.user,
      'replyUser': instance.replyUser,
      'picture': instance.picture,
      'parentComment': instance.parentComment,
      'replyComment': instance.replyComment,
      'subCount': instance.subCount,
      'childComments': instance.childComments,
    };
