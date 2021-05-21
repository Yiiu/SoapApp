import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/graphql/mutations.dart' as mutations;

class CollectionRepository {
  CollectionRepository();

  Future<void> add(dynamic data) async {
    final Map<String, Object?> variables = {
      'data': data,
    };
    final QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.addCollection, [
          ...collectionDetailFragmentDocumentNode,
        ]),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['addCollection'] != null) {
            final Map<String, String> variables = {
              'username': accountStore.userInfo!.username
            };
            final Request queryRequest = Request(
              operation: Operation(
                document: addFragments(
                  userCollectionsByName,
                  [...collectionListFragmentDocumentNode],
                ),
              ),
              variables: variables,
            );
            final Map<String, dynamic>? cacheData =
                cache.readQuery(queryRequest);
            if (cacheData?['userCollectionsByName'] != null) {
              cacheData!['userCollectionsByName']['count']++;
              (cacheData['userCollectionsByName']['data'] as List).insert(
                0,
                result?.data?['addCollection'],
              );
              cache.writeQuery(
                queryRequest,
                data: cacheData,
              );
            }
          }
        },
      ),
    );
  }

  Future<void> update(int id, dynamic data) async {
    final Map<String, Object?> variables = {
      'id': id,
      'data': data,
    };
    final QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.updateCollection, [
          ...collectionDetailFragmentDocumentNode,
        ]),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['updateCollection'] != null) {
            final Map<String, Object?> updated = {
              'name': result?.data?['updateCollection']!['name'],
              'bio': result?.data?['updateCollection']!['bio'],
              'isPrivate': result?.data?['updateCollection']!['isPrivate']
            };
            final Map<String, Object?> idFields = {
              'id': result?.data?['updateCollection']!['id'],
            };
            cache.writeFragment(
              Fragment(
                document: gql(
                  r'''
                    fragment CollectionFragment on Collection {
                      name
                      bio
                      isPrivate
                    }
                  ''',
                ),
              ).asRequest(idFields: idFields),
              data: updated,
            );
          }
        },
      ),
    );
  }

  Future<void> delete(int id) async {
    final Map<String, Object> variables = {
      'id': id,
    };
    await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.deleteCollection, []),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['deleteCollection'] != null &&
              result!.data!['deleteCollection']['done'] as bool) {
            // print('tst');
            // pictureCachedStore.addDeleteId(id);
          }
          // print(res)
        },
      ),
    );
  }
}
