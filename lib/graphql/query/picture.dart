String Pictures = """
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
""";
