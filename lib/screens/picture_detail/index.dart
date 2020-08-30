import 'dart:convert';
import 'dart:typed_data';

import 'package:animations/animations.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_fade/image_fade.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/provider/account.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:soap_app/ui/widget/avatar.dart';

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
    super.initState();
    picture = widget.picture;
    scrollController = widget.scrollController;
  }

  @override
  void dispose() {
    super.dispose();
    // SystemChrome.setEnabledSystemUIOverlays(
    //     [SystemUiOverlay.top, SystemUiOverlay.bottom]);
  }

  Uint8List get bytes => base64
      .decode(picture.blurhashSrc.replaceAll('data:image/png;base64,', ''));

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final int id = picture.id;
    // blurhash
    final double num = picture.width / picture.height;
    final double minFactor = MediaQuery.of(context).size.width / 500;
    final account = Provider.of<AccountProvider>(context);
    final account2 = account;
    return FixedAppBarWrapper(
        appBar: SoapAppBar(
          centerTitle: true,
          automaticallyImplyLeading: true,
          elevation: 0.1,
          title: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              picture.title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
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
                  Container(
                    child: (num < minFactor && num < 1)
                        ? Container(
                            color: const Color(0xFFF8FAFC),
                            height: 500,
                            child: FractionallySizedBox(
                              widthFactor: picture.width / picture.height,
                              child: Hero(
                                tag: 'picture-$id',
                                child: ImageFade(
                                  fadeDuration:
                                      const Duration(milliseconds: 100),
                                  placeholder: Image.memory(
                                    bytes,
                                    fit: BoxFit.cover,
                                  ),
                                  image: CachedNetworkImageProvider(
                                      picture.pictureUrl()),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          )
                        : AspectRatio(
                            aspectRatio: picture.width / picture.height,
                            child: Hero(
                              tag: 'picture-$id',
                              child: ImageFade(
                                fadeDuration: const Duration(milliseconds: 100),
                                placeholder: Image.memory(
                                  bytes,
                                  fit: BoxFit.cover,
                                ),
                                image: CachedNetworkImageProvider(
                                    picture.pictureUrl()),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        Flex(
                          direction: Axis.horizontal,
                          children: <Widget>[
                            Expanded(
                              flex: 1,
                              child: Row(
                                children: <Widget>[
                                  CupertinoButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 36,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
                                        border: Border.all(
                                          color: const Color(0xFFE1E7EF),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 20),
                                        child: Row(
                                          children: <Widget>[
                                            const Icon(
                                              FeatherIcons.heart,
                                              color: Colors.red,
                                              size: 18,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              picture.likedCount.toString(),
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.w700,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 2,
                              child: Row(
                                textDirection: TextDirection.rtl,
                                children: <Widget>[
                                  CupertinoButton(
                                    onPressed: () {},
                                    child: Container(
                                      height: 36,
                                      width: 36,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(36.0),
                                        border: Border.all(
                                          color: const Color(0xFFE1E7EF),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          FeatherIcons.bookmark,
                                          color: Colors.black87,
                                          size: 18,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 16, horizontal: 20),
                          child: Flex(
                            direction: Axis.horizontal,
                            children: <Widget>[
                              Expanded(
                                flex: 2,
                                child: Row(
                                  children: <Widget>[
                                    Avatar(
                                      size: 46,
                                      image: picture.user.avatarUrl,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 12),
                                      child: Column(
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 6),
                                            child: Text(
                                              picture.user.fullName,
                                              style: GoogleFonts.rubik(
                                                textStyle: const TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 16,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text('${account2.user?.name ?? ''}'),
                      ],
                    ),
                  ),
                ],
              ),
              // Positioned(
              //   right: 16,
              //   top: MediaQuery.of(context).padding.top,
              //   child: CupertinoButton(
              //     onPressed: () => Navigator.pop(context),
              //     pressedOpacity: .8,
              //     child: ClipOval(
              //       child: Container(
              //         color: Color.fromRGBO(0, 0, 0, .6),
              //         width: 34,
              //         height: 34,
              //         child: Icon(
              //           FeatherIcons.x,
              //           color: Colors.white,
              //           size: 16,
              //         ),
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ));
  }
}
