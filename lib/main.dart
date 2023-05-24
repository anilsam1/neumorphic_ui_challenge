import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/locator.dart';
import 'package:flutter_demo_structure/generated/l10n.dart';
import 'package:flutter_demo_structure/router/app_router.dart';
import 'package:flutter_demo_structure/ui/auth/model/user_profile_response.dart';
import 'package:flutter_demo_structure/values/export.dart';
import 'package:flutter_demo_structure/values/theme.dart';
import 'package:flutter_demo_structure/widget/custom_error_widget.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final appDocumentDir = Platform.isAndroid
      ? await getApplicationDocumentsDirectory()
      : await getLibraryDirectory();

  Hive
    ..init(appDocumentDir.path)
    ..registerAdapter(UserDataAdapter());

  await setupLocator();
  await locator.isReady<AppDB>();

  /// Disable debugPrint logs in production
  if (kReleaseMode) {
    debugPrint = (String? message, {int? wrapWidth}) {};
  }

  //await Firebase.initializeApp();

  // Fixing App Orientation.

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then(
    (value) => runZonedGuarded(() {
      ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
        return CustomErrorWidget(errorDetails: errorDetails);
      };
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
        title: 'Flutter Demo Structure',
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
        supportedLocales: S.delegate.supportedLocales,
      ),
    );
  }
}
