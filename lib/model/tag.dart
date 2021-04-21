import 'package:json_annotation/json_annotation.dart';

part 'tag.g.dart';

@JsonSerializable()
class Tag {
  Tag({
    required this.id,
    required this.name,
    required this.pictureCount,
  });

  factory Tag.fromJson(Map<String, dynamic> json) => _$TagFromJson(json);

  int id;
  String name;
  int pictureCount;

  static List<Tag> fromListJson(List<dynamic> list) => list
      .map<Tag>((dynamic p) => Tag.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$TagToJson(this);
}
