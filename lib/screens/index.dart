import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/ui/widget/header.dart';

import '../model/picture.dart';
import '../ui/widget/picture_item.dart';

List<int> products = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15];

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

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Picture> list = [];

  Widget _buildItem(Picture picture) {
    return PictureItem(picture: picture);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: CustomScrollView(
          physics: BouncingScrollPhysics(),
          semanticChildCount: products.length,
          slivers: <Widget>[
            SliverToBoxAdapter(),
            SliverPersistentHeader(
              floating: true,
              // pinned: true,
              delegate: Header(
                title: Text(
                  'Latest',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            Query(
              options: QueryOptions(
                documentNode: gql(Pictures),
                fetchPolicy: FetchPolicy.cacheAndNetwork,
                pollInterval: 15,
                variables: {
                  'query': {'page': 1, 'pageSize': 30}
                },
              ),
              builder: (QueryResult result,
                  {VoidCallback refetch, FetchMore fetchMore}) {
                if (result.hasException) {
                  return Text(result.exception.toString());
                }

                if (result.loading) {
                  return SliverToBoxAdapter(
                    child: CupertinoActivityIndicator(),
                  );
                }
                List pictures =
                    Picture.fromListJson(result.data['pictures']['data']);
                return SliverList(
                  delegate: SliverChildListDelegate(
                    pictures.map((picture) {
                      return _buildItem(picture);
                    }).toList(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
