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

DocumentNode pictureRelatedPictures = gql(r'''
  query PictureRelatedPictures($id: Float!, $limit: Float) {
    pictureRelatedPictures(id: $id, limit: $limit) {
      ...RelatedPictureFragment
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

DocumentNode userInfo = gql(r'''
  query UserInfo($username: String) {
    user(username: $username) {
      ...UserDetailFragment
    }
  }
''');
DocumentNode userIsFollowing = gql(r'''
  query UserIsFollowing($username: String) {
    user(username: $username) {
      ...UserFollowInfoFragment
    }
  }
''');

DocumentNode whoami = gql(r'''
  query Whoami {
    whoami {
      ...UserDetailFragment
    }
  }
''');

DocumentNode followedUsers = gql(r'''
query FollowedUsers($id: Float!, $query: FollowUsersQueryInput) {
  followedUsers(id: $id, query: $query) {
    ...UserDetailFragment
  }
}

''');

DocumentNode followerUsers = gql(r'''
  query FollowerUsers($id: Float!, $query: FollowUsersQueryInput) {
    followerUsers(id: $id, query: $query) {
      ...UserDetailFragment
    }
  }
''');

DocumentNode userCollectionsByName = gql(r'''
  query UserCollectionsByName(
    $username: String!,
    $query: CollectionsQueryInput
  ) {
    userCollectionsByName(username: $username, query: $query) {
      ...CollectionListFragment
    }
  }
''');
DocumentNode collectionPictures = gql(r'''
  query CollectionPictures($id: Float!, $query: PicturesQueryInput!) {
    collectionPictures(id: $id, query: $query) {
      ...PictureListFragment
    }
  }
''');

DocumentNode tag = gql(r'''
  query Tag($name: String!) {
    tag(name: $name) {
      ...TagFragment
    }
  }
''');

DocumentNode tagPictures = gql(r'''
  query TagPictures($name: String!, $query: PicturesQueryInput!) {
    tagPictures(name: $name, query: $query) {
      ...PictureListFragment
    }
  }
''');

DocumentNode searchPlace = gql(r'''
  query SearchPlace($value: String!, $region: String!) {
    searchPlace(value: $value, region: $region) {
      ...LocationFragment
    }
  }
''');
DocumentNode placeDetail = gql(r'''
  query PlaceDetail($uid: String!) {
    placeDetail(uid: $uid) {
      ...LocationFragment
    }
  }
''');
