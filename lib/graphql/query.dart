import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

DocumentNode pictures = gql(r'''
  query Pictures($query: PicturesQueryInput!, $type: PicturesType = NEW) {
    pictures(query: $query, type: $type) {
      ...PictureListFragment
    }
  }
''');

DocumentNode userPictures = gql(r'''
  query UserPictures(
    $type: UserPictureType = MY,
    $username: String!,
    $query: PicturesQueryInput!
  ) {
    userPicturesByName(type: $type, username: $username, query: $query) {
      ...PictureListFragment
    }
  }
''');
