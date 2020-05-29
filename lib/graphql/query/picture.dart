String pictures = '''
  query Pictures(\$query: PicturesQueryInput!) {
    pictures(query: \$query) {
      data {
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
        blurhashSrc
        commentCount
        user {
          id
          username
          fullName
          name
          email
          avatar
          bio
          website
          likesCount
          pictureCount
          createTime
          updateTime
        }
      }
    }
  }
''';
