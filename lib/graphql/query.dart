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

DocumentNode picture = gql(r'''
  query Picture($id: Float!) {
    picture(id: $id) {
      ...PictureDetailFragment
    }
  }
''');

DocumentNode comments = gql(r'''
  query Comments($id: Float!, $query: CommentsQueryInput) {
    comments(id: $id, query: $query) {
      ...CommentListFragment
    }
  }
''');
