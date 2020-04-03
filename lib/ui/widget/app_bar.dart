import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoapAppBar extends StatefulWidget {
  SoapAppBar({
    this.title,
    this.controller,
    this.leading,
    this.centerTitle = false,
    this.actions,
  });

  final String title;
  final ScrollController controller;
  final Widget leading;
  final bool centerTitle;
  final List<Widget> actions;

  @override
  SoapAppBarState createState() => SoapAppBarState();
}

class SoapAppBarState extends State<SoapAppBar> {
  String title;
  Widget leading;

  bool isTop = true;

  @override
  void initState() {
    super.initState();
    title = widget.title;
    if (widget.controller != null) {
      widget.controller.addListener(() {
        if (widget.controller.offset <= 0) {
          if (!isTop) setState(() => isTop = true);
        } else {
          if (isTop) setState(() => isTop = false);
        }
      });
    }
  }

  @override
  Widget build(BuildContext content) {
    bool centerTitle = widget.centerTitle;

    Widget actions;
    if (widget.actions != null && widget.actions.isNotEmpty) {
      actions = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: widget.actions,
      );
    } else if (centerTitle) {
      actions = Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            width: 46,
          ),
        ],
      );
    }

    Widget leading = widget.leading;

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              offset: Offset(0, 3.0),
              blurRadius: 12.0,
              spreadRadius: 2.0,
            ),
          ],
          // border: Border(
          //   bottom: BorderSide(
          //       color: Color.fromRGBO(243, 243, 244, 1), width: 1),
          // ),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 6),
          child: SizedBox(
            height: 60,
            child: Row(
              children: <Widget>[
                if (leading != null) leading,
                Expanded(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 12),
                      child: Text(
                        title,
                        textAlign:
                            centerTitle ? TextAlign.center : TextAlign.left,
                        style: GoogleFonts.rubik(
                          textStyle: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (actions != null) actions,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
