import 'package:mobx/mobx.dart';
import '../../../model/tag.dart';

import '../../../model/location.dart';
import '../../../model/picture.dart';
import '../../../repository/picture_repository.dart';

part 'add_store.g.dart';

class AddStore = _AddStoreBase with _$AddStore;

abstract class _AddStoreBase with Store {
  final PictureRepository pictureRepository = PictureRepository();

  @observable
  bool isPrivate = false;

  @observable
  bool loading = false;

  @observable
  List<String> tags = ObservableList<String>();

  @observable
  Location? location;

  @action
  void setPrivate(bool value) => isPrivate = value;

  @action
  void setLoading(bool value) => loading = value;

  @action
  void setTags(List<String> value) => tags = value;

  @action
  void setLocation(Location? value) => location = value;

  @action
  void editInit(Picture picture) {
    isPrivate = picture.isPrivate ?? false;
    tags = picture.tags!.map<String>((Tag e) => e.name).toList();
    location = picture.location;
  }

  Future<void> update(
    int id,
    String title,
    String bio,
  ) async {
    await pictureRepository.updatePicture(
      id,
      title: title,
      bio: bio,
      isPrivate: isPrivate,
      tags: tags,
      location: location,
    );
  }
}
