import 'package:mobx/mobx.dart';

part 'add_store.g.dart';

class AddStore = _AddStoreBase with _$AddStore;

abstract class _AddStoreBase with Store {
  @observable
  bool isPrivate = false;

  @observable
  bool loading = false;

  @observable
  List<String> tags = ObservableList<String>();

  @action
  void setPrivate(bool value) => isPrivate = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setTags(List<String> value) => tags = value;
}
