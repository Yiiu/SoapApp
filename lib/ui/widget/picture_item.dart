import 'package:flutter/material.dart';
import 'package:soap_app/config/router.dart';

import '../../model/picture.dart';
// import 'package:feather_icons_flutter/feather_icons_flutter.dart';

class PictureItem extends StatelessWidget {
  final Picture picture;
  PictureItem({this.picture});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(RouteName.test);
            },
            child: Column(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.all(12),
                  child: Row(
                    children: <Widget>[
                      ClipOval(
                        child: Image(
                          width: 40,
                          height: 40,
                          image: NetworkImage(picture.user.avatarUrl),
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: Text(
                          picture.user.fullName,
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image(
                      image: NetworkImage(picture.pictureUrl()),
                    ),
                  ),
                ),
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: 12),
                //   child: Icon(FeatherIcons.user),
                // )
              ],
            ),
          ),
        ],
      ),
    );
  }
}
