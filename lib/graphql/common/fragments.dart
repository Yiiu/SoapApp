import 'package:gql/src/ast/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import "package:gql/operation.dart";

class Fragments {
  static final fragments = gql(r'''
# -------------------- Picture
fragment PictureFragment on Picture {
  id
  key
  hash
  title
  bio
  views
  originalname
  mimetype
  size
  isLike
  likedCount
  color
  isDark
  height
  width
  make
  model
  createTime
  updateTime
  blurhash
}

fragment PicturePreviewFragment on Picture {
  id
  key
  hash
  title
  bio
  views
  originalname
  mimetype
  size
  color
  isDark
  height
  width
  make
  model
  createTime
  updateTime
}

fragment PictureDetailFragment on Picture {
    ...PictureFragment
    isPrivate
    commentCount
    blurhashSrc
    currentCollections {
      ...CollectionFragment
    }
    # relatedCollections(limit: 3) {
    #   ...RelatedCollectionFragment
    # }
    user {
      ...UserBaseFragment
      isFollowing
    }
    tags {
      ...TagFragment
    }
    exif {
      ...EXIFFragment
    }
    badge {
      ...BadgeFragment
    }
    location {
      ...PictureLocationFragment
    }
}

fragment PictureListFragment on Pictures {
    count
    page
    pageSize
    timestamp
    data {
      ...PictureFragment
      badge {
        ...BadgeFragment
      }
      blurhash
      blurhashSrc
      isPrivate
      user {
        ...UserBaseFragment
        badge {
          ...BadgeFragment
        }
      }
      exif {
        ...EXIFFragment
      }
    }
}

fragment UpdatePictureFragment on Picture {
  title
  bio
  isPrivate
  tags {
    ...TagFragment
  }
}
fragment PictureLikeFragment on LikePictureReq {
  count
  isLike
}

# -------------------- Collection

fragment CollectionFragment on Collection {
  id
  name
  bio
  isPrivate
  createTime
  updateTime
}

fragment RelatedCollectionFragment on PictureRelatedCollectionReq {
    count
    data {
      ...CollectionFragment
      preview {
        ...PicturePreviewFragment
      }
    }
}

fragment CollectionDetailFragment on Collection {
  pictureCount
  ...CollectionFragment
  user {
    ...UserFragment
  }
  preview {
    ...PicturePreviewFragment
  }
}

fragment CollectionListFragment on Collections {
  count
  page
  pageSize
  data {
    ...CollectionFragment
    pictureCount
    user {
      ...UserFragment
    }
    preview {
      ...PicturePreviewFragment
    }
  }
}

# -------------------- User
fragment UserFragment on User {
  id
  username
  fullName
  name
  email
  avatar
  bio
  website
  createTime
  updateTime
  cover
}

fragment UserBaseFragment on User {
  ...UserFragment
  badge {
    ...BadgeFragment
  }
}

fragment UserDetailFragment on User {
  ...UserFragment
  likedCount
  pictureCount
  isFollowing
  likesCount
  followerCount
  followedCount
  isEmailVerified
  isPassword
  signupType
  status
  pictures(limit: 3) {
    ...PicturePreviewFragment
  }
  badge {
    ...BadgeFragment
  }
}

fragment UserFollowInfoFragment on User {
  id
  username
  isFollowing
  followerCount
  followedCount
}

# -------------------- Tag
fragment TagFragment on Tag {
  id
  name
  createTime
  updateTime
  pictureCount
}

fragment EXIFFragment on EXIF {
  aperture
  exposureTime
  focalLength
  ISO
  location
}


fragment NotificationFragment on Notification {
  id
  createTime
  updateTime
  publisher {
    ...UserFragment
  }
  category
  read
  picture {
    ...PicturePreviewFragment
  }
  comment {
    ...CommentNotificationFragment
  }
  user {
    ...UserDetailFragment
  }
}

fragment CommentBaseFragment on Comment {
  id
  content
  createTime
  updateTime
  subCount
}

fragment CommentNotificationFragment on Comment {
  ...CommentBaseFragment
  replyComment {
    ...CommentBaseFragment
  }
  parentComment {
    ...CommentBaseFragment
  }
  user {
    ...UserFragment
  }
  replyUser {
    ...UserFragment
  }
  picture {
    ...PicturePreviewFragment
  }
}

fragment CommentChildFragment on Comment {
  ...CommentBaseFragment
  replyComment {
    ...CommentBaseFragment
  }
  parentComment {
    ...CommentBaseFragment
  }
  user {
    ...UserBaseFragment
  }
  replyUser {
    ...UserFragment
  }
}

fragment CommentFragment on Comment {
  ...CommentBaseFragment
  replyComment {
    ...CommentBaseFragment
  }
  parentComment {
    ...CommentBaseFragment
  }
  childComments(limit: 3) {
    ...CommentChildFragment
  }
  user {
    ...UserBaseFragment
  }
  replyUser {
    ...UserFragment
  }
}

fragment ChildCommentListFragment on Comments {
    count
    page
    pageSize
    timestamp
    data {
      ...CommentChildFragment
    }
}

fragment CommentListFragment on Comments {
    count
    page
    pageSize
    timestamp
    data {
      ...CommentFragment
    }
}

fragment BadgeFragment on Badge {
  id
  type
  name
  rate
}

fragment SearchPlaceDetailFragment on SearchPlaceDetail {
  name
  location {
    lat
    lng
  }
  address
  province
  city
  area
  street_id
  telephone
  detail
  uid
  detail_info {
    tag
  }
}

fragment PictureLocationFragment on PictureLocation {
  formatted_address
  business
  country
  country_code
  province
  city
  district
  town
  location {
    lat
    lng
  }
  pois(limit: 3) {
    addr
    name
    poiType
    tag
  }
}

  ''');

  static FragmentDefinitionNode getFragment(String name) {
    final ExecutableDocument document = ExecutableDocument(
      Fragments.fragments,
    );
    final fragment = document.getFragment(name);
    return fragment.astNode;
  }

  static Iterable<FragmentDefinitionNode> getFragments(Iterable<String> names) {
    final ExecutableDocument document = ExecutableDocument(
      Fragments.fragments,
    );
    return names.map((String name) {
      return document.getFragment(name).astNode;
    });
  }
}
