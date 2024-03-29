import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart' as graphql;

import '../../config/config.dart';
import '../../graphql/graphql.dart';
import '../../model/user.dart';
import '../../widget/picture_list.dart';
import 'stores/user_store.dart';
import 'widgets/collection_list.dart';
import 'widgets/sliver_head.dart';

class UserPage extends StatefulWidget {
  const UserPage({
    Key? key,
    required this.user,
    this.heroId,
  }) : super(key: key);

  final User user;

  final String? heroId;

  @override
  _UserPageState createState() => _UserPageState();
}

class _UserPageState extends State<UserPage>
    with SingleTickerProviderStateMixin {
  final UserPageStore _pageStore = UserPageStore();

  late User user;
  late TabController tabController;
  final int _selectedIndex = 0;

  final double _tabBarHeight = 55;
  final double titleHeight = 150;

  bool _pictureListCached = false;

  @override
  void initState() {
    user = widget.user;
    _pageStore.init(user);
    _pageStore.watchQuery();
    tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: _selectedIndex,
    );
    checkPictureCache();
    super.initState();
  }

  void checkPictureCache() {
    final graphql.Request queryRequest = graphql.Request(
      operation: graphql.Operation(
        document: addFragments(
          userPictures,
          [...pictureListFragmentDocumentNode],
        ),
      ),
      variables: <String, dynamic>{
        'username': user.username,
        // ignore: prefer_const_literals_to_create_immutables
        'query': <String, int>{
          'page': 1,
          'pageSize': 30,
        },
      },
    );
    final Map<String, dynamic>? cacheData =
        GraphqlConfig.graphQLClient.readQuery(queryRequest);
    _pictureListCached = cacheData != null;
  }

  @override
  void didChangeDependencies() {
    if (!_pictureListCached) {
      checkPictureCache();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      child: Container(
        color: theme.cardColor,
        child: extended.ExtendedNestedScrollView(
          physics: const BouncingScrollPhysics(),
          headerSliverBuilder:
              (BuildContext context, bool? innerBoxIsScrolled) {
            return <Widget>[
              SliverHeader(
                tabBarHeight: _tabBarHeight,
                store: _pageStore,
                tabController: tabController,
              ),
            ];
          },
          pinnedHeaderSliverHeightBuilder: () {
            return MediaQuery.of(context).padding.top +
                appBarHeight +
                _tabBarHeight;
          },
          body: Container(
            color: theme.backgroundColor,
            child: Column(
              children: <Widget>[
                Expanded(
                  child: TabBarView(
                    physics: const BouncingScrollPhysics(),
                    controller: tabController,
                    children: <Widget>[
                      if (_pictureListCached)
                        PictureList(
                          document: addFragments(
                            userPictures,
                            [...pictureListFragmentDocumentNode],
                          ),
                          heroLabel: 'user-picture-list-${user.username}',
                          label: 'userPicturesByName',
                          variables: <String, String>{
                            'username': user.username,
                          },
                        ),
                      if (!_pictureListCached)
                        FutureBuilder<dynamic>(
                          future: Future<dynamic>.delayed(
                            Duration(milliseconds: screenDelayTimer),
                          ),
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done) {
                              return PictureList(
                                document: addFragments(
                                  userPictures,
                                  [...pictureListFragmentDocumentNode],
                                ),
                                heroLabel: 'user-picture-list-${user.username}',
                                label: 'userPicturesByName',
                                variables: {
                                  'username': user.username,
                                },
                              );
                            } else {
                              return const SizedBox();
                            }
                          },
                        ),
                      UserCollectionList(username: user.username),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
