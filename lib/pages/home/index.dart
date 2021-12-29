import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../../config/router.dart';
import '../../store/index.dart';
import 'new/new.dart';
import 'profile/profile.dart';
import 'widgets/tab_view.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  List<Picture> list = <Picture>[];
  int _selectedIndex = 0;
  final int _addIndex = 1;
  late TabController tabController;

  final RefreshController _newRefreshController =
      RefreshController();

  @override
  void initState() {
    super.initState();
    tabController = TabController(
      length: 3,
      vsync: this,
      initialIndex: _selectedIndex,
    );
  }

  Future<void> handleTabChange(int index) async {
    if (index == 0 && tabController.index == 0) {
      _newRefreshController.requestRefresh(
        duration: const Duration(milliseconds: 150),
      );
    }
    if (index == _addIndex) {
      if (!accountStore.isLogin) {
        Navigator.pushNamed(context, RouteName.login);
        return;
      } else {
        final List<AssetEntity>? assets = await AssetPicker.pickAssets(
          context,
          routeCurve: Curves.easeOut,
          routeDuration: const Duration(milliseconds: 250),
          maxAssets: 1,
        );
        if (assets != null && assets.isNotEmpty) {
          Navigator.of(context).pushNamed(RouteName.add, arguments: {
            'assets': assets,
          });
        }
        return;
      }
    }
    setState(() {
      _selectedIndex = index;
      tabController.index = index;
    });
  }

  void signup() {}

  @override
  Widget build(BuildContext context) {
    return HomeTabView(
      tabController: tabController,
      onChange: handleTabChange,
      selectedIndex: _selectedIndex,
      child: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: <Widget>[
          NewView(
            refreshController: _newRefreshController,
          ),
          const Text(''),
          ProfileView(
            controller: tabController,
            signupCb: signup,
          ),
        ],
      ),
    );
  }
}
