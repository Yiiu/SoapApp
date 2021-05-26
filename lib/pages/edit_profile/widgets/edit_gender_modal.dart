import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/widget/modal_bottom/confirm_modal_bottom.dart';

class EditGenderModal extends StatefulWidget {
  const EditGenderModal({
    Key? key,
    required this.onOk,
    required this.gender,
    required this.genderSecret,
  }) : super(key: key);

  final int gender;
  final Future<void> Function(Map<String, Object?>) onOk;
  final bool genderSecret;

  @override
  _EditGenderModalState createState() => _EditGenderModalState();
}

class _EditGenderModalState extends State<EditGenderModal> {
  final AdvancedSwitchController _controller = AdvancedSwitchController();

  late int gender;
  late bool genderSecret;

  @override
  void initState() {
    gender = widget.gender;
    _controller.value = !widget.genderSecret;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmModalBottom(
      bottomPadding: 0,
      title: '编辑性别',
      onOk: () async {
        await widget.onOk.call({
          'gender': gender,
          'genderSecret': !_controller.value,
        });
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Container(
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('男'),
                    onTap: () {
                      setState(() {
                        gender = 0;
                      });
                    },
                    trailing: gender == 0
                        ? Icon(
                            FeatherIcons.check,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    selected: appStore.themeMode == ThemeMode.light,
                  ),
                  ListTile(
                    title: const Text('女'),
                    onTap: () {
                      setState(() {
                        gender = 1;
                      });
                    },
                    trailing: gender == 1
                        ? Icon(
                            FeatherIcons.check,
                            color: Theme.of(context).primaryColor,
                          )
                        : null,
                    selected: appStore.themeMode == ThemeMode.dark,
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(
                vertical: 0,
                horizontal: 0,
              ),
              title: Text(
                '是否展示性别',
                style: TextStyle(
                    fontSize: 14,
                    color: Theme.of(context)
                        .textTheme
                        .bodyText2!
                        .color!
                        .withOpacity(.8)),
              ),
              trailing: AdvancedSwitch(
                controller: _controller,
                width: 43.0,
                height: 25.0,
                activeColor: Theme.of(context).primaryColor,
              ),
              onTap: () {
                _controller.value = !_controller.value;
              },
            ),
          ),
        ],
      ),
    );
  }
}
