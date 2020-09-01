import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';
import 'package:soap_app/utils/storage.dart';

import 'config/const.dart';
import 'config/graphql.dart';
import 'config/router.dart' as RouterConfig;
import 'provider/index.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Jiffy.locale('zh-cn');
  // Lock orientation to portrait only
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  await StorageUtil.initialize();
  runApp(GraphQLProvider(client: GraphqlConfig.client, child: SoapApp()));
  const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // if (Platform.isAndroid) {
  //   SystemChrome.setEnabledSystemUIOverlays([]);
  //   SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
  //     statusBarColor: Colors.transparent,
  //     statusBarIconBrightness: Brightness.dark,
  //   );
  //   SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  // }
}

// void main() => runApp(MyApp());

class SoapApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: providers,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: RouterConfig.RouteName.home,
        onGenerateRoute: RouterConfig.Router.generateRoute,
        // themeMode: ThemeMode.dark,
        title: Constants.appName,
        theme: Constants.lightTheme,
        darkTheme: Constants.darkTheme,
      ),
    );
  }
}
