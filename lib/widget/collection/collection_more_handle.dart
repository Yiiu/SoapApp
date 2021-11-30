import 'package:flutter/material.dart';
import 'package:soap_app/model/collection.dart';
import 'package:soap_app/repository/collection_repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/collection/add_collection_modal.dart';
import 'package:soap_app/widget/modal_bottom_sheet.dart';
import 'package:soap_app/widget/more_handle_modal/more_handle_modal.dart';
import 'package:soap_app/widget/more_handle_modal/more_handle_modal_item.dart';
import 'package:soap_app/widget/soap_toast.dart';
import 'package:soap_app/widget/widgets.dart';

class CollectionMoreHandle extends StatelessWidget {
  CollectionMoreHandle({
    Key? key,
    required this.collection,
    required this.onRefresh,
  }) : super(key: key);

  final CollectionRepository _collectionRepository = CollectionRepository();

  final Collection collection;
  final VoidCallback onRefresh;

  bool get isOwner {
    if (accountStore.isLogin) {
      return accountStore.userInfo!.username == collection.user!.username;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return MoreHandleModal(
      title: '更多操作',
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Row(
          children: [
            // if (picture.isPrivate == null || !picture.isPrivate!) ...[
            //   MoreHandleModalItem(
            //     svg: 'assets/remix/share-line.svg',
            //     title: '分享',
            //     onTap: () {
            //       // Share.shareFiles([picture.pictureUrl()]);
            //     },
            //   ),
            //   const SizedBox(width: 24),
            // ],
            if (isOwner) ...[
              MoreHandleModalItem(
                svg: 'assets/remix/image-edit-line.svg',
                title: '编辑',
                onTap: () {
                  Navigator.of(context).pop();
                  showSoapBottomSheet(
                    context,
                    isScrollControlled: true,
                    child: AddCollectionModal(
                      refetch: onRefresh,
                      collection: collection,
                    ),
                  );
                  // Navigator.of(context).pushNamed(
                  //   RouteName.edit_picture,
                  //   arguments: {
                  //     'picture': picture,
                  //   },
                  // );
                },
              ),
              const SizedBox(width: 24),
              MoreHandleModalItem(
                svg: 'assets/remix/delete-bin-5-line.svg',
                title: '删除',
                color: theme.errorColor,
                onTap: () {
                  SoapToast.confirm(
                    '是否要删除收藏夹？',
                    context: context,
                    confirm: () async {
                      await _collectionRepository.delete(collection.id);
                      Navigator.of(context).pop();
                      onRefresh();
                      // Navigator.of(context).pop();
                    },
                  );
                },
              ),
            ]
          ],
        ),
      ),
    );
  }
}
