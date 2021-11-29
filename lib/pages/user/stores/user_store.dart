import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:mobx/mobx.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/store/index.dart';

part 'user_store.g.dart';

class UserPageStore = _UserPageStoreBase with _$UserPageStore;

abstract class _UserPageStoreBase with Store {
  graphql.ObservableQuery? _observableQuery;

  Map<String, String?> get variables {
    return {
      'username': user?.username,
    };
  }

  DocumentNode document = addFragments(
    userInfo,
    [...userDetailFragmentDocumentNode],
  );

  @observable
  User? user;

  @computed
  bool get isOwner {
    if (accountStore.isLogin &&
        accountStore.userInfo?.username == user?.username) {
      return true;
    }
    return false;
  }

  @action
  void init(User data) {
    if (!setQueryCache(data.username)) {
      user = data;
    }
  }

  @action
  bool setQueryCache(String username) {
    final Map<String, String> variables2 = {
      'username': username,
    };
    final graphql.Request queryRequest = graphql.Request(
      operation: graphql.Operation(
        document: document,
      ),
      variables: variables2,
    );
    final Map<String, dynamic>? data =
        GraphqlConfig.graphQLClient.readQuery(queryRequest);
    if (data != null) {
      user = User.fromJson(data['user'] as Map<String, dynamic>);
      return true;
    }
    return false;
  }

  void watchQuery() async {
    // 和导航过渡动画错开来
    await Future<void>.delayed(Duration(milliseconds: screenDelayTimer));
    _observableQuery = GraphqlConfig.graphQLClient.watchQuery(
      graphql.WatchQueryOptions(
        document: document,
        fetchResults: true,
        fetchPolicy: graphql.FetchPolicy.networkOnly,
        variables: variables,
      ),
    );
    _observableQuery!.stream.listen((graphql.QueryResult result) {
      if (!result.isLoading && result.data != null) {
        if (result.hasException) {
          return;
        }
        if (result.isLoading) {
          return;
        }
        setUser(result.data!['user'] as Map<String, dynamic>?);
      }
    });
  }

  @action
  void setUser(Map<String, dynamic>? data) {
    if (data != null) {
      user = User.fromJson(data);
    }
  }

  void close() {
    _observableQuery?.close();
  }
}
