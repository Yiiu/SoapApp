import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/graphql/common/fragments.dart';

class PictureQueries {
  static final DocumentNode pictures = gql(r'''
    query Pictures($query: PicturesQueryInput!, $type: PicturesType) {
      pictures(query: $query, type: $type) {
        ...PictureListFragment
      }
    }
  ''')
    ..definitions.addAll(Fragments.getFragments([
      'PictureListFragment',
      'PictureFragment',
      'EXIFFragment',
      'BadgeFragment',
      'UserBaseFragment',
      'UserFragment'
    ]));
}
