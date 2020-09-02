import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:image_fade/image_fade.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/ui/widget/transparent_image.dart';
import 'package:soap_app/utils/picture.dart';

class UserView extends StatefulWidget {
  const UserView({
    Key key,
    @required this.user,
  }) : super(key: key);

  final User user;

  @override
  _UserViewState createState() => _UserViewState();
}

class _UserViewState extends State<UserView> {
  User user;

  @override
  void initState() {
    user = widget.user;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Container(
              width: double.infinity,
              height: 260,
              child: Stack(
                children: <Widget>[
                  ImageFade(
                    width: double.infinity,
                    fadeDuration: const Duration(milliseconds: 100),
                    placeholder: Image.memory(
                      transparentImage,
                      fit: BoxFit.cover,
                      gaplessPlayback: true,
                    ),
                    image: CachedNetworkImageProvider(
                      getPictureUrl(key: user.cover ?? user.avatar),
                    ),
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    bottom: 0,
                    child: Container(
                      color: Colors.black.withOpacity(.5),
                      child: Text('123'),
                    ),
                  ),
                ],
              ),
            ),
            Text(user.fullName)
          ],
        ),
      ),
    );
  }
}
