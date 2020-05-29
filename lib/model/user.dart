import 'package:json_annotation/json_annotation.dart';

import '../utils/picture.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

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

  String get avatarUrl {
    return getPictureUrl(key: avatar, style: PictureStyle.small);
  }

  static List<User> fromListJson(List<dynamic> list) => list
      .map<User>((dynamic p) => User.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
