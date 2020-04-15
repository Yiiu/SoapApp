import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/query/picture.dart';

class PictureRepository {
  GraphQLClient client = GraphqlConfig.graphQLClient;

  Future<QueryResult> getPictureList() async {
    final QueryOptions _options = WatchQueryOptions(
      documentNode: gql(pictures),
      pollInterval: 10,
      variables: {
        'type': "NEW",
        'query': {
          'page': 1,
          'pageSize': 5,
        }
      },
    );
    return await client.query(_options);
  }
}
