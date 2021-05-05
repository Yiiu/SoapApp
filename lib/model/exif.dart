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
  String? date;
  String? software;
  List<double>? location;
  String? make;
  String? model;
  double? focalLength;
  double? aperture;
  String? exposureTime;
  int? ISO;
  // String? lensModel;
  // String? whiteBalance;
}
