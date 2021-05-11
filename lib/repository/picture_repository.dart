import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/mutations.dart';

class PictureRepository {
  Future<void> liked(int id) async {
    final Map<String, int> variables = {
      'id': id,
    };
    final QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(likePicture, [
          pictureLikeFragment,
        ]),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['likePicture'] != null) {
            final Map<String, Object> updated = {
              'likedCount': result?.data!['likePicture']['count'] as int,
              'id': id,
              'isLike': result?.data!['likePicture']['isLike'] as bool,
              '__typename': 'Picture'
            };
            final Map<String, Object?> idFields = {
              'id': updated['id'],
            };
            cache.writeFragment(
              Fragment(
                document: gql(r'''
                  fragment PictureFragment on Picture {
                    likedCount
                    isLike
                  }
                '''),
              ).asRequest(idFields: idFields),
              data: updated,
            );
          }
        },
      ),
    );
  }

  Future<void> unLike(int id) async {
    final Map<String, int> variables = {
      'id': id,
    };
    final QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(unLikePicture, [
          pictureLikeFragment,
        ]),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['unlikePicture'] != null) {
            final Map<String, Object> updated = {
              'likedCount': result?.data!['unlikePicture']['count'] as int,
              'id': id,
              'isLike': result?.data!['unlikePicture']['isLike'] as bool,
              '__typename': 'Picture'
            };
            final Map<String, Object?> idFields = {
              'id': updated['id'],
            };
            cache.writeFragment(
              Fragment(
                document: gql(r'''
                  fragment PictureFragment on Picture {
                    likedCount
                    isLike
                  }
                '''),
              ).asRequest(idFields: idFields),
              data: updated,
            );
          }
        },
      ),
    );
  }
}
