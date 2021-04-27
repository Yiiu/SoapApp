import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/home/new/list.dart';
import 'package:soap_app/widget/app_bar.dart';

class NewView extends StatefulWidget {
  @override
  NewViewState createState() {
    return NewViewState();
  }
}

class NewViewState extends State<NewView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  static List<String> get tabs => ['最新', '热门'];

  @override
  Widget build(BuildContext context) {
    final Map<String, Map<String, int>> variables = {
      'query': {'page': 1, 'pageSize': 30}
    };
    return FixedAppBarWrapper(
      appBar: const SoapAppBar(
        centerTitle: false,
        elevation: 0.2,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '首页',
            style: TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
      body: Query(
        options: QueryOptions(
          document: addFragments(
            pictures,
            [...pictureListFragmentDocumentNode],
          ),
          variables: variables,
        ),
        builder: (
          QueryResult result, {
          Refetch? refetch,
          FetchMore? fetchMore,
        }) {
          if (result.hasException && result.data == null) {
            return Text(result.exception.toString());
          }

          if (result.isLoading && result.data == null) {
            return const Text('加载中');
          }

          final List repositories = result.data!['pictures']['data'] as List;

          final List<Picture> pictureList = Picture.fromListJson(repositories);

          return NewList(
            refetch: refetch!,
            pictureList: pictureList,
          );
        },
      ),
    );
  }
}
