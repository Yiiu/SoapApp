import 'package:json_annotation/json_annotation.dart';
import 'package:soap_app/model/user.dart';

part 'comment.g.dart';

@JsonSerializable()
class Comment {
  Comment({
    required this.id,
    required this.content,
    this.user,
    this.parentComment,
    this.replyComment,
    this.replyUser,
    required this.subCount,
    this.childComments,
    required this.createTime,
    required this.updateTime,
  });

  factory Comment.fromJson(Map<String, dynamic> json) =>
      _$CommentFromJson(json);
  Map<String, dynamic> toJson() => _$CommentToJson(this);
  static List<Comment> fromListJson(List<dynamic> list) => list
      .map<Comment>((dynamic p) => Comment.fromJson(p as Map<String, dynamic>))
      .toList();

  final int id;
  final String content;
  final User? user;
  final Comment? parentComment, replyComment;
  final User? replyUser;
  final int subCount;
  final List<Comment>? childComments;
  final DateTime createTime, updateTime;
}
