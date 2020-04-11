import 'package:flutter/material.dart';
import 'package:soap_app/ui/widget/app_bar.dart';

class SearchView extends StatelessWidget {
  const SearchView({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.backgroundColor,
      child: Column(
        children: <Widget>[
          SoapAppBar(
            title: 'Search',
          ),
          Text('Search'),
        ],
      ),
    );
  }
}
