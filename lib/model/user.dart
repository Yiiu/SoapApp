import 'package:json_annotation/json_annotation.dart';
import 'package:soap_app/model/badge.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/utils/date.dart' as date;
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
    required this.gender,
    this.genderSecret,
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
    this.badge,
    this.birthday,
    this.birthdayShow,
  });

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  final int id;
  final String username, fullName, avatar;
  final String? name, email, bio, website, cover;
  final int gender;
  final bool? genderSecret;
  final String? birthday;
  final int? birthdayShow;
  final int? likedCount,
      likesCount,
      pictureCount,
      followerCount,
      followedCount,
      isFollowing;
  final DateTime createTime, updateTime;
  final List<Picture>? pictures;
  final List<Badge>? badge;

  String get avatarUrl {
    return getPictureUrl(key: avatar, style: PictureStyle.avatarSmall);
  }

  bool get isVip {
    if (badge != null && badge!.indexWhere((e) => e.name == 'prestige') != -1) {
      return true;
    }
    return false;
  }

  String get genderString {
    if (gender == -1) {
      return '不详';
    }
    return gender == 0 ? '男' : '女';
  }

  String? get constellation {
    if (birthday == null) {
      return null;
    }
    return date.getConstellation(birthday!);
  }

  static List<User> fromListJson(List<dynamic> list) => list
      .map<User>((dynamic p) => User.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$UserToJson(this);
}
