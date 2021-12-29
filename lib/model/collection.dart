import 'package:json_annotation/json_annotation.dart';
import 'picture.dart';
import 'user.dart';

part 'collection.g.dart';

@JsonSerializable()
class Collection {
  Collection({
    required this.id,
    required this.name,
    required this.createTime,
    required this.updateTime,
    this.user,
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

  final int id;
  final String name;
  final String? bio;
  final bool? isPrivate;
  final DateTime createTime, updateTime;
  final int? pictureCount;
  final List<Picture>? preview;
  final User? user;
}
