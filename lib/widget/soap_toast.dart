import 'package:bot_toast/bot_toast.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';

class SoapToast {
  static void error(String title, {bool closeButton = true}) {
    BotToast.showSimpleNotification(
      title: title,
      backgroundColor: Colors.red,
      titleStyle: const TextStyle(color: Colors.white),
      subTitleStyle: const TextStyle(color: Colors.white),
      hideCloseButton: closeButton,
      closeIcon: const Icon(
        FeatherIcons.x,
        color: Colors.white,
      ),
    );
  }

  static void toast(String title, {bool closeButton = true}) {
    BotToast.showSimpleNotification(
      title: title,
      backgroundColor: const Color(0xff1890ff),
      titleStyle: const TextStyle(color: Colors.white),
      subTitleStyle: const TextStyle(color: Colors.white),
      hideCloseButton: closeButton,
      closeIcon: const Icon(
        FeatherIcons.x,
      ),
    );
  }

  static void success(String title, {bool closeButton = true}) {
    BotToast.showSimpleNotification(
      title: title,
      backgroundColor: const Color(0xff52c41a),
      titleStyle: const TextStyle(color: Colors.white),
      subTitleStyle: const TextStyle(color: Colors.white),
      hideCloseButton: closeButton,
      closeIcon: const Icon(
        FeatherIcons.x,
      ),
    );
  }

  static void loading(String title) {
    BotToast.showCustomLoading(
      toastBuilder: (_) {
        return Container(
          width: 100,
          height: 90,
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(.85),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const CupertinoActivityIndicator(),
              const SizedBox(height: 8),
              Text(title),
            ],
          ),
        );
      },
    );
  }

  static void confirm(
    String title, {
    required BuildContext context,
    // String?
    VoidCallback? cancel,
    VoidCallback? confirm,
    Widget? confirmText,
    Widget? cancelText,
  }) {
    BotToast.showAnimationWidget(
      clickClose: false,
      allowClick: false,
      onlyOne: true,
      crossPage: true,
      wrapToastAnimation: (controller, cancel, child) => Stack(
        children: <Widget>[
          GestureDetector(
            onTap: () {
              cancel();
            },
            //The DecoratedBox here is very important,he will fill the entire parent component
            child: AnimatedBuilder(
              builder: (_, child) => Opacity(
                opacity: controller.value,
                child: child,
              ),
              child: const DecoratedBox(
                decoration: BoxDecoration(color: Colors.black26),
                child: SizedBox.expand(),
              ),
              animation: controller,
            ),
          ),
          CustomOffsetAnimation(
            controller: controller,
            child: child,
          )
        ],
      ),
      toastBuilder: (cancelFunc) => AlertDialog(
        elevation: 0,
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
        title: Text(title),
        // insetPadding: EdgeInsets.symmetric(horizontal: 60, vertical: 24),
        // contentPadding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        actions: <Widget>[
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context)
                      .textTheme
                      .bodyText2!
                      .color!
                      .withOpacity(.7)),
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .color!
                        .withOpacity(0.12);
                  return Colors.transparent; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () {
              cancelFunc();
              cancel?.call();
            },
            child: cancelText ?? const Text('取消'),
          ),
          TextButton(
            style: ButtonStyle(
              foregroundColor: MaterialStateProperty.all<Color>(
                  Theme.of(context).errorColor),
              overlayColor: MaterialStateProperty.resolveWith<Color>(
                (Set<MaterialState> states) {
                  if (states.contains(MaterialState.hovered))
                    return Theme.of(context).errorColor.withOpacity(0.04);
                  if (states.contains(MaterialState.focused) ||
                      states.contains(MaterialState.pressed))
                    return Theme.of(context).errorColor.withOpacity(0.12);
                  return Colors.transparent; // Defer to the widget's default.
                },
              ),
            ),
            onPressed: () async {
              cancelFunc();
              confirm?.call();
            },
            child: confirmText ?? const Text('删除'),
          ),
          // Text('test'),
        ],
      ),
      animationDuration: const Duration(milliseconds: 300),
    );
  }
}

class CustomOffsetAnimation extends StatefulWidget {
  final AnimationController controller;
  final Widget child;

  const CustomOffsetAnimation({
    Key? key,
    required this.controller,
    required this.child,
  }) : super(key: key);

  @override
  _CustomOffsetAnimationState createState() => _CustomOffsetAnimationState();
}

class _CustomOffsetAnimationState extends State<CustomOffsetAnimation> {
  late Tween<Offset> tweenOffset;
  late Tween<double> tweenScale;

  late Animation<double> animation;

  @override
  void initState() {
    tweenOffset = Tween<Offset>(
      begin: const Offset(0.0, 0.02),
      end: Offset.zero,
    );
    tweenScale = Tween<double>(begin: 0.9, end: 1.0);
    animation = CurvedAnimation(parent: widget.controller, curve: Curves.ease);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      child: widget.child,
      animation: widget.controller,
      builder: (BuildContext context, Widget? child) {
        return FractionalTranslation(
          translation: tweenOffset.evaluate(animation),
          child: ClipRect(
            child: Transform.scale(
              scale: tweenScale.evaluate(animation),
              child: Opacity(
                child: child,
                opacity: animation.value,
              ),
            ),
          ),
        );
      },
    );
  }
}
