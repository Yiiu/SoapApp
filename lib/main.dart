import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:provider/provider.dart';

import 'config/const.dart';
import 'config/graphql.dart';
import 'config/router.dart';
import 'provider/index.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  Jiffy.locale('zh-cn');
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
        initialRoute: RouteName.home,
        onGenerateRoute: Router.generateRoute,
        // themeMode: ThemeMode.dark,
        title: Constants.appName,
        theme: Constants.lightTheme,
        darkTheme: Constants.darkTheme,
      ),
    );
  }
}
