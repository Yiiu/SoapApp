import 'package:json_annotation/json_annotation.dart';

part 'exif.g.dart';

@JsonSerializable()
class Exif {
  Exif({
    // this.orientation,
    // this.meteringMode,
    // this.exposureMode,
    // this.exposureBias,
    this.date,
    this.software,
    this.location,
    this.make,
    this.model,
    this.focalLength,
    this.aperture,
    this.exposureTime,
    // ignore: non_constant_identifier_names
    this.ISO,
    // this.lensModel,
    // this.whiteBalance,
  });

  factory Exif.fromJson(Map<String, dynamic> json) => _$ExifFromJson(json);
  Map<String, dynamic> toJson() => _$ExifToJson(this);
  // int? orientation;
  // int? meteringMode;
  // int? exposureMode;
  // int? exposureBias;
  final String? date;
  final String? software;
  final List<double>? location;
  final String? make;
  final String? model;
  final double? focalLength;
  final double? aperture;
  final String? exposureTime;
  // ignore: non_constant_identifier_names
  final int? ISO;
  // String? lensModel;
  // String? whiteBalance;
}
