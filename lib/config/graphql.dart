import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/store/index.dart';

class GraphqlConfig {
  static HttpLink httpLink = HttpLink(
    'https://soapphoto.com/graphql',
    defaultHeaders: {
      'accept': 'application/json',
    },
  );

  static AuthLink authLink = AuthLink(
    headerKey: 'Authorization',
    getToken: () async {
      if (accountStore.accessToken != null) {
        return 'Bearer ${accountStore.accessToken}';
      }
      return '';
    },
  );

  static GraphQLClient graphQLClient = GraphQLClient(
    link: authLink.concat(httpLink),
    cache: GraphQLCache(store: HiveStore()),
  );

  static ValueNotifier<GraphQLClient> client = ValueNotifier<GraphQLClient>(
    graphQLClient,
  );

  GraphQLClient clientToQuery() {
    return GraphQLClient(
      cache: GraphQLCache(store: HiveStore()),
      link: httpLink,
    );
  }
}
