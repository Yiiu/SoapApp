import 'package:flutter/material.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

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
  late Animation<Offset> _opacityAnimation;

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
    return Positioned(
      child: Hero(
        tag: '_NewPictureDetailTopState',
        child: SlideTransition(
          position: _topAnimation,
          child: Stack(
            children: [
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
              Container(
                child: SoapAppBar(
                  backgroundColor: Colors.transparent,
                  textColor: Colors.white,
                  brightness: Brightness.dark,
                  automaticallyImplyLeading: true,
                  elevation: 0,
                  border: false,
                  centerTitle: false,
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
              ),
            ],
          ),
        ),
      ),
    );
  }
}
