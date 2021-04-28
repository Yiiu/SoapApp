import 'package:flutter/material.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/pages/picture_detail/image.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';

class PictureDetailPage extends StatelessWidget {
  PictureDetailPage({
    required this.picture,
    this.heroLabel,
  });
  Picture picture;
  String? heroLabel;
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    print(picture.isDark);
    return Material(
      child: FixedAppBarWrapper(
        appBar: SoapAppBar(
          automaticallyImplyLeading: true,
          elevation: 0.2,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 0),
            child: Row(
              children: <Widget>[
                Avatar(
                  size: 38,
                  image: picture.user!.avatarUrl,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    picture.user!.fullName,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
        body: MediaQuery.removePadding(
          removeTop: true,
          context: context,
          child: Container(
            color: theme.backgroundColor,
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                PictureDetailImage(
                  picture: picture,
                  heroLabel: heroLabel,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Text(
                    picture.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 20,
                      color: theme.textTheme.bodyText2!.color,
                    ),
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
