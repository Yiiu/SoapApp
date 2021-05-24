import 'package:json_annotation/json_annotation.dart';

part 'badge.g.dart';

@JsonSerializable()
class Badge {
  Badge({
    required this.id,
    this.type,
    this.name,
    this.rate,
  });
  final int id;
  final String? type;
  final String? name;
  final String? rate;

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);
  Map<String, dynamic> toJson() => _$BadgeToJson(this);
}
