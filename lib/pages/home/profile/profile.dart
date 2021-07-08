import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/pages/home/profile/widgets/user_item.dart';
import 'package:soap_app/pages/home/profile/widgets/user_num_item.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    Key? key,
    required this.controller,
    required this.signupCb,
  }) : super(key: key);

  final TabController controller;
  final Function signupCb;

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late TabController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future<void> signup() async {
    widget.signupCb();
    await accountStore.signup();
    // controller.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return FixedAppBarWrapper(
      appBar: SoapAppBar(
        centerTitle: false,
        elevation: 0,
        border: true,
        actionsPadding: const EdgeInsets.only(
          right: 16,
        ),
        title: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Text(
            FlutterI18n.translate(context, 'nav.profile'),
          ),
        ),
        actions: <Widget>[
          TouchableOpacity(
            activeOpacity: activeOpacity,
            onTap: () {
              Navigator.pushNamed(context, RouteName.setting);
            },
            child: Icon(
              FeatherIcons.settings,
              color: theme.textTheme.bodyText2!.color,
            ),
          ),
        ],
      ),
      body: Container(
        color: Theme.of(context).backgroundColor,
        child: ListView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.all(0),
          children: <Widget>[
            const ProfileUserItem(),
            const ProfileUserNumItem(),
            const SizedBox(
              height: 12,
            ),
            Observer(
              builder: (_) => Visibility(
                visible: accountStore.isLogin,
                child: Container(
                  color: theme.cardColor,
                  child: TouchableOpacity(
                    activeOpacity: activeOpacity,
                    onTap: signup,
                    behavior: HitTestBehavior.opaque,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 12,
                      ),
                      child: Text(
                        FlutterI18n.translate(context, 'profile.btn.signout'),
                        style: TextStyle(
                          color: theme.errorColor,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
