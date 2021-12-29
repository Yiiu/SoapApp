import 'dart:io';
import 'dart:typed_data';

import 'package:extended_image/extended_image.dart' as extended_image;
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:share/share.dart';
import '../../../config/router.dart';
import '../../../model/picture.dart';
import '../../../repository/picture_repository.dart';
import '../../../store/index.dart';
import '../../../utils/image.dart';
import '../../../utils/picture.dart';
import '../../../widget/more_handle_modal/more_handle_modal.dart';
import '../../../widget/more_handle_modal/more_handle_modal_item.dart';
import '../../../widget/soap_toast.dart';

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
      title: FlutterI18n.translate(context, 'picture.more.title'),
      child: Padding(
        padding: const EdgeInsets.only(left: 24, right: 24, bottom: 16),
        child: Row(
          children: <Widget>[
            if (picture.isPrivate == null || !picture.isPrivate!) ...[
              MoreHandleModalItem(
                svg: 'assets/remix/share-line.svg',
                title: FlutterI18n.translate(context, 'common.label.share'),
                onTap: () async {
                  final File? data = await extended_image.getCachedImageFile(
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
                title: FlutterI18n.translate(context, 'common.label.edit'),
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
                title: FlutterI18n.translate(context, 'common.label.delete'),
                color: theme.errorColor,
                onTap: () {
                  SoapToast.confirm(
                    FlutterI18n.translate(context, 'picture.more.delete_title'),
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
