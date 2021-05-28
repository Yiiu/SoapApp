import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/store/index.dart';

class GraphqlConfig {
  static HttpLink httpLink = HttpLink(
    '${env['API_URL']}/graphql',
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
    defaultPolicies: DefaultPolicies(
      watchMutation: Policies(
        fetch: FetchPolicy.networkOnly,
        error: ErrorPolicy.none,
        cacheReread: CacheRereadPolicy.mergeOptimistic,
      ),
      mutate: Policies(
        fetch: FetchPolicy.networkOnly,
        error: ErrorPolicy.none,
        cacheReread: CacheRereadPolicy.mergeOptimistic,
      ),
      query: Policies(
        fetch: FetchPolicy.cacheFirst,
        error: ErrorPolicy.none,
        cacheReread: CacheRereadPolicy.mergeOptimistic,
      ),
      watchQuery: Policies(
        fetch: FetchPolicy.cacheFirst,
        error: ErrorPolicy.none,
        cacheReread: CacheRereadPolicy.mergeOptimistic,
      ),
    ),
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
