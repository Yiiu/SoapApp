import 'package:flutter/material.dart';
import 'package:soap_app/ui/widget/app_bar.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          SoapAppBar(
            title: 'Profile',
          ),
          Text('Profile'),
        ],
      ),
    );
  }
}
