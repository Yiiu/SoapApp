// ignore: implementation_imports
import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/graphql/common/fragments.dart';

class UserQueries {
  static final DocumentNode whoami = gql(r'''
    query Whoami {
      whoami {
        ...UserDetailFragment
      }
    }
  ''')
    // ignore: always_specify_types
    ..definitions.addAll(Fragments.getFragments([
      'UserDetailFragment',
      'UserFragment',
      'PicturePreviewFragment',
      'BadgeFragment',
    ]));

  static final DocumentNode user = gql(r'''
    query User($username: String) {
      user(username: $username) {
        ...UserDetailFragment
      }
    }
  ''')
    // ignore: always_specify_types
    ..definitions.addAll(Fragments.getFragments([
      'UserDetailFragment',
      'UserFragment',
      'PicturePreviewFragment',
      'BadgeFragment',
    ]));
}
