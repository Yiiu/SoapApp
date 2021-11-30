import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/graphql/graphql.dart';
import 'package:soap_app/model/collection.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/utils.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class UserCollectionList extends StatefulWidget {
  const UserCollectionList({
    Key? key,
    required this.username,
  }) : super(key: key);

  final String username;

  @override
  UserCollectionListState createState() => UserCollectionListState();
}

class UserCollectionListState extends State<UserCollectionList>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  final RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _errorRefreshController =
      RefreshController(initialRefresh: false);
  final RefreshController _loaddingRefreshController =
      RefreshController(initialRefresh: false);

  bool get isOwner {
    if (accountStore.isLogin &&
        widget.username == accountStore.userInfo!.username) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> variables = {
      'username': widget.username,
    };
    return Query(
      options: QueryOptions(
        document: addFragments(
          userCollectionsByName,
          [...collectionListFragmentDocumentNode],
        ),
        fetchPolicy: FetchPolicy.cacheFirst,
        variables: variables,
      ),
      builder: (
        QueryResult result, {
        Refetch? refetch,
        FetchMore? fetchMore,
      }) {
        List<Collection> list = [];
        Future<void> onRefresh() async {
          final QueryResult? data = await refetch!();
          if (data != null && data.hasException) {
            _refreshController.refreshFailed();
            return;
          }
          _refreshController.refreshCompleted();
          setState(() {});
        }

        if (result.hasException) {
          captureException(result.exception);
        }

        if (result.hasException && result.data == null) {
          return SoapListError(
            notScrollView: true,
            controller: _errorRefreshController,
            onRefresh: onRefresh,
          );
        }

        if (result.isLoading && result.data == null) {
          return SoapListLoading(
            notScrollView: true,
            controller: _loaddingRefreshController,
          );
        }
        list = Collection.fromListJson(
          result.data!['userCollectionsByName']['data'] as List,
        );

        if (list.isEmpty) {
          return const SoapListEmpty();
          // return ;
        }

        return SmartRefresher(
          enablePullUp: false,
          enablePullDown: true,
          controller: _refreshController,
          physics: const BouncingScrollPhysics(),
          child: ListView.builder(
            itemCount: list.length + 1,
            itemBuilder: (_, int i) {
              if (i == 0) {
                if (isOwner) {
                  return TouchableOpacity(
                    activeOpacity: activeOpacity,
                    onTap: () {
                      showSoapBottomSheet(
                        context,
                        isScrollControlled: true,
                        child: AddCollectionModal(
                          refetch: refetch!,
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(top: 12),
                      padding: const EdgeInsets.all(12),
                      color: Theme.of(context).cardColor,
                      child: Flex(
                        direction: Axis.horizontal,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                          SizedBox(
                            width: 20,
                            height: 20,
                            child: SvgPicture.asset(
                              'assets/remix/add-circle.svg',
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .color!
                                  .withOpacity(.2),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            '新增收藏夹',
                            style: TextStyle(
                              color: Theme.of(context)
                                  .textTheme
                                  .bodyText2!
                                  .color!
                                  .withOpacity(.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return const SizedBox();
                }
              }
              return TouchableOpacity(
                key: ValueKey<String>(
                  list[i - 1].id.toString() + 'collection_item',
                ),
                activeOpacity: activeOpacity,
                onTap: () {
                  Navigator.of(context).pushNamed(
                    RouteName.collection_detail,
                    arguments: {
                      'collection': list[i - 1],
                    },
                  );
                },
                onLongPress: () {
                  final Collection item = list[i - 1];
                  if (accountStore.isLogin &&
                      item.user!.username == accountStore.userInfo!.username) {
                    showSoapBottomSheet(
                      context,
                      child: CollectionMoreHandle(
                        collection: list[i - 1],
                        onRefresh: onRefresh,
                      ),
                    );
                  }
                },
                child: CollectionItem(
                  collection: list[i - 1],
                ),
              );
            },
          ),
          onRefresh: () {
            onRefresh();
          },
        );
      },
    );
  }
}
