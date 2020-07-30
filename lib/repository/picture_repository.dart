import 'package:graphql/internal.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/query/picture.dart';
import 'package:soap_app/model/picture.dart';

class PictureRepository {
  GraphQLClient client = GraphqlConfig.graphQLClient;

  Future<QueryResult> getPictureList({
    String type = 'NEW',
    int page = 1,
  }) async {
    final QueryOptions _options = QueryOptions(
      documentNode: PictureQueries.pictures,
      pollInterval: 100,
      variables: {
        'type': type,
        'query': {
          'page': page,
          'pageSize': 5,
        }
      } as Map<String, dynamic>,
    );

    return client.query(_options);
  }
}
