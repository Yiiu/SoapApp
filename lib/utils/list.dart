import 'package:soap_app/model/picture.dart';
import 'package:soap_app/store/index.dart';

class ListData<E> {
  const ListData({
    required this.page,
    required this.pageSize,
    required this.list,
    required this.count,
  });

  final int page;
  final int pageSize;
  final int count;
  final List<E> list;

  int get morePage {
    return (count / pageSize).ceil();
  }

  bool get noMore {
    return page + 1 >= morePage;
  }
}

ListData<Picture> pictureListDataFormat(
  Map<String, dynamic> data, {
  required String label,
}) {
  final List repositories = data[label]['data'] as List;
  final int page = data[label]['page'] as int;
  final int pageSize = data[label]['pageSize'] as int;
  final int count = data[label]['count'] as int;
  final List<Picture> list = Picture.fromListJson(repositories)
      .where((Picture picture) =>
          !pictureCachedStore.deleteIds.contains(picture.id))
      .toList();
  return ListData<Picture>(
    count: count,
    pageSize: pageSize,
    page: page,
    list: list,
  );
}
