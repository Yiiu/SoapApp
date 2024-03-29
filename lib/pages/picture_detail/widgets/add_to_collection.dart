import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:octo_image/octo_image.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/utils/octo_bluehash.dart';
import '../../../graphql/fragments.dart';
import '../../../graphql/gql.dart';
import '../../../graphql/query.dart';
import '../../../model/collection.dart';
import '../../../repository/picture_repository.dart';
import '../../../store/index.dart';
import '../../../utils/exception.dart';
import '../../../utils/picture.dart';
import '../../../widget/list/error.dart';
import '../../../widget/list/loading.dart';
import '../../../widget/more_handle_modal/more_handle_modal.dart';

class AddToCollection extends StatefulWidget {
  const AddToCollection({
    Key? key,
    this.current,
    required this.pictureId,
  }) : super(key: key);

  final List<Collection>? current;
  final int pictureId;

  @override
  _AddToCollectionState createState() => _AddToCollectionState();
}

class _AddToCollectionState extends State<AddToCollection> {
  final RefreshController _refreshController = RefreshController();

  final PictureRepository pictureRepository = PictureRepository();

  late List<int> currentList;

  @override
  void initState() {
    if (widget.current != null && widget.current!.isNotEmpty) {
      currentList = widget.current!.map((Collection e) => e.id).toList();
    } else {
      currentList = [];
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, String> variables = {
      'username': accountStore.userInfo!.username,
    };
    final ThemeData theme = Theme.of(context);
    return MoreHandleModal(
      title: '加入收藏夹',
      // removeBottom: true,
      child: Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 12,
            right: 12,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).cardColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: MediaQuery.removePadding(
              removeTop: true,
              removeBottom: true,
              context: context,
              child: Container(
                constraints: const BoxConstraints(maxHeight: 320),
                child: MediaQuery.removePadding(
                  removeTop: true,
                  removeBottom: true,
                  context: context,
                  child: Query(
                    options: QueryOptions(
                      document: addFragments(
                        userCollectionsByName,
                        [...collectionListFragmentDocumentNode],
                      ),
                      variables: variables,
                    ),
                    builder: (
                      QueryResult result, {
                      Refetch? refetch,
                      FetchMore? fetchMore,
                    }) {
                      List<Collection> list = [];

                      if (result.hasException) {
                        captureException(result.exception);
                      }

                      if (result.hasException && result.data == null) {
                        return SoapListError(
                          notScrollView: true,
                          controller: _refreshController,
                          onRefresh: () async {},
                        );
                      }

                      if (result.isLoading && result.data == null) {
                        return SoapListLoading(
                          notScrollView: true,
                          controller: _refreshController,
                        );
                      }
                      list = Collection.fromListJson(
                        result.data!['userCollectionsByName']['data'] as List,
                      );
                      return ListView(
                        shrinkWrap: true,
                        physics: const BouncingScrollPhysics(),
                        children: ListTile.divideTiles(
                          color:
                              theme.textTheme.overline!.color!.withOpacity(.1),
                          tiles: list.map((Collection collection) {
                            final bool isCollected =
                                currentList.contains(collection.id);
                            return ListTile(
                              onTap: () async {
                                if (isCollected) {
                                  await pictureRepository
                                      .removePictureCollection(
                                    collection.id,
                                    widget.pictureId,
                                  );
                                  setState(() {
                                    currentList = currentList
                                        .where((int e) => e != collection.id)
                                        .toList();
                                  });
                                } else {
                                  await pictureRepository.addPictureCollection(
                                    collection.id,
                                    widget.pictureId,
                                  );
                                  setState(() {
                                    currentList.add(collection.id);
                                  });
                                }
                              },
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              subtitle: (collection.bio != null &&
                                      collection.bio!.isNotEmpty)
                                  ? Text(
                                      collection.bio ?? '',
                                      style: const TextStyle(
                                        fontSize: 12,
                                      ),
                                    )
                                  : null,
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: collection.preview != null &&
                                        collection.preview!.isNotEmpty
                                    ? OctoImage(
                                        width: 48,
                                        height: 48,
                                        placeholderBuilder:
                                            OctoBlurHashFix.placeHolder(
                                          collection.preview![0].blurhash,
                                        ),
                                        image: ExtendedImage.network(
                                          collection.preview![0].pictureUrl(
                                            style: PictureStyle.small,
                                          ),
                                        ).image,
                                        fit: BoxFit.cover,
                                      )
                                    : Container(
                                        color: theme.textTheme.bodyText2!.color!
                                            .withOpacity(.02),
                                        width: 48,
                                        height: 48,
                                      ),
                              ),
                              trailing: isCollected
                                  ? SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: SvgPicture.asset(
                                        'assets/feather/star-fill.svg',
                                        color: const Color(0xff47B881),
                                      ),
                                    )
                                  : null,
                              title: Row(
                                children: <Widget>[
                                  if (collection.isPrivate == true)
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 2, right: 6),
                                      height: 18,
                                      width: 18,
                                      child: SvgPicture.asset(
                                        'assets/remix/lock-fill.svg',
                                        color: Colors.amber.shade800,
                                      ),
                                    ),
                                  Expanded(
                                    child: Text(
                                      collection.name,
                                      overflow: TextOverflow.fade,
                                      maxLines: 1,
                                      softWrap: false,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                        ).toList(),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
