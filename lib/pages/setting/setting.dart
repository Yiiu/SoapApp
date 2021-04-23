import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/svg.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/avatar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  Widget _itemBuild({
    required String title,
    Widget? action,
    Function()? onPressed,
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
                color: theme.textTheme.bodyText2!.color,
              ),
            ),
          ]
        ],
      ),
    );
    if (onPressed == null) {
      return Container(
        height: height,
        color: theme.cardColor,
        child: content,
      );
    }
    return Container(
      height: height,
      color: theme.cardColor,
      child: TouchableOpacity(
        onTap: onPressed,
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
        child: ListView(
          physics: const RangeMaintainingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            const SizedBox(height: 12),
            _itemBuild(
              title: '个人资料',
              action: Observer(
                builder: (_) => Avatar(
                  image: accountStore.userInfo!.avatarUrl,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(height: 12),
            // _itemBuild(
            //   title: '夜间模式',
            //   action: Container(
            //     width: 64,
            //     height: 32,
            //     child: Selector<AppProvider, bool>(
            //       selector: (
            //         BuildContext context,
            //         AppProvider provider,
            //       ) =>
            //           provider.isDarkMode,
            //       builder: (BuildContext context, bool isDarkMode, _) {
            //         return XlivSwitch(
            //           value: isDarkMode,
            //           onChanged: (bool va) {
            //             Provider.of<AppProvider>(context, listen: false)
            //                 .changeMode(va);
            //           },
            //         );
            //       },
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
