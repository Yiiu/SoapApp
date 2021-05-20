import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/mutations.dart' as mutations;
import 'package:soap_app/graphql/query.dart' as query;
import 'package:soap_app/store/index.dart';

class PictureRepository {
  void _updatedCurrentCollection(
    GraphQLDataProxy cache, {
    required int pictureId,
    dynamic data,
    int? id,
  }) {
    final Map<String, int> variables = {'id': pictureId};
    final Request queryRequest = Request(
      operation: Operation(
        document: addFragments(
          query.picture,
          [...pictureDetailFragmentDocumentNode],
        ),
      ),
      variables: variables,
    );
    print(pictureId);
    final Map<String, dynamic>? pictureData = cache.readQuery(queryRequest);
    if (pictureData != null && pictureData['picture'] != null) {
      List<dynamic> list;
      if (pictureData['picture']['currentCollections'] == null) {
        list = <dynamic>[];
        pictureData['picture']['currentCollections'] = List<dynamic>.empty();
      } else {
        list = <dynamic>[...pictureData['picture']['currentCollections']];
      }
      if (data == null && id != null) {
        list = list.where((dynamic e) => e['id'] != id).toList();
      } else {
        list.add(data);
      }
      print(list);
      final Map<String, Object?> idFields = {
        'id': pictureId,
      };
      cache.writeFragment(
        Fragment(
          document: gql(r'''
            fragment PictureDetailFragment on Picture {
              currentCollections
            }
          '''),
        ).asRequest(idFields: idFields),
        data: <String, dynamic>{
          'currentCollections': list,
        },
      );
    }
  }

  void _updateLikePicture(
    GraphQLDataProxy cache, {
    required int id,
    required int count,
    required bool isLike,
  }) {
    final Map<String, Object> updated = {
      'likedCount': count,
      'id': id,
      'isLike': isLike,
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
            _updateLikePicture(
              cache,
              count: result?.data!['likePicture']['count'] as int,
              id: id,
              isLike: result?.data!['likePicture']['isLike'] as bool,
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
            _updateLikePicture(
              cache,
              id: id,
              count: result?.data!['unlikePicture']['count'] as int,
              isLike: result?.data!['unlikePicture']['isLike'] as bool,
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

  Future<void> removePictureCollection(int id, int pictureId) async {
    final Map<String, Object> variables = {
      'id': id,
      'pictureId': pictureId,
    };
    await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.removePictureCollection, []),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['removePictureCollection'] != null &&
              result!.data!['removePictureCollection']['done'] as bool) {
            _updatedCurrentCollection(
              cache,
              pictureId: pictureId,
              id: id,
            );
          }
          // print(res)
        },
      ),
    );
  }

  Future<void> addPictureCollection(int id, int pictureId) async {
    final Map<String, Object> variables = {
      'id': id,
      'pictureId': pictureId,
    };
    await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document:
            addFragments(mutations.addPictureCollection, [collectionFragment]),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['addPictureCollection'] != null) {
            _updatedCurrentCollection(
              cache,
              pictureId: pictureId,
              data: result!.data!['addPictureCollection'],
            );
          }
        },
      ),
    );
  }
}
