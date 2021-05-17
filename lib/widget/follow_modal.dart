import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gql/ast.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/config/theme.dart';
import 'package:soap_app/graphql/fragments.dart';
import 'package:soap_app/graphql/gql.dart';
import 'package:soap_app/graphql/query.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

enum FollowModalType {
  follower,
  followed,
}

class FollowModal extends StatefulWidget {
  FollowModal({
    Key? key,
    this.type = FollowModalType.follower,
    this.scrollController,
    required this.id,
  }) : super(key: key);

  int id;
  FollowModalType type;
  ScrollController? scrollController;

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
    final variables = {
      'id': widget.id,
      'limit': 30,
      'offset': 0,
    };
    return SizedBox(
      height: MediaQuery.of(context).size.height * .75,
      child: FixedAppBarWrapper(
        backdropBar: true,
        appBar: SoapAppBar(
          topPadding: false,
          backdrop: true,
          border: true,
          elevation: 0,
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
            topLeft: Radius.circular(12),
            topRight: Radius.circular(12),
          ),
        ),
        body: Query(
            options: QueryOptions(
              document: addFragments(
                document,
                [...userDetailFragmentDocumentNode],
              ),
              variables: variables,
            ),
            builder: (
              QueryResult result, {
              Refetch? refetch,
              FetchMore? fetchMore,
            }) {
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
                    physics: const BouncingScrollPhysics(),
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
                          children: [
                            Row(
                              children: [
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
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 12,
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
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
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                      if (user.bio != null)
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 6),
                                          child: Text(
                                            user.bio!,
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
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: list.length,
                  ),
                ),
              );
            }),
      ),
    );
  }
}
