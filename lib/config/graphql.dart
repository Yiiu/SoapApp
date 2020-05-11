import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class GraphqlConfig {
  static HttpLink httpLink = HttpLink(uri: 'https://soapphoto.com/graphql');

  static GraphQLClient graphQLClient = GraphQLClient(
    link: httpLink,
    cache: NormalizedInMemoryCache(
      dataIdFromObject: typenameDataIdFromObject,
    ),
  );

  static ValueNotifier<GraphQLClient> client = ValueNotifier(
    graphQLClient,
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: NormalizedInMemoryCache(
        dataIdFromObject: typenameDataIdFromObject,
      ),
      link: httpLink,
    );
  }
}
