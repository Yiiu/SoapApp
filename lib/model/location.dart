import 'package:json_annotation/json_annotation.dart';

part 'location.g.dart';

@JsonSerializable()
class Location {
  Location({
    required this.uid,
    required this.name,
    this.address,
    this.province,
    this.city,
    this.area,
    this.location,
    this.detail,
  });

  final String uid, name;
  final String? address, province, city, area;
  final Map? location, detail;
}
