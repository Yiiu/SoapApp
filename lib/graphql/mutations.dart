import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

DocumentNode likePicture = gql(r'''
  mutation LikePicture($id: Float!) {
    likePicture(id: $id) {
      ...PictureLikeFragment
    }
  }
''');

DocumentNode unLikePicture = gql(r'''
  mutation UnLikePicture($id: Float!) {
    unlikePicture(id: $id) {
      ...PictureLikeFragment
    }
  }
''');
DocumentNode addComment = gql(r'''
  mutation AddComment($id: Float!, $commentId: Float, $data: AddCommentInput!) {
    addComment(id: $id, commentId: $commentId, data: $data) {
      ...CommentChildFragment
    }
  }
''');
