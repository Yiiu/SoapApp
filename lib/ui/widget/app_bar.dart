import 'package:feather_icons_flutter/feather_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SoapAppBar extends StatefulWidget {
  final String title;
  final ScrollController controller;

  SoapAppBar({this.title, this.controller});

  @override
  SoapAppBarState createState() => SoapAppBarState();
}

class SoapAppBarState extends State<SoapAppBar> {
  String title;

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
        child: SizedBox(
          height: 60,
          child: Row(
            children: <Widget>[
              // Padding(
              //   padding: const EdgeInsets.only(top: 4),
              //   child: Container(
              //     width: AppBar().preferredSize.height - 8,
              //     height: AppBar().preferredSize.height - 8,
              //   ),
              // ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 12),
                  child: Text(
                    title,
                    style: GoogleFonts.rubik(
                      textStyle: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 0, right: 8),
                child: Container(
                  width: AppBar().preferredSize.height - 8,
                  height: AppBar().preferredSize.height - 8,
                  color: Colors.white,
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(
                        AppBar().preferredSize.height,
                      ),
                      child: Icon(
                        FeatherIcons.bell,
                      ),
                      onTap: () {},
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
