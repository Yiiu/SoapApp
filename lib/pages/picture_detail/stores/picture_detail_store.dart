import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:mobx/mobx.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/model/picture.dart';

part 'picture_detail_store.g.dart';

class PictureDetailPageStore = _PictureDetailPageStoreBase
    with _$PictureDetailPageStore;

abstract class _PictureDetailPageStoreBase with Store {
  graphql.ObservableQuery? _observableQuery;

  Map<String, int?> get variables {
    return {
      'id': picture?.id,
    };
  }

  DocumentNode document = addFragments(
    query.picture,
    [...pictureDetailFragmentDocumentNode],
  );

  @observable
  Picture? picture;

  @action
  void init(Picture data) {
    if (!setQueryCache(data.id)) {
      picture = data;
    }
  }

  @action
  bool setQueryCache(int id) {
    final Map<String, int?> variables2 = {
      'id': id,
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
      picture = Picture.fromJson(data['picture'] as Map<String, dynamic>);
      return true;
    }
    return false;
  }

  void watchQuery() async {
    // 和导航过渡动画错开来
    await Future<void>.delayed(const Duration(milliseconds: 350));
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
          print(result.exception);
          return;
        }
        if (result.isLoading) {
          print('loading');
          return;
        }
        setPicture(result.data!['picture'] as Map<String, dynamic>?);
      }
    });
  }

  @action
  void setPicture(Map<String, dynamic>? data) {
    if (data != null) {
      picture = Picture.fromJson(data);
    }
  }

  void close() {
    _observableQuery?.close();
  }
}
