import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:soap_app/pages/setting/widgets/setting_item.dart';
import 'package:soap_app/widget/app_bar.dart';

class MoreSettingPages extends StatelessWidget {
  MoreSettingPages({Key? key}) : super(key: key);

  final _controller = AdvancedSwitchController();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: FixedAppBarWrapper(
        appBar: const SoapAppBar(
          border: true,
          elevation: 0,
          automaticallyImplyLeading: true,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '更多设置',
            ),
          ),
        ),
        body: Column(
          children: [
            SettingItem(
              title: '仅自己可见',
              actionIcon: false,
              border: false,
              // action: Text('ss'),
              action: AdvancedSwitch(
                controller: _controller,
                // activeColor: Theme.of(context).primaryColor,
                // inactiveColor: Theme.of(context).backgroundColor,
                width: 50.0,
                height: 30.0,
              ),
              onPressed: () async {
                _controller.value = !_controller.value;
                // await clearDiskCachedImages();
                // getImageCached();
              },
            ),
          ],
        ),
      ),
    );
  }
}
