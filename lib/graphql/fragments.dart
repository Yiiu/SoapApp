import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

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
DocumentNode exifFragment = gql(r'''
  fragment EXIFFragment on EXIF {
    aperture
    exposureTime
    focalLength
    ISO
    location
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
