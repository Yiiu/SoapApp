import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/config/config.dart';
import 'package:soap_app/widget/list/widget.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SoapListError extends StatelessWidget {
  const SoapListError({
    Key? key,
    this.notScrollView = false,
    required this.onRefresh,
    required this.controller,
    this.message,
  }) : super(key: key);

  final RefreshController controller;
  final VoidCallback onRefresh;
  final bool notScrollView;
  final String? message;

  @override
  Widget build(BuildContext context) {
    return SoapListWidget(
      controller: controller,
      notScrollView: notScrollView,
      onRefresh: onRefresh,
      child: SizedBox(
        height: double.infinity,
        child: TouchableOpacity(
          activeOpacity: activeOpacity,
          behavior: HitTestBehavior.opaque,
          onTap: () {
            controller.requestRefresh(
              duration: const Duration(milliseconds: 150),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Column(
                children: <Widget>[
                  const Icon(
                    FeatherIcons.alertCircle,
                    size: 42,
                    color: Colors.red,
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  if (message != null)
                    Text(
                      message!,
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    ),
                  const Text(
                    '出错惹, 点击重试',
                    style: TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
