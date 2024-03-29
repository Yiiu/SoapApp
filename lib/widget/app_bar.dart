import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../config/theme.dart';

class SoapAppBar extends StatefulWidget {
  const SoapAppBar({
    Key? key,
    this.backdrop = false,
    this.automaticallyImplyLeading = false,
    this.title,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 2.0,
    this.actions,
    this.actionsPadding,
    this.height,
    this.brightness,
    this.textColor,
    this.border = false,
    this.topPadding = true,
    this.borderRadius,
  }) : super(key: key);

  final Widget? title;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? actionsPadding;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final bool border;
  final double? height;
  final Brightness? brightness;
  final Color? textColor;
  final bool backdrop;
  final bool topPadding;
  final BorderRadius? borderRadius;

  @override
  _SoapAppBarState createState() => _SoapAppBarState();
}

/// Customized appbar.
/// 自定义的顶栏。
class _SoapAppBarState extends State<SoapAppBar>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _title = widget.title ?? const Text('');
    if (widget.centerTitle) {
      _title = Center(child: _title);
    }
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ThemeData theme = Theme.of(context);
    final Brightness baseBrightness = widget.brightness ?? theme.brightness;
    // theme.primaryColorBrightness;
    final SystemUiOverlayStyle overlayStyle = baseBrightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    final Color barBg = widget.backgroundColor ?? theme.cardColor;
    final Widget content = AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: EdgeInsets.only(
            top: widget.topPadding ? MediaQuery.of(context).padding.top : 0),
        height: widget.height ??
            appBarHeight +
                (widget.topPadding ? MediaQuery.of(context).padding.top : 0),
        decoration: BoxDecoration(
          border: widget.border
              ? Border(
                  bottom: BorderSide(
                    color: theme.textTheme.overline!.color!.withOpacity(.2),
                    width: .2,
                  ),
                )
              : null,
          boxShadow: widget.elevation > 0
              ? <BoxShadow>[
                  BoxShadow(
                    color: const Color(0x0d000000),
                    blurRadius: widget.elevation * 1.0,
                    offset: Offset(0, widget.elevation * 2.0),
                  ),
                ]
              : null,
          color: widget.backdrop ? barBg.withOpacity(.85) : barBg,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            //  && Navigator.of(context).canPop()
            if (widget.automaticallyImplyLeading)
              Container(
                width: 48,
                padding: const EdgeInsets.only(left: 12),
                alignment: Alignment.centerLeft,
                child: TouchableOpacity(
                  activeOpacity: activeOpacity,
                  child: SizedBox(
                    child: Icon(
                      FeatherIcons.arrowLeft,
                      color:
                          widget.textColor ?? theme.textTheme.bodyText2!.color,
                    ),
                  ),
                  onTap: () {
                    Navigator.maybePop(context);
                  },
                ),
              ),
            if (_title != null)
              Expanded(
                child: Align(
                  alignment: widget.centerTitle
                      ? Alignment.center
                      : AlignmentDirectional.centerStart,
                  child: DefaultTextStyle(
                    style: theme.textTheme.bodyText2!.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    softWrap: false,
                    overflow: TextOverflow.ellipsis,
                    child: _title,
                  ),
                ),
              ),
            //  && Navigator.of(context).canPop()
            if (widget.automaticallyImplyLeading &&
                (widget.actions?.isEmpty ?? true))
              const SizedBox(width: 48.0)
            else if (widget.actions?.isNotEmpty ?? false)
              Padding(
                padding: widget.actionsPadding ?? EdgeInsets.zero,
                child: Row(
                    mainAxisSize: MainAxisSize.min, children: widget.actions!),
              ),
          ],
        ),
      ),
    );
    if (widget.backdrop) {
      if (widget.borderRadius == null) {
        return ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 16,
              sigmaY: 16,
            ),
            child: content,
          ),
        );
      }
      return ClipRRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: 16,
            sigmaY: 16,
          ),
          child: content,
        ),
      );
    }
    return SizedBox(
      child: content,
    );
  }
}

/// Wrapper for [FixedAppBar]. Avoid elevation covered by body.
/// 顶栏封装。防止内容块层级高于顶栏导致遮挡阴影。
class FixedAppBarWrapper extends StatelessWidget {
  const FixedAppBarWrapper({
    Key? key,
    required this.appBar,
    required this.body,
    this.backdropBar = false,
    this.position,
  }) : super(key: key);

  final Widget appBar;
  final Widget body;
  final Widget? position;
  final bool backdropBar;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: backdropBar
                ? 0
                : appBarHeight + MediaQuery.of(context).padding.top,
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: body,
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: appBar,
          ),
          if (position != null) position!,
        ],
      ),
    );
  }
}
