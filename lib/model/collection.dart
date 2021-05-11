import 'package:json_annotation/json_annotation.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/user.dart';

part 'collection.g.dart';

@JsonSerializable()
class Collection {
  Collection({
    required this.id,
    required this.name,
    required this.createTime,
    required this.updateTime,
    required this.user,
    this.bio,
    this.isPrivate,
    this.pictureCount = 0,
    this.preview,
  });

  factory Collection.fromJson(Map<String, dynamic> json) =>
      _$CollectionFromJson(json);

  Map<String, dynamic> toJson() => _$CollectionToJson(this);

  static List<Collection> fromListJson(List<dynamic> list) => list
      .map<Collection>(
          (dynamic p) => Collection.fromJson(p as Map<String, dynamic>))
      .toList();

  int id;
  String name;
  String? bio;
  bool? isPrivate;
  DateTime createTime, updateTime;
  int? pictureCount;
  List<Picture>? preview;
  User user;
}
