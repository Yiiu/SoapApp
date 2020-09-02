import 'dart:convert';
import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/provider/picture_detail.dart';
import 'package:soap_app/screens/picture_detail/comment.dart';
import 'package:soap_app/screens/picture_detail/image.dart';
import 'package:soap_app/screens/picture_detail/info.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:soap_app/ui/widget/avatar.dart';
import 'package:soap_app/ui/widget/touchable_opacity.dart';

class OpenContainerWrapper extends StatelessWidget {
  const OpenContainerWrapper({
    this.closedBuilder,
    this.picture,
  });

  final CloseContainerBuilder closedBuilder;
  final Picture picture;

  @override
  Widget build(BuildContext context) {
    return OpenContainer(
      transitionType: ContainerTransitionType.fadeThrough,
      openBuilder: (BuildContext context, VoidCallback _) {
        return PictureDetail(picture: picture);
      },
      tappable: false,
      closedShape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(0)),
      ),
      closedElevation: 0.0,
      closedBuilder: closedBuilder,
    );
  }
}

class PictureDetail extends StatefulWidget {
  const PictureDetail({Key key, this.picture, this.scrollController})
      : super(key: key);

  final Picture picture;

  final ScrollController scrollController;

  @override
  _PictureDetailState createState() => _PictureDetailState();
}

class _PictureDetailState extends State<PictureDetail> {
  Picture picture;
  ScrollController scrollController;

  @override
  void initState() {
    picture = widget.picture;
    scrollController = widget.scrollController;
    super.initState();
    // 使用列表数据
    Provider.of<PictureDetailProvider>(context, listen: false).init(picture);
    setState(() {});
    // 获取完整数据
    Future.microtask(
      () => Provider.of<PictureDetailProvider>(context, listen: false)
          .getDetail(),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FixedAppBarWrapper(
      appBar: SoapAppBar(
        centerTitle: false,
        automaticallyImplyLeading: true,
        actionsPadding: const EdgeInsets.only(
          right: 12,
        ),
        elevation: 0.1,
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Row(
            children: <Widget>[
              Consumer<PictureDetailProvider>(builder: (
                BuildContext context,
                PictureDetailProvider detail,
                Widget child,
              ) {
                return Avatar(
                  size: 38,
                  image: detail.picture.user.avatarUrl,
                );
              }),
              Consumer<PictureDetailProvider>(builder: (
                BuildContext context,
                PictureDetailProvider detail,
                Widget child,
              ) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    detail.picture.user.fullName,
                    style: theme.textTheme.bodyText2.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 17,
                    ),
                  ),
                );
              }),
            ],
          ),
        ),
        actions: <Widget>[
          Center(
            child: TouchableOpacity(
              child: Text(
                '关注',
                style: theme.textTheme.bodyText2.copyWith(
                  color: theme.primaryColor,
                  fontSize: theme.textTheme.bodyText2.fontSize - 2,
                ),
              ),
              onPressed: () {},
            ),
          )
        ],
      ),
      body: Container(
        color: theme.backgroundColor,
        child: Stack(
          fit: StackFit.expand,
          children: <Widget>[
            ListView(
              padding: EdgeInsets.zero,
              controller: scrollController,
              physics: const BouncingScrollPhysics(
                parent: AlwaysScrollableScrollPhysics(),
              ),
              children: <Widget>[
                PictureDetailImage(),
                PictureDetailInfo(),
                const SizedBox(
                  height: 12,
                ),
                PictureDetailComment(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
