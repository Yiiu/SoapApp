import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/config/config.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SoapButton extends StatelessWidget {
  const SoapButton({
    Key? key,
    this.onTap,
    this.borderRadius = 100,
    this.titleWidget,
    this.title,
    this.loading = false,
    this.backgroundColor,
  }) : super(key: key);

  final void Function()? onTap;
  final double borderRadius;
  final Widget? titleWidget;
  final String? title;
  final bool? loading;
  final Color? backgroundColor;

  @override
  Widget build(BuildContext context) {
    final Color _backgroundColor =
        backgroundColor ?? Theme.of(context).primaryColor;
    return TouchableOpacity(
      activeOpacity: loading! ? 1 : activeOpacity,
      onTap: loading! ? null : onTap,
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: loading! ? _backgroundColor.withOpacity(.8) : _backgroundColor,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        child: Center(
          child: Stack(
            children: [
              AnimatedOpacity(
                opacity: loading! ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: Center(
                  child: titleWidget ??
                      Text(
                        title ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                bottom: 0,
                child: AnimatedOpacity(
                  opacity: loading! ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: Center(
                    child: CupertinoTheme(
                      data: CupertinoTheme.of(context)
                          .copyWith(brightness: Brightness.dark),
                      child: const CupertinoActivityIndicator(),
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
