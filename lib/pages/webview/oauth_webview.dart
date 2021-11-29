import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:soap_app/config/const.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/oauth.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:touchable_opacity/touchable_opacity.dart';
import 'package:url_launcher/url_launcher.dart';

class OauthWebViewPage extends StatefulWidget {
  const OauthWebViewPage({Key? key, required this.type}) : super(key: key);

  final OauthType type;

  @override
  _OauthWebViewPageState createState() => _OauthWebViewPageState();
}

class _OauthWebViewPageState extends State<OauthWebViewPage> {
  late InAppWebViewController _webViewController;

  InAppWebViewGroupOptions options = InAppWebViewGroupOptions(
    crossPlatform: InAppWebViewOptions(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
    ),
    android: AndroidInAppWebViewOptions(
      useHybridComposition: true,
    ),
    ios: IOSInAppWebViewOptions(
      allowsInlineMediaPlayback: true,
    ),
  );

  bool isOk = false;
  String title = '';
  double progressValue = 0.0;
  String url = '';

  final GlobalKey _webviewKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Material(
      child: FixedAppBarWrapper(
        appBar: SoapAppBar(
          border: true,
          automaticallyImplyLeading: true,
          elevation: 0,
          title: const Text('登录'),
          actionsPadding: const EdgeInsets.only(
            right: 12,
          ),
          actions: [
            TouchableOpacity(
              activeOpacity: activeOpacity,
              onTap: () {
                _webViewController.reload();
              },
              child: Icon(
                FeatherIcons.rotateCw,
                size: 22,
                color: Theme.of(context).textTheme.bodyText2!.color,
              ),
            ),
          ],
        ),
        body: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: InAppWebView(
                initialOptions: options,
                key: _webviewKey,
                onWebViewCreated: (InAppWebViewController controller) {
                  _webViewController = controller;
                },
                initialUrlRequest: URLRequest(
                  url: getOauthUrl(widget.type, OauthStateType.login),
                ),
                onLoadStart: (InAppWebViewController controller, Uri? uri) {
                  setState(() {
                    if (uri != null) {
                      url = uri.toString();
                    }
                  });
                },
                onLoadStop: (InAppWebViewController _, Uri? uri) async {
                  if (uri != null) {
                    if (uri.host == 'soapphoto.com' && !isOk) {
                      if (RegExp('^/redirect/oauth').hasMatch(uri.path)) {
                        isOk = true;
                        final bool isLogin =
                            await accountStore.oauthCallback(uri);
                        if (isLogin) {
                          Navigator.of(context).restorablePopAndPushNamed(
                            RouteName.home,
                            // (Route<dynamic> route) => route == null,
                          );
                          SoapToast.success('登录成功！');
                        } else {
                          Navigator.of(context).pop();
                        }
                      }
                    }
                  }
                },
                onProgressChanged: (
                  InAppWebViewController controller,
                  int progress,
                ) async {
                  setState(() {
                    progressValue = progress / 100;
                  });
                },
                shouldOverrideUrlLoading: (controller, navigationAction) async {
                  var uri = navigationAction.request.url!;

                  if (![
                    'http',
                    'https',
                    'file',
                    'chrome',
                    'data',
                    'javascript',
                    'about'
                  ].contains(uri.scheme)) {
                    try {
                      await launch(
                        uri.toString(),
                      );
                    } catch (e) {}
                    // and cancel the request
                    return NavigationActionPolicy.CANCEL;
                  }

                  return NavigationActionPolicy.ALLOW;
                },
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AnimatedOpacity(
                opacity: progressValue == 1 ? 0 : 1,
                duration: const Duration(milliseconds: 300),
                child: SizedBox(
                  height: 2,
                  child: LinearProgressIndicator(
                    value: progressValue,
                    valueColor: const AlwaysStoppedAnimation(Color(0xff52c41a)),
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
