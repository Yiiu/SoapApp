import 'package:mobx/mobx.dart';

part 'handle_store.g.dart';

class HandleStore = _HandleStoreBase with _$HandleStore;

abstract class _HandleStoreBase with Store {
  @observable
  bool isComment = false;

  @observable
  String comment = 'sss';

  @action
  void openComment() {
    isComment = true;
  }

  @action
  void closeComment() {
    isComment = false;
  }

  @action
  void setComment(String value) {
    comment = value;
  }
}
