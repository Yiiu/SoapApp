// ignore_for_file: constant_identifier_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:soap_app/model/collection.dart';
import 'package:soap_app/model/picture.dart';
import 'package:soap_app/model/tag.dart';
import 'package:soap_app/model/user.dart';
import 'package:soap_app/pages/about/about.dart';
import 'package:soap_app/pages/account/login.dart';
import 'package:soap_app/pages/add/add.dart';
import 'package:soap_app/pages/collection_detail/collection_detail.dart';
import 'package:soap_app/pages/edit_profile/edit_profile.dart';
import 'package:soap_app/pages/home/index.dart';
import 'package:soap_app/pages/picture_detail/picture_detail.dart';
import 'package:soap_app/pages/setting/setting.dart';
import 'package:soap_app/pages/tag_detail/tag_detail.dart';
import 'package:soap_app/pages/user/user.dart';
import 'package:soap_app/pages/webview/oauth_webview.dart';
import 'package:soap_app/utils/oauth.dart';
import 'package:soap_app/widget/widgets.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class RouteName {
  static const String home = '/';
  static const String test = 'test';
  static const String picture_detail = 'picture_detail';
  static const String login = 'login';
  static const String user = 'user';
  static const String setting = 'setting';
  static const String collection_detail = 'collection_detail';
  static const String tag_detail = 'tag_detail';
  static const String webview = 'webview';
  static const String oauth_webview = 'oauth_webview';
  static const String add = 'add';
  static const String edit_picture = 'edit_picture';
  static const String edit_profile = 'edit_profile';
  static const String about = 'about';
}

// ignore: avoid_classes_with_only_static_members
class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RouteName.home:
        return CupertinoPageRoute<void>(
          builder: (_) => const HomePage(),
          settings: settings,
        );
      case RouteName.login:
        return CupertinoPageRoute<void>(
          builder: (_) => const LoginPage(),
          settings: settings,
        );
      case RouteName.user:
        return CupertinoPageRoute<void>(
          builder: (_) => UserPage(
            user: (settings.arguments! as dynamic)['user'] as User,
            heroId: (settings.arguments! as dynamic)['heroId'] as String,
          ),
        );
      case RouteName.picture_detail:
        return CupertinoPageRoute<void>(
          builder: (_) => PictureDetailPage(
            picture: (settings.arguments! as dynamic)['picture'] as Picture,
            heroLabel: (settings.arguments! as dynamic)['heroLabel'] as String?,
          ),
        );
      case RouteName.setting:
        return CupertinoPageRoute<void>(
          builder: (_) => const SettingPage(),
        );
      case RouteName.collection_detail:
        return CupertinoPageRoute<void>(
          builder: (_) => CollectionDetailPage(
            collection:
                (settings.arguments! as dynamic)['collection'] as Collection,
          ),
        );
      case RouteName.tag_detail:
        return CupertinoPageRoute<void>(
          builder: (_) => TagDetailPage(
            tag: (settings.arguments! as dynamic)['tag'] as Tag,
          ),
        );
      // case RouteName.webview:
      //   return MaterialPageRoute<void>(
      //     builder: (_) => WebViewPage(
      //         // tag: (settings.arguments!   as dynamic)['tag'] as Tag,
      //         ),
      //   );
      case RouteName.oauth_webview:
        return MaterialPageRoute<void>(
          builder: (_) => OauthWebViewPage(
            type: (settings.arguments! as dynamic)['type'] as OauthType,
          ),
        );
      case RouteName.add:
        return HeroDialogRoute<void>(
          builder: (_) => AddPage(
            assets:
                (settings.arguments! as dynamic)['assets'] as List<AssetEntity>,
          ),
        );
      case RouteName.edit_picture:
        return MaterialPageRoute<void>(
          builder: (_) => AddPage(
            edit: true,
            picture: (settings.arguments as dynamic)!['picture'] as Picture?,
          ),
        );
      case RouteName.edit_profile:
        return MaterialPageRoute<void>(
          builder: (_) => EditProfilePage(),
        );
      case RouteName.about:
        return MaterialPageRoute<void>(
          builder: (_) => const AboutPage(),
        );
      default:
        return CupertinoPageRoute<void>(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
