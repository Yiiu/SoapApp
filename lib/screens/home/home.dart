import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/graphql/query/picture.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:soap_app/ui/widget/picture_item.dart';

class HomeView extends StatefulWidget {
  @override
  HomeViewState createState() {
    return HomeViewState();
  }
}

class HomeViewState extends State<HomeView> {
  ScrollController _controller = new ScrollController();

  Widget _buildItem(Picture picture) {
    return PictureItem(picture: picture);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: <Widget>[
          SoapAppBar(
            title: 'Home',
            controller: _controller,
          ),
          Expanded(
            child: CustomScrollView(
              controller: _controller,
              physics: BouncingScrollPhysics(),
              slivers: <Widget>[
                SliverToBoxAdapter(),
                Query(
                  options: QueryOptions(
                    documentNode: gql(pictures),
                    fetchPolicy: FetchPolicy.cacheAndNetwork,
                    // pollInterval: 15,
                    variables: {
                      'query': {
                        'page': 1,
                        'pageSize': 30,
                      }
                    },
                  ),
                  builder: (QueryResult result,
                      {VoidCallback refetch, FetchMore fetchMore}) {
                    if (result.hasException) {
                      return Text(result.exception.toString());
                    }
                    if (result.loading) {
                      return SliverFillRemaining(
                        child: Container(
                          padding: EdgeInsets.all(24.0),
                          child: CupertinoActivityIndicator(),
                        ),
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
          )
        ],
      ),
    );
  }
}
