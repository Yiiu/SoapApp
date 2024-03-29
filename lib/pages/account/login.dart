import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../config/config.dart';
import '../../utils/utils.dart';
import '../../widget/widgets.dart';
import 'constants.dart';
import 'stores/login.store.dart';
import 'widgets/input.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final LoginStore store = LoginStore();

  @override
  void initState() {
    super.initState();
    store.setupValidations();
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
      store.setLoading(true);
      await store.login();
      SoapToast.success('登录成功');
      Navigator.of(context).popUntil((Route route) {
        if (route.settings.name == 'login') {
          return false;
        }
        return true;
      });
    } on DioError catch (e) {
      store.setLoading(false);
      if (e.response != null && e.response!.statusCode! >= 500) {
        SoapToast.error('服务器坏掉啦，请重试！');
      } else if (e.response?.data != null && e.response!.data is Map) {
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
              height: 48,
              width: 48,
              child: SvgPicture.asset(
                svg,
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
    return Material(
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
                  duration: const Duration(milliseconds: 300),
                  height: 280,
                  alignment: Alignment.center,
                  curve: Curves.easeInOut,
                  child: Text(
                    FlutterI18n.translate(context, 'login.title.login'),
                    style: TextStyle(
                      color: theme.textTheme.bodyText2!.color,
                      fontSize: 36,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Expanded(
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
                          Observer(
                            builder: (_) => SoapButton(
                              title: '登录',
                              loading: store.loading,
                              borderRadius: 8,
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  _oauthBtn(
                    svg: 'assets/svg/github.svg',
                    background: const Color(0xff171515),
                    color: theme.backgroundColor,
                    type: OauthType.github,
                  ),
                  _oauthBtn(
                    svg: 'assets/svg/weibo.svg',
                    background: const Color(0xffE6162D),
                    color: const Color(0xffe71f19),
                    type: OauthType.weibo,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
