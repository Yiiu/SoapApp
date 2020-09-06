import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:graphql/client.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/query/comment.dart';
import 'package:soap_app/model/pagination.dart';

mixin CommentRepository {
  static GraphQLClient client = GraphqlConfig.graphQLClient;

  static Future<QueryResult> comment(int id, Pagination query) async {
    final q = {
      'id': id,
      'query': query.toMap(),
    };
    final QueryOptions _options = QueryOptions(
      fetchPolicy: FetchPolicy.networkOnly,
      documentNode: CommentQueries.comments,
      variables: q,
    );

    return client.query(_options);
  }
}
