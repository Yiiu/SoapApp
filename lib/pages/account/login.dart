import 'dart:async';

import 'package:bot_toast/bot_toast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/pages/account/stores/login.store.dart';
import 'package:soap_app/utils/oauth.dart';
import 'package:soap_app/widget/app_bar.dart';
import 'package:soap_app/widget/soap_toast.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import 'constants.dart';
import 'widgets/input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginStore store = LoginStore();

  bool _keyboard = false;

  double _height = 280;

  @override
  void initState() {
    super.initState();
    store.setupValidations();
    final KeyboardVisibilityController keyboardVisibilityController =
        KeyboardVisibilityController();
    keyboardVisibilityController.onChange.listen((bool visible) {
      if (_keyboard != visible && mounted) {
        setState(() {
          _keyboard = visible;
        });
        if (visible) {
          setState(() {
            _height = 180;
          });
        } else {
          setState(() {
            _height = 280;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> login() async {
    if (store.username.isEmpty) {
      SoapToast.error('请输入用户名');
      return;
    }
    if (store.password.isEmpty) {
      SoapToast.error('请输入密码');
      return;
    }
    try {
      await store.login();
      SoapToast.success('登录成功');
      Navigator.of(context).restorablePopAndPushNamed(
        RouteName.home,
      );
    } on DioError catch (e) {
      if (e.response?.data['message'] != null) {
        SoapToast.error(errorMap[e.response?.data['message']] ?? '出错啦');
      }
    }
  }

  Widget _oauthBtn({
    required String svg,
    required OauthType type,
    required Color background,
    required Color color,
  }) =>
      TouchableOpacity(
        activeOpacity: activeOpacity,
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: background,
            borderRadius: BorderRadius.circular(100),
          ),
          child: Center(
            child: SizedBox(
              height: 26,
              width: 26,
              child: SvgPicture.asset(
                svg,
                color: color,
              ),
            ),
          ),
        ),
        onTap: () {
          Navigator.of(context).pushNamed(RouteName.oauth_webview, arguments: {
            'type': type,
          });
        },
      );

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return KeyboardDismissOnTap(
      child: Material(
        child: Container(
          color: theme.cardColor,
          // decoration: BoxDecoration(
          //   image: const DecorationImage(
          //     image: CachedNetworkImageProvider(
          //       'https://cdn-oss.soapphoto.com/photo/e1301207-fd76-41c0-b4e4-4f118b1669bb@!regular',
          //     ),
          //     fit: BoxFit.fitHeight,
          //     alignment: Alignment.topCenter,
          //   ),
          // ),
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Flex(
                direction: Axis.vertical,
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: _height,
                    alignment: Alignment.center,
                    curve: Curves.easeInOut,
                    child: Text(
                      '登录',
                      style: TextStyle(
                        color: theme.textTheme.bodyText2!.color,
                        fontSize: 36,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        // color: theme.cardColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          // vertical: 32,
                        ),
                        child: Column(
                          children: <Widget>[
                            Observer(
                              builder: (_) => Input(
                                label: '用户名',
                                errorText: store.error.username,
                                onChanged: store.setUsername,
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Observer(
                              builder: (_) => Input(
                                label: '密码',
                                password: true,
                                errorText: store.error.password,
                                onChanged: store.setPassword,
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TouchableOpacity(
                                activeOpacity: activeOpacity,
                                child: Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 12,
                                    horizontal: 24,
                                  ),
                                  decoration: BoxDecoration(
                                    color: theme.primaryColor,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Center(
                                    child: Text(
                                      '登录',
                                      style:
                                          theme.textTheme.bodyText2!.copyWith(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                                onTap: () {
                                  login();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const Positioned(
                top: 0,
                right: 0,
                left: 0,
                child: SoapAppBar(
                  backgroundColor: Colors.transparent,
                  automaticallyImplyLeading: true,
                  centerTitle: false,
                  elevation: 0,
                  // actionsPadding: const EdgeInsets.only(right: 8),
                  // actions: <Widget>[
                  //   IconButton(
                  //     icon: const Icon(
                  //       FeatherIcons.moreHorizontal,
                  //       size: 32,
                  //     ),
                  //     onPressed: () {
                  //       print('');
                  //     },
                  //   ),
                  // ],
                ),
              ),
              Positioned(
                bottom: 24,
                left: 0,
                right: 0,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _oauthBtn(
                      svg: 'assets/remix/github-line.svg',
                      background:
                          theme.textTheme.bodyText2!.color!.withOpacity(.95),
                      color: theme.backgroundColor,
                      type: OauthType.github,
                    ),
                    _oauthBtn(
                      svg: 'assets/remix/weibo-line.svg',
                      background: Color(0xffffda5d),
                      color: Color(0xffe71f19),
                      type: OauthType.weibo,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
