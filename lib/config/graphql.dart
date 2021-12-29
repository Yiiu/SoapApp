import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../store/index.dart';

class GraphqlConfig {
  static HttpLink httpLink = HttpLink(
    '${dotenv.env['API_URL']}/graphql',
    defaultHeaders: <String, String>{
      'accept': 'application/json',
    },
  );

  static AuthLink authLink = AuthLink(
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
