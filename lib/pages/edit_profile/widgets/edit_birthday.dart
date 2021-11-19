import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/widget/modal_bottom/confirm_modal_bottom.dart';
import 'package:soap_app/widget/select_list.dart';

class EditBirthday extends StatefulWidget {
  const EditBirthday({
    Key? key,
    this.birthday,
    this.birthdayShow,
    required this.onOk,
  }) : super(key: key);

  final String? birthday;
  final int? birthdayShow;
  final Future<void> Function(Map<String, Object?>) onOk;

  @override
  _EditBirthdayState createState() => _EditBirthdayState();
}

class _EditBirthdayState extends State<EditBirthday> {
  String? _value;
  late int birthdayShow;

  @override
  void initState() {
    if (widget.birthday != null) {
      _value = widget.birthday;
    }
    birthdayShow = widget.birthdayShow ?? 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConfirmModalBottom(
      bottomPadding: 16,
      topPadding: 0,
      onOk: () async {
        String? value;
        if (_value != null) {
          value = Jiffy(_value).format('yyyy-MM-dd');
        }
        await widget.onOk.call({
          'birthday': value,
          'birthdayShow': birthdayShow,
        });
      },
      child: Column(
        children: [
          DatePickerWidget(
            initDateTime: Jiffy(_value).dateTime,
            onChange: (DateTime date, List<int> _) {
              // print(Jiffy(date).format('yyyy-MM-dd'));
              // print(_);
              _value = Jiffy(date).format('yyyy-MM-dd');
            },
            pickerTheme: DateTimePickerTheme(
              pickerHeight: 220,
              showTitle: false,
              backgroundColor: Colors.transparent,
              itemTextStyle: TextStyle(
                color: Theme.of(context).textTheme.bodyText2!.color,
                fontSize: 14,
              ),
            ),
          ),
          SoapSelectList<int>(
            value: birthdayShow,
            onChange: (value) => setState(() {
              birthdayShow = value;
            }),
            config: <SelectTileConfig<int>>[
              SelectTileConfig<int>(title: '保密', value: 0),
              SelectTileConfig<int>(title: '显示日期', value: 1),
              SelectTileConfig<int>(title: '显示星座', value: 2),
            ],
          ),
        ],
      ),
    );
  }
}
