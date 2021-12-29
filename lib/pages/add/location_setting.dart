import 'package:flutter/material.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:touchable_opacity/touchable_opacity.dart';

import '../../config/config.dart';
import '../../graphql/graphql.dart';
import '../../model/location.dart';
import '../../widget/widgets.dart';

class LocationSettingPage extends StatefulWidget {
  const LocationSettingPage({
    Key? key,
    this.onChange,
  }) : super(key: key);

  final void Function(Location?)? onChange;

  @override
  _LocationSettingPageState createState() => _LocationSettingPageState();
}

class _LocationSettingPageState extends State<LocationSettingPage> {
  final TextEditingController _regionController = TextEditingController();
  final TextEditingController _valueController = TextEditingController();

  List placeList = <dynamic>[];

  Location? selected;

  Future<void> search() async {
    if (_valueController.text == '') {
      return;
    }
    final QueryResult data = await GraphqlConfig.graphQLClient.query(
      QueryOptions(
        document: addFragments(
          searchPlace,
          [...locationFragmentDocumentNode],
        ),
        variables: <String, String>{
          'value': _valueController.text,
          'region': _regionController.text,
        },
      ),
    );
    setState(() {
      placeList = (data.data!['searchPlace'] as List<dynamic>)
          .toList()
          .where((dynamic place) => place['uid'] != null)
          .toList();
    });
  }

  Future onSelected(Map<String, dynamic>? data) async {
    if (data != null) {
      final QueryResult detail = await GraphqlConfig.graphQLClient.query(
        QueryOptions(
          document: addFragments(
            placeDetail,
            [...locationFragmentDocumentNode],
          ),
          // ignore: always_specify_types
          variables: <String, dynamic>{'uid': data['uid']},
        ),
      );
      setState(() {
        selected = Location.fromJson(
          detail.data?['placeDetail'] as Map<String, dynamic>? ?? data,
        );
      });
    } else {
      setState(() {
        selected = Location.fromJson(data!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: Theme.of(context).backgroundColor,
      child: FixedAppBarWrapper(
        appBar: SoapAppBar(
          elevation: 0.5,
          automaticallyImplyLeading: true,
          title: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '拍摄位置',
            ),
          ),
          actions: [
            TouchableOpacity(
              behavior: HitTestBehavior.opaque,
              activeOpacity: activeOpacity,
              onTap: () {
                Navigator.of(context).maybePop();
                if (widget.onChange != null) {
                  widget.onChange!(selected);
                }
                // Navigator.pushNamed(context, RouteName.setting);
              },
              child: Padding(
                padding: const EdgeInsets.only(
                  right: 12,
                  left: 4,
                  top: 4,
                  bottom: 4,
                ),
                child: Icon(
                  FeatherIcons.checkCircle,
                  color: theme.primaryColor,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: theme.cardColor,
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 3,
                    child: SizedBox(
                      height: 38,
                      child: TextField(
                        controller: _regionController,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: '城市',
                          fillColor: theme.backgroundColor,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(32),
                              bottomLeft: Radius.circular(32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 32,
                    color: theme.cardColor,
                    child: Center(
                      child: Container(
                        width: 0.4,
                        height: 14,
                        color: theme.textTheme.overline!.color!.withOpacity(.1),
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: SizedBox(
                      height: 38,
                      child: TextField(
                        controller: _valueController,
                        style: const TextStyle(
                          fontSize: 14,
                        ),
                        decoration: InputDecoration(
                          hintText: '地点',
                          fillColor: theme.backgroundColor,
                          filled: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 12),
                          border: const OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(32),
                              bottomRight: Radius.circular(32),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  TouchableOpacity(
                    activeOpacity: activeOpacity,
                    onTap: () {
                      search();
                    },
                    child: Container(
                      margin: const EdgeInsets.only(left: 12),
                      width: 40,
                      child: Center(
                        child: Text(
                          '搜索',
                          style: TextStyle(
                            color: theme.primaryColor,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: MediaQuery.removePadding(
                removeTop: true,
                context: context,
                child: ListView.builder(
                  itemCount: placeList.length + 1,
                  physics: const BouncingScrollPhysics(),
                  itemBuilder: (_, int i) {
                    if (i == 0) {
                      return ListTile(
                        title: const Text('不显示位置'),
                        tileColor: theme.cardColor,
                        onTap: () {
                          onSelected(null);
                        },
                        selected: selected == null,
                        selectedTileColor: theme.cardColor,
                        trailing: selected == null
                            ? Icon(
                                FeatherIcons.check,
                                color: Theme.of(context).primaryColor,
                              )
                            : null,
                      );
                    } else {
                      final bool s = selected?.uid == placeList[i - 1]['uid'];
                      return ListTile(
                        title: Text(placeList[i - 1]?['name'] as String),
                        subtitle:
                            Text(placeList[i - 1]?['address'] as String? ?? ''),
                        tileColor: theme.cardColor,
                        selected: s,
                        onTap: () {
                          onSelected(placeList[i - 1] as Map<String, dynamic>);
                        },
                        trailing: s
                            ? Icon(
                                FeatherIcons.check,
                                color: Theme.of(context).primaryColor,
                              )
                            : null,
                      );
                    }
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
