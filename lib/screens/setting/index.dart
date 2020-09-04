import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/provider/account.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:soap_app/ui/widget/avatar.dart';
import 'package:soap_app/ui/widget/touchable_opacity.dart';

class SettingView extends StatefulWidget {
  @override
  _SettingViewState createState() => _SettingViewState();
}

class _SettingViewState extends State<SettingView> {
  Widget _itemBuild({
    @required String title,
    Widget action,
    Function() onPressed,
    double height = 62,
  }) {
    final ThemeData theme = Theme.of(context);
    final Container content = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      width: double.infinity,
      child: Flex(
        direction: Axis.horizontal,
        children: <Widget>[
          Expanded(
            flex: 1,
            child: Container(
              child: Text(title),
            ),
          ),
          if (action != null) action,
          const SizedBox(width: 6),
          if (onPressed != null) ...[
            Container(
              child: SvgPicture.asset(
                'assets/feather/chevron-right.svg',
                width: 26,
                height: 26,
                color: theme.textTheme.bodyText2.color,
              ),
            ),
          ]
        ],
      ),
    );
    if (onPressed == null) {
      return Container(
        height: height,
        color: Colors.white,
        child: content,
      );
    }
    return Container(
      height: height,
      color: Colors.white,
      child: TouchableOpacity(
        onPressed: onPressed,
        child: content,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FixedAppBarWrapper(
      appBar: const SoapAppBar(
        automaticallyImplyLeading: true,
        elevation: 0.2,
        actionsPadding: EdgeInsets.only(
          right: 12,
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            'Setting',
          ),
        ),
      ),
      body: Container(
        color: theme.backgroundColor,
        child: ListView(
          physics: const RangeMaintainingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            const SizedBox(height: 12),
            _itemBuild(
              title: '个人资料',
              action: Consumer<AccountProvider>(
                builder: (
                  BuildContext context,
                  AccountProvider account,
                  Widget child,
                ) {
                  return Avatar(
                    image: account.user.avatarUrl,
                    size: 32,
                  );
                },
              ),
            ),
            const SizedBox(height: 12),
            _itemBuild(
              title: '夜间模式',
            ),
          ],
        ),
      ),
    );
  }
}
