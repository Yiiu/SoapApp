import 'package:graphql_flutter/graphql_flutter.dart';
import '../config/graphql.dart';
import '../graphql/fragments.dart';
import '../graphql/gql.dart';
import '../graphql/mutations.dart' as mutations;
import '../graphql/query.dart' as query;

class CommentRepository {
  Future<void> addComment({
    required int id,
    required String content,
    int? commentId,
  }) async {
    final Map<String, Object?> variables = {
      'id': id,
      'data': {
        'content': content,
      }
    };
    if (commentId != null) {
      variables['commentId'] = commentId;
    }
    await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.addComment, [
          ...commentFragmentDocumentNode,
        ]),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['addComment'] != null) {
            result?.data?['addComment']['childComments'] =
                List<dynamic>.empty();
            final Map<String, int> variables = {'id': id};
            final Request queryRequest = Request(
              operation: Operation(
                document: addFragments(
                  query.comments,
                  [...commentListFragmentDocumentNode],
                ),
              ),
              variables: variables,
            );

            final Map<String, dynamic>? data = cache.readQuery(queryRequest);
            if (data?['comments'] != null) {
              data!['comments']['count']++;
              (data['comments']['data'] as List).insert(
                0,
                result!.data!['addComment'],
              );
              cache.writeQuery(queryRequest, data: data);
            }
          }
        },
      ),
    );
  }
}
