import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

import '../../widget/app_bar.dart';
import '../setting/widgets/setting_item.dart';

class MoreSettingPage extends StatefulWidget {
  const MoreSettingPage({
    Key? key,
    this.onChange,
    required this.isPrivate,
  }) : super(key: key);

  final bool isPrivate;
  final void Function(bool)? onChange;

  @override
  _MoreSettingPageState createState() => _MoreSettingPageState();
}

class _MoreSettingPageState extends State<MoreSettingPage> {
  final AdvancedSwitchController _controller = AdvancedSwitchController();
  @override
  void initState() {
    _controller.value = widget.isPrivate;
    super.initState();
  }

  @override
  void dispose() {
    if (widget.onChange != null) {
      widget.onChange!(_controller.value);
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).backgroundColor,
      child: FixedAppBarWrapper(
        appBar: const SoapAppBar(
          elevation: 0.5,
          automaticallyImplyLeading: true,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '更多设置',
            ),
          ),
        ),
        body: Column(
          children: <Widget>[
            SettingItem(
              title: '仅自己可见',
              actionIcon: false,
              border: false,
              action: AdvancedSwitch(
                controller: _controller,
              ),
              onPressed: () async {
                _controller.value = !_controller.value;
              },
            ),
          ],
        ),
      ),
    );
  }
}
