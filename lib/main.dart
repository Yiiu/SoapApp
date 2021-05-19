import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'config/graphql.dart';
import 'pages/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait<dynamic>({
    initHiveForFlutter(),
    DotEnv.load(fileName: '.env'),
    StorageUtil.initialize(),
    Jiffy.locale('zh_cn'),
  });
  accountStore.initialize();
  await Future.wait<dynamic>({
    pictureCachedStore.initialize(),
    appStore.initialize(),
  });
  SystemChrome.setPreferredOrientations(
      <DeviceOrientation>[DeviceOrientation.portraitUp]);
  SystemChrome.setEnabledSystemUIOverlays(<SystemUiOverlay>[
    SystemUiOverlay.top,
    SystemUiOverlay.bottom,
  ]);
  const SystemUiOverlayStyle systemUiOverlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.dark,
  );
  SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  runApp(
    GraphQLProvider(
      client: GraphqlConfig.client,
      child: const MyApp(),
    ),
  );
}
