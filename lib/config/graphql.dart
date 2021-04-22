import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';

class GraphqlConfig {
  static HttpLink httpLink = HttpLink(
    'https://soapphoto.com/graphql',
  );

  static GraphQLClient graphQLClient = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: HiveStore()),
  );

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    graphQLClient,
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: httpLink,
    );
  }
}
