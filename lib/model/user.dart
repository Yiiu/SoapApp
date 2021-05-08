import 'package:json_annotation/json_annotation.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/picture.dart';

// import '../utils/picture.dart';

part 'user.g.dart';

@JsonSerializable()
class User {
  User({
    required this.id,
    required this.username,
    required this.fullName,
    this.name,
    this.email,
    required this.avatar,
    this.bio,
    this.website,
    this.cover,
    required this.createTime,
    required this.updateTime,
    this.pictures,
  })  : likedCount = 0,
        likesCount = 0,
        pictureCount = 0,
        followerCount = 0,
        followedCount = 0,
        isFollowing = false;

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final int id;
  final String username;
  final String fullName;
  final String? name;
  final String? email;
  final String avatar;
  final String? bio;
  final String? website;
  final String? cover;
  final int? likedCount;
  final int? likesCount;
  final int? pictureCount;
  final int? followerCount;
  final int? followedCount;
  final DateTime createTime;
  final DateTime updateTime;
  final List<Picture>? pictures;
  final bool? isFollowing;

  String get avatarUrl {
    return getPictureUrl(key: avatar, style: PictureStyle.itemprop);
  }

  static List<User> fromListJson(List<dynamic> list) => list
      .map<User>((dynamic p) => User.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
