import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:soap_app/pages/picture_detail/widgets/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../config/config.dart';
import '../../../model/picture.dart';
import '../../../widget/widgets.dart';

class NewPictureDetailTop extends StatefulWidget {
  const NewPictureDetailTop({
    Key? key,
    required this.controller,
    required this.picture,
  }) : super(key: key);

  final AnimationController controller;
  final Picture picture;

  @override
  _NewPictureDetailTopState createState() => _NewPictureDetailTopState();
}

class _NewPictureDetailTopState extends State<NewPictureDetailTop> {
  late Animation<Offset> _topAnimation;

  @override
  void initState() {
    super.initState();
    _topAnimation = Tween<Offset>(
      begin: Offset.zero,
      end: const Offset(0, -1),
    ).animate(
      CurvedAnimation(parent: widget.controller, curve: Curves.easeInOut),
    );
  }

  void openUserPage(BuildContext context) {
    Navigator.of(context).pushNamed(
      RouteName.user,
      arguments: {
        'user': widget.picture.user!,
        'heroId': '',
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Positioned(
      child: Hero(
        tag: '_NewPictureDetailTopState',
        child: SlideTransition(
          position: _topAnimation,
          child: Stack(
            children: <Widget>[
              Positioned(
                child: Container(
                  height: 120,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black45,
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),
              ),
              SoapAppBar(
                backgroundColor: Colors.transparent,
                textColor: Colors.white,
                brightness: Brightness.dark,
                automaticallyImplyLeading: true,
                elevation: 0,
                centerTitle: false,
                actions: [
                  TouchableOpacity(
                    activeOpacity: activeOpacity,
                    onTap: () {
                      showSoapBottomSheet<dynamic>(
                        context,
                        child: PictureDetailMoreHandle(
                          picture: widget.picture,
                        ),
                      );
                    },
                    child: const Padding(
                      padding: EdgeInsets.only(right: 12),
                      child: Icon(
                        FeatherIcons.moreHorizontal,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
                title: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 0),
                  child: TouchableOpacity(
                    activeOpacity: activeOpacity,
                    behavior: HitTestBehavior.opaque,
                    onTap: () => openUserPage(context),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Avatar(
                          size: 28,
                          image: widget.picture.user!.avatarUrl,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          child: Text(
                            widget.picture.user!.fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.white,
                            ),
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
      ),
    );
  }
}
