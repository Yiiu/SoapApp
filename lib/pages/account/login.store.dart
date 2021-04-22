import 'package:mobx/mobx.dart';
import 'package:validators/validators.dart';

part 'login.store.g.dart';

class LoginStore = _LoginStoreBase with _$LoginStore;

abstract class _LoginStoreBase with Store {
  final FormErrorState error = FormErrorState();

  late List<ReactionDisposer> _disposers;

  @observable
  String username = '';

  @observable
  String password = '';

  void setupValidations() {
    _disposers = <ReactionDisposer>[
      reaction((_) => username, validateUsername),
      reaction((_) => password, validatePassword)
    ];
  }

  void dispose() {
    for (final ReactionDisposer d in _disposers) {
      d();
    }
  }

  @action
  void setUsername(String value) {
    username = value;
  }

  @action
  void setPassword(String value) {
    password = value;
  }

  @action
  void validatePassword(String value) {
    error.password = isNull(value) || value.isEmpty ? '请输入密码' : null;
  }

  @action
  void validateUsername(String value) {
    error.username = isNull(value) || value.isEmpty ? '请输入用户名' : null;
  }
}

class FormErrorState = _FormErrorState with _$FormErrorState;

abstract class _FormErrorState with Store {
  @observable
  String? username;

  @observable
  String? password;

  @computed
  bool get hasErrors => username != null || password != null;
}
