import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

part 'location.g.dart';

@JsonSerializable()
class Location extends _Location with _$Location {
  Location(
    String uid,
    String name,
    String? address,
    String? province,
    String? city,
    String? area,
    Map? location,
    Map? detail,
  ) : super(
          uid,
          name,
          address,
          province,
          city,
          area,
          location,
          detail,
        );

  factory Location.fromJson(Map<String, dynamic> json) =>
      _$LocationFromJson(json);
  Map<String, dynamic> toJson() => _$LocationToJson(this);
}

abstract class _Location with Store {
  _Location(
    this.uid,
    this.name,
    this.address,
    this.province,
    this.city,
    this.area,
    this.location,
    this.detail,
  );

  @observable
  String uid;

  @observable
  String name;

  @observable
  String? address = '';

  @observable
  String? province = '';

  @observable
  String? city = '';

  @observable
  String? area = '';

  @observable
  Map? location;

  @observable
  Map? detail;
}
