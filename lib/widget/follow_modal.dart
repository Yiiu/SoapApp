import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../config/config.dart';
import '../graphql/fragments.dart';
import '../graphql/gql.dart';
import '../graphql/query.dart';
import '../model/user.dart';
import '../utils/exception.dart';
import 'app_bar.dart';
import 'avatar.dart';

enum FollowModalType {
  follower,
  followed,
}

class FollowModal extends StatefulWidget {
  const FollowModal({
    Key? key,
    this.type = FollowModalType.follower,
    this.scrollController,
    required this.id,
  }) : super(key: key);

  final int id;
  final FollowModalType type;
  final ScrollController? scrollController;

  @override
  _FollowModalState createState() => _FollowModalState();
}

class _FollowModalState extends State<FollowModal> {
  DocumentNode get document {
    if (widget.type == FollowModalType.followed) {
      return followedUsers;
    }
    return followerUsers;
  }

  String get resultLabel => widget.type == FollowModalType.followed
      ? 'followedUsers'
      : 'followerUsers';

  String get title => widget.type == FollowModalType.followed ? '关注' : '粉丝';

  @override
  Widget build(BuildContext context) {
    final Map<String, Object> variables = {
      'id': widget.id,
      'query': {
        'pageSize': 30,
        'page': 1,
      }
    };
    return SizedBox(
      height: MediaQuery.of(context).size.height * .75,
      child: FixedAppBarWrapper(
        backdropBar: true,
        appBar: SoapAppBar(
          topPadding: false,
          backdrop: true,
          elevation: 0.5,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          centerTitle: false,
          borderRadius: const BorderRadius.only(
            topLeft: radius,
            topRight: radius,
          ),
        ),
        body: Query(
          options: QueryOptions(
            document: addFragments(
              document,
              [...userDetailFragmentDocumentNode],
            ),
            fetchPolicy: FetchPolicy.cacheFirst,
            variables: variables,
          ),
          builder: (
            QueryResult result, {
            Refetch? refetch,
            FetchMore? fetchMore,
          }) {
            if (result.hasException) {
              captureException(result.exception);
            }
            if (result.data?[resultLabel] == null) {
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            }
            final List<User> list =
                User.fromListJson(result.data?[resultLabel] as List);
            return SizedBox(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                  controller: widget.scrollController,
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final User user = list[index];
                    EdgeInsetsGeometry? margin;
                    if (index == 0) {
                      margin = const EdgeInsets.only(top: appBarHeight);
                    }
                    return Container(
                      margin: margin,
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 14,
                      ),
                      child: Row(
                        children: <Widget>[
                          TouchableOpacity(
                            activeOpacity: activeOpacity,
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                RouteName.user,
                                arguments: {
                                  'user': user,
                                  'heroId': '',
                                },
                              );
                            },
                            child: Avatar(
                              image: user.avatarUrl,
                              size: 42,
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 12,
                              ),
                              child: Flex(
                                direction: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  TouchableOpacity(
                                    activeOpacity: activeOpacity,
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        RouteName.user,
                                        arguments: {
                                          'user': user,
                                          'heroId': '',
                                        },
                                      );
                                    },
                                    child: Text(
                                      user.fullName,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  if (user.bio != null)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 6),
                                      child: Text(
                                        user.bio!,
                                        maxLines: 1,
                                        softWrap: false,
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Theme.of(context)
                                              .textTheme
                                              .bodyText2!
                                              .color!
                                              .withOpacity(.8),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: list.length,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
