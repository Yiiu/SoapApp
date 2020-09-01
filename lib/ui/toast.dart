import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/material.dart';

mixin Toast {
  static void showText(String text) {
    BotToast.showText(
      text: text,
      contentColor: Colors.black.withOpacity(.8),
      clickClose: true,
    );
  }
}
