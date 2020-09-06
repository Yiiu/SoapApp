import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/graphql/common/fragments.dart';

mixin CommentQueries {
  static final DocumentNode comments = gql(r'''
    query Comments($id: Float!, $query: CommentsQueryInput) {
      comments(id: $id, query: $query) {
        ...CommentListFragment
      }
    }
  ''')
    // ignore: always_specify_types
    ..definitions.addAll(Fragments.getFragments([
      'CommentListFragment',
      'CommentChildFragment',
      'CommentBaseFragment',
      'CommentFragment',
      'BadgeFragment',
      'UserBaseFragment',
      'UserFragment'
    ]));
}
