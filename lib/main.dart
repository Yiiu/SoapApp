import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import 'pages/app.dart';

void main() async {
  await initHiveForFlutter();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIOverlays([
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);
  const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  final HttpLink httpLink = HttpLink(
    'https://soapphoto.com/graphql',
  );
  ValueNotifier<GraphQLClient> client = ValueNotifier(
    GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: HiveStore()),
    ),
  );
  runApp(
    GraphQLProvider(
      client: client,
      child: MyApp(),
    ),
  );
}
