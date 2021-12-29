import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';
import '../../../widget/widgets.dart';

class EditGenderModal extends StatefulWidget {
  const EditGenderModal({
    Key? key,
    required this.gender,
    required this.genderSecret,
    required this.onOk,
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
          SoapSelectList<int>(
            value: gender,
            onChange: (int value) => setState(() {
              gender = value;
            }),
            config: <SelectTileConfig<int>>[
              SelectTileConfig<int>(title: '男', value: 0),
              SelectTileConfig<int>(title: '女', value: 1),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: ListTile(
              dense: true,
              contentPadding: const EdgeInsets.symmetric(
                
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
