import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class NewListFooter extends StatelessWidget {
  const NewListFooter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final double paddingBottom = MediaQuery.of(context).padding.bottom;
    return CustomFooter(
      height: 56 + MediaQuery.of(context).padding.bottom + 50,
      builder: (BuildContext context, LoadStatus? mode) {
        return Column(
          children: <Widget>[
            const SizedBox(
              height: 50,
              child: Center(
                child: Text('加载中'),
              ),
            ),
            SizedBox(
              height: 56 + paddingBottom,
            )
          ],
        );
      },
    );
  }
}
