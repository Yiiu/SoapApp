import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/mutations.dart' as mutations;
import 'package:soap_app/graphql/query.dart' as query;

class UserRepository {
  Future<void> _setFollowInfoCache(
      GraphQLDataProxy cache, String username) async {
    final QueryResult result = await GraphqlConfig.graphQLClient.query(
      QueryOptions(
        document: addFragments(query.userIsFollowing, [userFollowInfoFragment]),
        fetchPolicy: FetchPolicy.networkOnly,
        variables: {
          'username': username,
        } as Map<String, dynamic>,
      ),
    );
    if (result.data?['user'] != null) {
      final Map<String, Object?> updated = {
        'id': result.data!['user']!['id'],
        'isFollowing': result.data!['user']!['isFollowing'],
        'followerCount': result.data!['user']!['followerCount'],
        'followedCount': result.data!['user']!['followedCount']
      };
      final Map<String, Object?> idFields = {
        'id': result.data!['user']!['id'],
        '__typename': result.data!['user']!['__typename'],
      };
      final FragmentRequest fragmentRequest = Fragment(
        document: gql(
          r'''
            fragment UserDetailFragment on User {
              id
              isFollowing
              followerCount
              followedCount
            }
          ''',
        ),
      ).asRequest(idFields: idFields);
      cache.writeFragment(
        fragmentRequest,
        data: updated,
        broadcast: true,
      );
    }
  }

  Future<void> followUser(int id, String username) async {
    final Map<String, Object> variables = {
      'input': {
        'userId': id,
      },
    };
    await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.followUser, []),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['followUser']?['done'] == true) {
            _setFollowInfoCache(cache, username);
          }
        },
      ),
    );
  }

  Future<void> unFollowUser(int id, String username) async {
    final Map<String, Object> variables = {
      'input': {
        'userId': id,
      },
    };
    await GraphqlConfig.graphQLClient.mutate(
      MutationOptions(
        document: addFragments(mutations.unFollowUser, []),
        variables: variables,
        update: (GraphQLDataProxy cache, QueryResult? result) async {
          if (result?.data?['unFollowUser']?['done'] == true) {
            _setFollowInfoCache(cache, username);
          }
        },
      ),
    );
  }
}
