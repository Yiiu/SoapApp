import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/home/new/list.dart';
import 'package:soap_app/utils/list.dart';
import 'package:soap_app/utils/query.dart';
import 'package:soap_app/widget/app_bar.dart';

class NewView extends StatefulWidget {
  const NewView({Key? key}) : super(key: key);
  @override
  NewViewState createState() {
    return NewViewState();
  }
}

class NewViewState extends State<NewView>
    with AutomaticKeepAliveClientMixin, SingleTickerProviderStateMixin {
  @override
  bool get wantKeepAlive => true;

  Map<String, int> query = {
    'page': 1,
    'pageSize': 30,
  };

  String type = 'NEW';

  static List<String> get tabs => <String>['最新', '热门'];
  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> variables = {'query': query, 'type': type};
    return FixedAppBarWrapper(
      backdropBar: true,
      appBar: const SoapAppBar(
        backdrop: true,
        centerTitle: false,
        elevation: 0,
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            '首页',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
      body: Query(
        options: QueryOptions(
          fetchPolicy: FetchPolicy.cacheAndNetwork,
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
            return Container(
              color: Theme.of(context).backgroundColor,
              child: SmartRefresher(
                enablePullUp: false,
                enablePullDown: true,
                controller: _refreshController,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: const <Widget>[
                          Icon(
                            FeatherIcons.alertCircle,
                            size: 42,
                            color: Colors.red,
                          ),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '服务器挂掉惹,请重试',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          if (result.isLoading && result.data == null) {
            return Container(
              color: Theme.of(context).backgroundColor,
              child: SmartRefresher(
                enablePullUp: false,
                enablePullDown: true,
                controller: _refreshController,
                physics: const BouncingScrollPhysics(),
                child: SizedBox(
                  height: double.infinity,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        children: const <Widget>[
                          CupertinoActivityIndicator(),
                          SizedBox(
                            height: 4,
                          ),
                          Text(
                            '加载中...',
                            style: TextStyle(
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final ListData<Picture> listData = pictureListDataFormat(
            result.data!,
            label: 'pictures',
          );

          return NewList(
            listData: listData,
            refetch: refetch!,
            loading: (int page) async {
              final Map<String, Object> fetchMoreVariables = {
                'query': {...query, 'page': page},
                'type': type
              };
              await fetchMore!(
                listFetchMoreOptions(
                  variables: fetchMoreVariables,
                  label: 'pictures',
                ),
              );
            },
          );
        },
      ),
    );
  }
}
