import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

DocumentNode likePicture = gql(r'''
  mutation LikePicture($id: Float!) {
    likePicture(id: $id) {
      ...PictureFragment
    }
  }
''');

DocumentNode unLikePicture = gql(r'''
  mutation UnLikePicture($id: Float!) {
    unlikePicture(id: $id) {
      ...PictureFragment
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

DocumentNode deleteCollection = gql(r'''
  mutation DeleteCollection($id: Float!) {
    deleteCollection(id: $id) {
      done
    }
  }
''');

DocumentNode addCollection = gql(r'''
  mutation AddCollection($data: AddCollectionInput!) {
    addCollection(data: $data) {
      ...CollectionDetailFragment
    }
  }
''');

DocumentNode updateCollection = gql(r'''
  mutation UpdateCollection($id: Float!, $data: AddCollectionInput!) {
    updateCollection(id: $id, data: $data) {
      ...CollectionDetailFragment
    }
  }
''');

DocumentNode followUser = gql(r'''
  mutation FollowUser($input: FollowUserInput!) {
    followUser(input: $input) {
      done
    }
  }
''');

DocumentNode unFollowUser = gql(r'''
  mutation UnFollowUser($input: FollowUserInput!) {
    unFollowUser(input: $input) {
      done
    }
  }
''');

DocumentNode updateProfile = gql(r'''
  mutation UpdateProfile($data: UpdateProfileInput!) {
    updateProfile(data: $data) {
      ...UserFragment
    }
  }
''');
