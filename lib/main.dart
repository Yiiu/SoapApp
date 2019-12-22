import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/config/graphql.dart';
import 'package:soap_app/config/router.dart';
import 'package:soap_app/provider/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(GraphQLProvider(client: GraphqlConfig.client, child: SoapApp()));
  if (Platform.isAndroid) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    );
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }
}

class SoapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        title: 'Soap',
        initialRoute: RouteName.home,
        onGenerateRoute: Router.generateRoute,
      ),
    );
  }
}
