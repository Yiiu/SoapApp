import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

FetchMoreOptions listFetchMoreOptions({
  DocumentNode? document,
  required Map<String, dynamic> variables,
  required String label,
}) {
  final FetchMoreOptions opts = FetchMoreOptions(
    variables: variables,
    document: document,
    updateQuery: (Map<String, dynamic>? previousResultData,
        Map<String, dynamic>? fetchMoreResultData) {
      final List<dynamic> repos = <dynamic>[
        ...previousResultData![label]['data'] as List<dynamic>,
        ...fetchMoreResultData![label]['data'] as List<dynamic>
      ];
      fetchMoreResultData[label]['data'] = repos;

      return fetchMoreResultData;
    },
  );
  return opts;
}
