import 'package:graphql_flutter/graphql_flutter.dart' as graphql;
import 'package:mobx/mobx.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/graphql/query.dart' as query;

part 'picture_detail_store.g.dart';

class PictureDetailPageStore = _PictureDetailPageStoreBase
    with _$PictureDetailPageStore;

abstract class _PictureDetailPageStoreBase with Store {
  @observable
  Picture? picture;

  graphql.ObservableQuery? _observableQuery;

  @action
  void init(Picture data) {
    picture = data;
  }

  void watchQuery() async {
    final Map<String, int> variables = {
      'id': picture!.id,
    };
    await Future<void>.delayed(Duration(milliseconds: 500));
    _observableQuery = GraphqlConfig.graphQLClient.watchQuery(
      graphql.WatchQueryOptions(
        document: addFragments(
          query.picture,
          [...pictureDetailFragmentDocumentNode],
        ),
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
