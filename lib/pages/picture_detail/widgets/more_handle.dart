import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:share/share.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/repository/picture_repository.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/image.dart';
import 'package:soap_app/utils/picture.dart';
import 'package:soap_app/widget/more_handle_modal/more_handle_modal.dart';
import 'package:soap_app/widget/more_handle_modal/more_handle_modal_item.dart';
import 'package:soap_app/widget/soap_toast.dart';

class PictureDetailMoreHandle extends StatelessWidget {
  PictureDetailMoreHandle({
    Key? key,
    required this.picture,
  }) : super(key: key);

  final PictureRepository pictureRepository = PictureRepository();

  final Picture picture;

  bool get isOwner {
    if (accountStore.isLogin) {
      return accountStore.userInfo!.username == picture.user!.username;
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
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        child: Row(
          children: [
            if (picture.isPrivate == null || !picture.isPrivate!) ...[
              MoreHandleModalItem(
                svg: 'assets/remix/share-line.svg',
                title: FlutterI18n.translate(context, 'common.label.share'),
                onTap: () async {
                  final data = await getCachedImageFile(
                      picture.pictureUrl(style: PictureStyle.regular));
                  if (data != null) {
                    final Uint8List bytes = await data.readAsBytes();
                    final File file = await getImageFile(
                      bytes: bytes,
                      name: picture.key.split('/').last +
                          (picture.originalname?.split('.').last ?? '.jpg'),
                    );
                    print(file);
                    Share.shareFiles(
                      [file.path],
                      subject: picture.title,
                    );
                  }
                },
              ),
              const SizedBox(width: 24),
            ],
            if (isOwner) ...[
              MoreHandleModalItem(
                svg: 'assets/remix/image-edit-line.svg',
                title: '编辑',
                onTap: () {
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed(
                    RouteName.edit_picture,
                    arguments: {
                      'picture': picture,
                    },
                  );
                },
              ),
              const SizedBox(width: 24),
              MoreHandleModalItem(
                svg: 'assets/remix/delete-bin-5-line.svg',
                title: '删除',
                color: theme.errorColor,
                onTap: () {
                  SoapToast.confirm(
                    '是否要删除图片？',
                    context: context,
                    confirm: () async {
                      await pictureRepository.deletePicture(picture.id);
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
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
