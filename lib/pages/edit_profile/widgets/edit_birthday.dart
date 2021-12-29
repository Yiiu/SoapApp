import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:jiffy/jiffy.dart';

import '../../../widget/widgets.dart';

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
        children: <Widget>[
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
            onChange: (int value) => setState(() {
              birthdayShow = value;
            }),
            config: <SelectTileConfig<int>>[
              SelectTileConfig<int>(
                  title: FlutterI18n.translate(
                      context, "profile.edit.label.birthday_secret"),
                  value: 0),
              SelectTileConfig<int>(
                  title: FlutterI18n.translate(
                      context, "profile.edit.label.birthday_show_day"),
                  value: 1),
              SelectTileConfig<int>(
                  title: FlutterI18n.translate(
                      context, "profile.edit.label.birthday_show horoscope"),
                  value: 2),
            ],
          ),
        ],
      ),
    );
  }
}
