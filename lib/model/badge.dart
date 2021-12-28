import 'package:json_annotation/json_annotation.dart';

part 'badge.g.dart';

@JsonSerializable()
class Badge {
  Badge({
    this.type,
    this.name,
    this.rate,
    required this.id,
  });

  factory Badge.fromJson(Map<String, dynamic> json) => _$BadgeFromJson(json);

  final int id;
  final String? type;
  final String? name;
  final String? rate;

  Map<String, dynamic> toJson() => _$BadgeToJson(this);
}
