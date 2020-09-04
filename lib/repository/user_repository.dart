import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/query/user.dart';

mixin UserRepository {
  static GraphQLClient client = GraphqlConfig.graphQLClient;

  static Future<QueryResult> whoami() async {
    final QueryOptions _options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: UserQueries.whoami,
    );

    return client.query(_options);
  }

  static Future<QueryResult> user(String username) async {
    final Map<String, String> query = {'username': username};
    final QueryOptions _options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: UserQueries.user,
      variables: query,
    );

    return client.query(_options);
  }
}
