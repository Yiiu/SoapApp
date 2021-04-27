import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

DocumentNode pictures = gql(r'''
  query Pictures($query: PicturesQueryInput!, $type: PicturesType) {
    pictures(query: $query, type: $type) {
      ...PictureListFragment
    }
  }
''');
