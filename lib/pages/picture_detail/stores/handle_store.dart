import 'package:mobx/mobx.dart';
import '../../../model/picture.dart';
import '../../../repository/comment_repository.dart';

part 'handle_store.g.dart';

class HandleStore = _HandleStoreBase with _$HandleStore;

abstract class _HandleStoreBase with Store {
  _HandleStoreBase({
    required this.picture,
  });
  Picture picture;

  final CommentRepository _commentRepository = CommentRepository();
  @observable
  bool isComment = false;

  @observable
  String comment = '';

  @action
  void openComment() {
    isComment = true;
  }

  @action
  void closeComment() {
    isComment = false;
  }

  Future<void> addComment() async {
    await _commentRepository.addComment(
      id: picture.id,
      content: comment,
    );
  }

  @action
  void setComment(String value) {
    comment = value;
  }
}
