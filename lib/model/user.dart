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
    required this.avatar,
    required this.createTime,
    required this.updateTime,
    this.name,
    this.email,
    this.bio,
    this.website,
    this.cover,
    this.pictures,
    this.isFollowing = 0,
    this.likedCount = 0,
    this.likesCount = 0,
    this.pictureCount = 0,
    this.followerCount = 0,
    this.followedCount = 0,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  int id;
  String username, fullName, avatar;
  String? name, email, bio, website, cover;
  int? likedCount,
      likesCount,
      pictureCount,
      followerCount,
      followedCount,
      isFollowing;
  DateTime createTime, updateTime;
  List<Picture>? pictures;

  String get avatarUrl {
    return getPictureUrl(key: avatar, style: PictureStyle.itemprop);
  }

  static List<User> fromListJson(List<dynamic> list) => list
      .map<User>((dynamic p) => User.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
