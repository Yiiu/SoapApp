import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/graphql/query/picture.dart';

class PictureRepository {
  PictureRepository({
    @required this.client,
  }) : assert(client != null);

  final GraphQLClient client;

  Future<QueryResult> getPictureList() async {
    final QueryOptions _options = QueryOptions(
      documentNode: gql(pictures),
    );
    return await client.query(_options);
  }
}
