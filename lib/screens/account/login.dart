import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/provider/account.dart';
import 'package:soap_app/provider/home.dart';
import 'package:soap_app/ui/widget/app_bar.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key key}) : super(key: key);

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController _accountController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _keyboard = false;

  double _height = 240;

  @override
  void initState() {
    super.initState();
    KeyboardVisibility.onChange.listen((bool visible) {
      if (_keyboard != visible && mounted) {
        setState(() {
          _keyboard = visible;
        });
        if (visible) {
          setState(() {
            _height = 120;
          });
        } else {
          setState(() {
            _height = 240;
          });
        }
        print(_height);
        print('Keyboard visibility update. Is visible: $visible');
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> login() async {
    final bool res =
        await Provider.of<AccountProvider>(context, listen: false).login(
      _accountController.text,
      _passwordController.text,
    );
    Provider.of<HomeProvider>(context, listen: false).reset();
    if (res) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return KeyboardDismissOnTap(
      child: Material(
        child: Container(
          color: Colors.blue,
          child: Stack(
            alignment: Alignment.center, //指定未定位或部分定位widget的对齐方式
            children: <Widget>[
              Flex(
                direction: Axis.vertical,
                // ignore: prefer_const_literals_to_create_immutables
                children: <Widget>[
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    height: _height,
                    alignment: Alignment.center,
                    curve: Curves.easeInBack,
                    child: Text(
                      '登录',
                      style: TextStyle(
                        color: theme.accentColor,
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
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(24),
                          topRight: Radius.circular(24),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 32,
                        ),
                        child: Column(
                          children: <Widget>[
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: TextField(
                                cursorColor: Colors.blue,
                                controller: _accountController,
                                textInputAction: TextInputAction.newline,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  ),
                                  hintText: '账号',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            Container(
                              decoration: const BoxDecoration(
                                color: Colors.black12,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8)),
                              ),
                              child: TextField(
                                controller: _passwordController,
                                cursorColor: Colors.blue,
                                obscureText: true,
                                style: const TextStyle(
                                  fontSize: 18,
                                ),
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintStyle: TextStyle(
                                    fontSize: 18,
                                  ),
                                  hintText: '密码',
                                  contentPadding: EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 16,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(
                              height: 18,
                            ),
                            SizedBox(
                              width: double.infinity,
                              child: TouchableOpacity(
                                activeOpacity: 0.8,
                                child: FlatButton(
                                  color: Colors.blue,
                                  padding: const EdgeInsets.symmetric(
                                    vertical: 10,
                                  ),
                                  splashColor: Colors.transparent,
                                  highlightColor: Colors.transparent,
                                  colorBrightness: Brightness.dark,
                                  child: const Text(
                                    '登录',
                                    style: TextStyle(
                                      fontSize: 16,
                                    ),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6)),
                                  onPressed: () {
                                    print('click');
                                    login();
                                  },
                                ),
                              ),
                            )
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
            ],
          ),
        ),
      ),
    );
  }
}
