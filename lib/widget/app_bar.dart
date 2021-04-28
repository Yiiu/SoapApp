import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/theme.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SoapAppBar extends StatefulWidget {
  const SoapAppBar({
    Key? key,
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
  }) : super(key: key);

  final Widget? title;
  final List<Widget>? actions;
  final EdgeInsetsGeometry? actionsPadding;
  final bool automaticallyImplyLeading;
  final bool centerTitle;
  final Color? backgroundColor;
  final double elevation;
  final double? height;
  final Brightness? brightness;
  final Color? textColor;

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
    Widget _title = widget.title ?? Text('');
    if (widget.centerTitle) {
      _title = Center(child: _title);
    }
    final AppBarTheme appBarTheme = AppBarTheme.of(context);
    final ThemeData theme = Theme.of(context);
    final Brightness baseBrightness =
        widget.brightness ?? appBarTheme.brightness ?? Brightness.light;
    // theme.primaryColorBrightness;
    final SystemUiOverlayStyle overlayStyle = baseBrightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;
    return Container(
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: overlayStyle,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top),
          height: widget.height ??
              appBarHeight + MediaQuery.of(context).padding.top,
          decoration: BoxDecoration(
            boxShadow: widget.elevation > 0
                ? <BoxShadow>[
                    BoxShadow(
                      color: const Color(0x0d000000),
                      blurRadius: widget.elevation * 1.0,
                      offset: Offset(0, widget.elevation * 2.0),
                    ),
                  ]
                : null,
            color: widget.backgroundColor ?? theme.cardColor,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              //  && Navigator.of(context).canPop()
              if (widget.automaticallyImplyLeading)
                Container(
                  width: 48,
                  padding: const EdgeInsets.only(left: 4),
                  alignment: Alignment.centerLeft,
                  child: TouchableOpacity(
                    activeOpacity: activeOpacity,
                    child: Container(
                      child: Icon(
                        FeatherIcons.arrowLeft,
                        color: widget.textColor ??
                            theme.textTheme.bodyText2!.color,
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
                      child: _title,
                      style: GoogleFonts.rubik(
                        textStyle: TextStyle(
                          fontSize: 20,
                          color: Theme.of(context).textTheme.bodyText1!.color,
                        ),
                      ),
                      maxLines: 1,
                      softWrap: false,
                      overflow: TextOverflow.ellipsis,
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
                      mainAxisSize: MainAxisSize.min,
                      children: widget.actions!),
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
    Key? key,
    required this.appBar,
    required this.body,
  })   : assert(
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
