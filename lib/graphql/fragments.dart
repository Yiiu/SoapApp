import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

DocumentNode pictureDetailFragment = gql(r'''
  fragment PictureDetailFragment on Picture {
    ...PictureFragment
    isPrivate
    commentCount
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
''');

DocumentNode pictureFragment = gql(r'''
  fragment PictureFragment on Picture {
    ...PictureBaseFragment
    isLike
    likedCount
  }
''');

DocumentNode pictureBaseFragment = gql(r'''
  fragment PictureBaseFragment on Picture {
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
    blurhash
  }
''');

DocumentNode pictureListFragment = gql(r'''
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
''');

DocumentNode badgeFragment = gql(r'''
  fragment BadgeFragment on Badge {
    id
    type
    name
    rate
  }
''');

DocumentNode userBaseFragment = gql(r'''
  fragment UserBaseFragment on User {
    ...UserFragment
    badge {
      ...BadgeFragment
    }
  }
''');

DocumentNode userFragment = gql(r'''
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
''');

DocumentNode userDetailFragment = gql(r'''
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
      ...PictureBaseFragment
    }
    badge {
      ...BadgeFragment
    }
  }
''');
DocumentNode exifFragment = gql(r'''
  fragment EXIFFragment on EXIF {
    aperture
    exposureTime
    focalLength
    ISO
    location
  }
''');
DocumentNode collectionFragment = gql(r'''
  fragment CollectionFragment on Collection {
    id
    name
    bio
    isPrivate
    createTime
    updateTime
    pictureCount
  }
''');
DocumentNode tagFragment = gql(r'''
  fragment TagFragment on Tag {
    id
    name
    createTime
    updateTime
    pictureCount
  }
''');
DocumentNode pictureLocationFragment = gql(r'''
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

DocumentNode commentBaseFragment = gql(r'''
  fragment CommentBaseFragment on Comment {
    id
    content
    createTime
    updateTime
    subCount
  }
''');
DocumentNode commentChildFragment = gql(r'''
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
''');
DocumentNode commentFragment = gql(r'''
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

''');
DocumentNode childCommentListFragment = gql(r'''
  fragment ChildCommentListFragment on Comments {
      count
      page
      pageSize
      timestamp
      data {
        ...CommentChildFragment
      }
  }
''');

DocumentNode commentListFragment = gql(r'''
  fragment CommentListFragment on Comments {
      count
      page
      pageSize
      timestamp
      data {
        ...CommentFragment
      }
  }
''');

DocumentNode pictureLikeFragment = gql(r'''
  fragment PictureLikeFragment on LikePictureReq {
    count
    isLike
  }
''');

List<DocumentNode> pictureListFragmentDocumentNode = <DocumentNode>[
  pictureFragment,
  pictureBaseFragment,
  pictureListFragment,
  badgeFragment,
  userBaseFragment,
  userFragment,
  exifFragment,
];

List<DocumentNode> pictureDetailFragmentDocumentNode = <DocumentNode>[
  pictureDetailFragment,
  pictureFragment,
  pictureBaseFragment,
  badgeFragment,
  userBaseFragment,
  userFragment,
  exifFragment,
  collectionFragment,
  tagFragment,
  pictureLocationFragment,
];

List<DocumentNode> commentListFragmentDocumentNode = <DocumentNode>[
  commentListFragment,
  commentFragment,
  commentBaseFragment,
  commentChildFragment,
  userBaseFragment,
  userFragment,
  badgeFragment,
];

List<DocumentNode> commentFragmentDocumentNode = <DocumentNode>[
  commentBaseFragment,
  commentChildFragment,
  userBaseFragment,
  userFragment,
  badgeFragment,
];

List<DocumentNode> userDetailFragmentDocumentNode = <DocumentNode>[
  pictureBaseFragment,
  userFragment,
  userBaseFragment,
  badgeFragment,
];
