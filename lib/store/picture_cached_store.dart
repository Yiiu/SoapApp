import 'package:mobx/mobx.dart';
import 'package:soap_app/utils/storage.dart';
part 'picture_cached_store.g.dart';

class PictureCachedStore = _PictureCachedStoreBase with _$PictureCachedStore;

// 用来记录本地删除的那些图片，然后过滤掉
abstract class _PictureCachedStoreBase with Store {
  late ReactionDisposer _dispose;

  @observable
  List<int> deleteIds = ObservableList<int>();

  @observable
  List<int> privateIds = ObservableList<int>();

  @action
  Future<void> initialize() async {
    final List<String>? deleteCached =
        StorageUtil.preferences!.getStringList('pictureCached.deleteIds');
    final List<String>? privateCached =
        StorageUtil.preferences!.getStringList('pictureCached.deleteIds');
    if (deleteCached != null && deleteCached.isNotEmpty) {
      deleteIds = deleteCached.map<int>((String e) => int.parse(e)).toList();
    }
    if (privateCached != null && privateCached.isNotEmpty) {
      privateIds = privateCached.map<int>((String e) => int.parse(e)).toList();
    }
    autoruns();
  }

  void autoruns() {
    _dispose = autorun((_) {
      StorageUtil.preferences!.setStringList(
        'pictureCached.deleteIds',
        deleteIds.map((e) => e.toString()).toList(),
      );
      StorageUtil.preferences!.setStringList(
        'pictureCached.privateIds',
        privateIds.map((e) => e.toString()).toList(),
      );
    });
  }

  @action
  void addDeleteId(int id) {
    deleteIds.add(id);
  }

  @action
  void addPrivateId(int id) {
    privateIds.add(id);
  }
}
