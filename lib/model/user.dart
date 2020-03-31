import 'package:json_annotation/json_annotation.dart';

import '../utils/picture.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  int id;
  String username;
  String fullName;
  String name;
  String email;
  String avatar;
  String bio;
  String website;
  int likedCount;
  int pictureCount;
  DateTime createTime;
  DateTime updateTime;

  User();

  String get avatarUrl {
    return getPictureUrl(key: avatar, style: PictureStyle.small);
  }

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
  static List<User> fromListJson(List<dynamic> list) =>
      list.map<User>((p) => new User.fromJson(p)).toList();
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
