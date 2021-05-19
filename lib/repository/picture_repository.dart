import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/mutations.dart' as mutations;
import 'package:soap_app/store/index.dart';

class PictureRepository {
  Future<void> liked(int id) async {
    final Map<String, int> variables = {
      'id': id,
    };
    final QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.likePicture, [
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
        document: addFragments(mutations.unLikePicture, [
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

  Future<void> updatePicture(
    int id, {
    required String title,
    required String bio,
    required bool isPrivate,
    required List<String> tags,
  }) async {
    final Map<String, Object> variables = {
      'id': id,
      'data': {
        'title': title,
        'bio': bio,
        'isPrivate': isPrivate,
        'tags': tags,
      }
    };
    final QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.updatePicture, [
          updatePictureFragment,
          pictureBaseFragment,
          tagFragment,
        ]),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['updatePicture'] != null) {
            final Map<String, dynamic> newData =
                result!.data!['updatePicture']! as Map<String, dynamic>;
            final Map<String, Object?> updated = {
              'id': id,
              'title': newData['title']! as String,
              'bio': newData['bio']! as String?,
              'tags': newData['tags']! as List,
              'isPrivate': newData['isPrivate']! as bool,
              '__typename': 'Picture'
            };
            final Map<String, Object?> idFields = {
              'id': updated['id'],
              '__typename': updated['__typename'],
            };
            cache.writeFragment(
              Fragment(
                document: gql(r'''
                    fragment PictureFragment on Picture {
                      title
                      bio
                      isPrivate
                      tags
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

  Future<void> deletePicture(int id) async {
    final Map<String, Object> variables = {
      'id': id,
    };
    await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.deletePicture, []),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['deletePicture'] != null &&
              result!.data!['deletePicture']['done'] as bool) {
            pictureCachedStore.addDeleteId(id);
          }
          // print(res)
        },
      ),
    );
  }
}
