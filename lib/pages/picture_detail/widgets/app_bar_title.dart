import 'package:flutter/material.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../../config/config.dart';
import '../../../widget/avatar.dart';

class PictureAppBarTitle extends StatelessWidget {
  const PictureAppBarTitle({
    Key? key,
    required this.avatar,
    required this.fullName,
    required this.openUserPage,
  }) : super(key: key);

  final String avatar;
  final String fullName;
  final VoidCallback openUserPage;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(),
      child: Row(
        children: <Widget>[
          TouchableOpacity(
            activeOpacity: activeOpacity,
            onTap: () => openUserPage(),
            child: Avatar(
              size: 38,
              image: avatar,
            ),
          ),
          TouchableOpacity(
            activeOpacity: activeOpacity,
            behavior: HitTestBehavior.opaque,
            onTap: () => openUserPage(),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 8,
              ),
              child: Text(
                fullName,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 15,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
