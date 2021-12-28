import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soap_app/widget/widgets.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      child: FixedAppBarWrapper(
        appBar: const SoapAppBar(
          automaticallyImplyLeading: true,
          elevation: 0.5,
          actionsPadding: EdgeInsets.only(
            right: 12,
          ),
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '关于肥皂',
            ),
          ),
        ),
        body: ListView(
          children: [
            Center(
              child: Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(200),
                  ),
                  border: Border.all(
                    color: Colors.black,
                    width: 10,
                  ),
                ),
                child: SvgPicture.asset('assets/svg/hzfe.svg'),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            const Center(
              child: Text(
                'HZFEStudio 出品 App',
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
