import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SoapToast {
  static void error(String title) {
    BotToast.showSimpleNotification(
      title: title,
      backgroundColor: Colors.red,
      titleStyle: const TextStyle(color: Colors.white),
      subTitleStyle: const TextStyle(color: Colors.white),
      closeIcon: const Icon(
        FeatherIcons.x,
        color: Colors.white,
      ),
    );
  }

  static void toast(String title) {
    BotToast.showSimpleNotification(
      title: title,
      backgroundColor: const Color(0xff1890ff),
      titleStyle: const TextStyle(color: Colors.white),
      subTitleStyle: const TextStyle(color: Colors.white),
      closeIcon: const Icon(
        FeatherIcons.x,
      ),
    );
  }

  static void success(String title) {
    BotToast.showSimpleNotification(
      title: title,
      backgroundColor: const Color(0xff52c41a),
      titleStyle: const TextStyle(color: Colors.white),
      subTitleStyle: const TextStyle(color: Colors.white),
      closeIcon: const Icon(
        FeatherIcons.x,
      ),
    );
  }
}
