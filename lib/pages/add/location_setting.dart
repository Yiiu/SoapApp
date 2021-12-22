import 'package:flutter/material.dart';
import 'package:searchfield/searchfield.dart';
import 'package:soap_app/pages/add/widgets/input.dart';
import 'package:soap_app/widget/widgets.dart';

class LocationSettingPage extends StatefulWidget {
  const LocationSettingPage({Key? key}) : super(key: key);

  @override
  _LocationSettingPageState createState() => _LocationSettingPageState();
}

class _LocationSettingPageState extends State<LocationSettingPage> {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: Theme.of(context).backgroundColor,
      child: FixedAppBarWrapper(
        appBar: const SoapAppBar(
          border: false,
          elevation: 0.5,
          automaticallyImplyLeading: true,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '拍摄位置',
            ),
          ),
        ),
        body: Container(
          child: Column(
            children: [
              Container(
                color: theme.cardColor,
                child: Row(
                  children: [],
                ),
              ),
              Text('21312'),
            ],
          ),
        ),
      ),
    );
  }
}
