import 'dart:math';

import 'package:json_annotation/json_annotation.dart';
import 'package:mobx/mobx.dart';

import '../utils/picture.dart';
import 'badge.dart';
import 'collection.dart';
import 'exif.dart';
import 'location.dart';
import 'tag.dart';
import 'user.dart';

part 'picture.g.dart';

@JsonSerializable()
class Picture extends _Picture with _$Picture {
  Picture(
    int id,
    String key,
    String title,
    String blurhash,
    String color,
    String? hash,
    String? originalname,
    String? mimetype,
    String? make,
    String? model,
    String? bio,
    int views,
    int size,
    int height,
    int width,
    int? likedCount,
    int? commentCount,
    bool? isLike,
    bool? isPrivate,
    bool isDark,
    DateTime createTime,
    DateTime updateTime,
    User? user,
    List<Collection>? currentCollections,
    List<Tag>? tags,
    Exif? exif,
    List<Badge>? badge,
    Location? location,
    List<Map>? classify,
  ) : super(
          id,
          key,
          title,
          blurhash,
          color,
          hash,
          originalname,
          mimetype,
          make,
          model,
          bio,
          views,
          size,
          height,
          width,
          likedCount,
          commentCount,
          isLike,
          isPrivate,
          isDark,
          createTime,
          updateTime,
          user,
          currentCollections,
          tags,
          exif,
          badge,
          location,
          classify,
        );

  factory Picture.fromJson(Map<String, dynamic> json) =>
      _$PictureFromJson(json);

  static List<Picture> fromListJson(List<dynamic> list) => list
      .map<Picture>((dynamic p) => Picture.fromJson(p as Map<String, dynamic>))
      .toList();
  Map<String, dynamic> toJson() => _$PictureToJson(this);
}

abstract class _Picture with Store {
  _Picture(
    this.id,
    this.key,
    this.title,
    this.blurhash,
    this.color,
    this.hash,
    this.originalname,
    this.mimetype,
    this.make,
    this.model,
    this.bio,
    this.views,
    this.size,
    this.height,
    this.width,
    this.likedCount,
    this.commentCount,
    this.isLike,
    this.isPrivate,
    this.isDark,
    this.createTime,
    this.updateTime,
    this.user,
    this.currentCollections,
    this.tags,
    this.exif,
    this.badge,
    this.location,
    this.classify,
  );

  @observable
  int id;

  @observable
  String key;

  @observable
  String title;

  @observable
  String blurhash;

  @observable
  String color;

  @observable
  String? hash;

  @observable
  String? originalname;

  @observable
  String? mimetype;

  @observable
  String? make;

  @observable
  String? model;

  @observable
  String? bio;

  @observable
  int views;

  @observable
  int size;

  @observable
  int height;

  @observable
  int width;

  @observable
  int? commentCount = 0;

  @observable
  int? likedCount = 0;

  @observable
  bool? isLike = false;

  @observable
  bool? isPrivate;

  @observable
  bool isDark;

  @observable
  DateTime createTime;

  @observable
  DateTime updateTime;

  @observable
  User? user;

  @observable
  List<Collection>? currentCollections;

  @observable
  List<Tag>? tags;

  @observable
  Exif? exif;

  @observable
  List<Badge>? badge;

  @observable
  Location? location;

  @observable
  List<Map>? classify;

  bool get isChoice {
    if (badge != null &&
        badge!.indexWhere((Badge e) => e.name == 'choice') != -1) return true;
    return false;
  }

  String get sizeStr {
    // ignore: always_put_control_body_on_new_line
    if (size <= 0) return '0 B';
    const List<String> suffixes = [
      'B',
      'KB',
      'MB',
      'GB',
      'TB',
      'PB',
      'EB',
      'ZB',
      'YB'
    ];
    final int i = (log(size) / log(1024)).floor();
    return '${(size / pow(1024, i)).toStringAsFixed(2)} ${suffixes[i]}';
  }

  String pictureUrl({PictureStyle? style}) {
    if (RegExp('^photo\/').hasMatch(key)) {
      return getPictureUrl(key: key, style: style);
    }
    return getPictureUrl(key: 'photo/' + key, style: style);
  }
}

class ObservablePictureListConverter extends JsonConverter<
    ObservableList<Picture>, Iterable<Map<String, dynamic>>> {
  const ObservablePictureListConverter();

  @override
  ObservableList<Picture> fromJson(Iterable<Map<String, dynamic>> json) =>
      ObservableList<Picture>.of(json.map(Picture.fromJson));

  @override
  Iterable<Map<String, dynamic>> toJson(ObservableList<Picture> object) =>
      object.map((Picture element) => element.toJson());
}
