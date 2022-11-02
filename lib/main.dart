import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/locator.dart';
import 'package:flutter_demo_structure/generated/l10n.dart';
import 'package:flutter_demo_structure/router/app_router.dart';
import 'package:flutter_demo_structure/ui/auth/model/user_profile_response.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/generated/l10n.dart';
import 'package:flutter_demo_structure/values/theme.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:url_strategy/url_strategy.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = await getApplicationDocumentsDirectory();

  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(UserDataAdapter());

  await setupLocator();
  await locator.isReady<AppDB>();
  setPathUrlStrategy();

  //await Firebase.initializeApp();

  // Fixing App Orientation.
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => runZonedGuarded(() {
      runApp(MyApp());
    }, (Object error, StackTrace stackTrace) {
      /// for debug:
      if (!kReleaseMode) {
        debugPrint('[Error]: ${error.toString()}');
        debugPrint('[Stacktrace]: ${stackTrace.toString()}');
      } else {}
    }),
  );
}

class MyApp extends StatelessWidget {
  final _appRouter = locator<AppRouter>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (context, child) => MaterialApp.router(
        title: S.current.appName,
        theme: appTheme,
        debugShowCheckedModeBanner: false,
        builder: (BuildContext context, Widget? widget) {
          return widget!;
        },
        routerDelegate: _appRouter.delegate(),
        routeInformationParser: _appRouter.defaultRouteParser(),
        localizationsDelegates: const [
          S.delegate,
        ],
        supportedLocales: [
          ...S.delegate.supportedLocales,
        ],
      ),
    );
  }
}
