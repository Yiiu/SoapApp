import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:soap_app/config/const.dart';

/// Customized appbar.
/// 自定义的顶栏。
class SoapAppBar extends StatelessWidget {
  const SoapAppBar({
    Key key,
    this.automaticallyImplyLeading = false,
    this.title,
    this.centerTitle = true,
    this.backgroundColor,
    this.elevation = 2.0,
    this.actions,
    this.actionsPadding,
    this.height,
    this.brightness,
  }) : super(key: key);

  final Widget title;
  final List<Widget> actions;
  final EdgeInsetsGeometry actionsPadding;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color backgroundColor;
  final double elevation;
  final double height;
  final Brightness brightness;

  @override
  Widget build(BuildContext context) {
    Widget _title = title;
    if (centerTitle) {
      _title = Center(child: _title);
    }
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ThemeData theme = Theme.of(context);
    final Brightness baseBrightness =
        brightness ?? appBarTheme.brightness ?? theme.primaryColorBrightness;
    final SystemUiOverlayStyle overlayStyle = baseBrightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    return Material(
      type: MaterialType.transparency,
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: height ?? appBarHeight + MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            boxShadow: elevation > 0
                ? <BoxShadow>[
                    BoxShadow(
                      color: const Color(0x0d000000),
                      blurRadius: elevation * 1.0,
                      offset: Offset(0, elevation * 2.0),
                    ),
                  ]
                : null,
            color: backgroundColor ?? Theme.of(context).primaryColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              if (automaticallyImplyLeading && Navigator.of(context).canPop())
                const BackButton(),
              if (_title != null)
                Expanded(
                  child: Align(
                    alignment: centerTitle
                        ? Alignment.center
                        : AlignmentDirectional.centerStart,
                    child: DefaultTextStyle(
                      child: _title,
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 23.0),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              if (automaticallyImplyLeading &&
                  Navigator.of(context).canPop() &&
                  (actions?.isEmpty ?? true))
                const SizedBox(width: 48.0)
              else if (actions?.isNotEmpty ?? false)
                Padding(
                  padding: actionsPadding ?? EdgeInsets.zero,
                  child: Row(mainAxisSize: MainAxisSize.min, children: actions),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Wrapper for [FixedAppBar]. Avoid elevation covered by body.
/// 顶栏封装。防止内容块层级高于顶栏导致遮挡阴影。
class FixedAppBarWrapper extends StatelessWidget {
  const FixedAppBarWrapper({
    Key key,
    @required this.appBar,
    @required this.body,
  })  : assert(
          appBar != null && body != null,
          'All fields must not be null.',
        ),
        super(key: key);

  final SoapAppBar appBar;
  final Widget body;

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Stack(
        children: <Widget>[
          Positioned(
            top: appBarHeight + MediaQuery.of(context).padding.top,
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
        ],
      ),
    );
  }
}
