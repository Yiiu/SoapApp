import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:jiffy/jiffy.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:soap_app/store/index.dart';
import 'package:soap_app/utils/storage.dart';
// ignore: library_prefixes
import 'package:flutter_dotenv/flutter_dotenv.dart' as DotEnv;

import 'config/graphql.dart';
import 'pages/app.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Future.wait<dynamic>({
    initHiveForFlutter(),
    DotEnv.load(fileName: '.env'),
    StorageUtil.initialize(),
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
  await SentryFlutter.init(
    (SentryFlutterOptions options) {
      options.debug = false;
      options.dsn = DotEnv.env['SENTRY_URL'];
    },
    appRunner: () => runApp(GraphQLProvider(
      client: GraphqlConfig.client,
      child: const MyApp(),
    )),
  );
  accountStore.initializeSentry();
}
