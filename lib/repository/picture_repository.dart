import 'package:graphql_flutter/graphql_flutter.dart';
import '../config/graphql.dart';
import '../graphql/fragments.dart';
import '../graphql/gql.dart';
import '../graphql/mutations.dart' as mutations;
import '../graphql/query.dart' as query;
import '../model/location.dart';
import '../store/index.dart';
import '../utils/exception.dart';

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

  Future<QueryResult> liked(int id) async {
    final Map<String, int> variables = {
      'id': id,
    };
    final QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.likePicture, [
          pictureFragment,
          pictureBaseFragment,
        ]),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {},
      ),
    );
    if (result.hasException) {
      captureException(result.exception);
    }
    return result;
  }

  Future<QueryResult> unLike(int id) async {
    final Map<String, int> variables = {
      'id': id,
    };
    final QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.unLikePicture, [
          pictureFragment,
          pictureBaseFragment,
        ]),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {},
      ),
    );
    if (result.hasException) {
      captureException(result.exception);
    }
    return result;
  }

  Future<QueryResult> updatePicture(
    int id, {
    required String title,
    required String bio,
    required bool isPrivate,
    required List<String> tags,
    Location? location,
  }) async {
    final Map<String, dynamic> variables = <String, dynamic>{
      'id': id,
      'data': <String, dynamic>{
        'title': title,
        'bio': bio,
        'isPrivate': isPrivate,
        'tags': tags,
        'locationUid': location?.uid,
      }
    };
    final QueryResult result = await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.updatePicture, [
          updatePictureFragment,
          pictureBaseFragment,
          tagFragment,
          locationFragment,
          locationDetailFragment,
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
              'location': newData['location']! as Map?,
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
                      location
                    }
                  '''),
              ).asRequest(idFields: idFields),
              data: updated,
            );
          }
        },
      ),
    );
    if (result.hasException) {
      // captureException(result.exception);
      throw result.exception!;
    }
    return result;
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
