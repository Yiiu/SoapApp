import 'package:json_annotation/json_annotation.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/user.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  Comment();

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);

  int id;

  DateTime createTime;

  String content;

  String ip;

  Object ip_location;

  String userAgent;

  User user;

  User replyUser;

  Picture picture;

  Comment parentComment;

  Comment replyComment;

  int subCount;

  List<Comment> childComments;

  static List<Comment> fromListJson(List<dynamic> list) => list
      .map<Comment>((dynamic p) => Comment.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$CommentToJson(this);
}
