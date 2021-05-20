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

DocumentNode updatePicture = gql(r'''
  mutation UpdatePicture($data: UpdatePictureInput!, $id: Float!) {
    updatePicture(data: $data, id: $id) {
      ...UpdatePictureFragment
    }
  }
''');

DocumentNode deletePicture = gql(r'''
  mutation DeletePicture($id: Float!) {
    deletePicture(id: $id) {
      done
    }
  }
''');

DocumentNode addPictureCollection = gql(r'''
  mutation AddPictureCollection($id: Float!, $pictureId: Float!) {
    addPictureCollection(id: $id, pictureId: $pictureId) {
      ...CollectionFragment
    }
  }
''');

DocumentNode removePictureCollection = gql(r'''
  mutation RemovePictureCollection($id: Float!, $pictureId: Float!) {
    removePictureCollection(id: $id, pictureId: $pictureId) {
      done
    }
  }
''');
