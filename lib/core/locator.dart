import 'package:flutter_demo_structure/core/db/app_db.dart';
import 'package:flutter_demo_structure/core/di/api/enc_text.dart';
import 'package:flutter_demo_structure/core/di/api/http_client.dart';
import 'package:flutter_demo_structure/core/di/api/repo/authentication_repository.dart';
import 'package:flutter_demo_structure/core/di/api/service/uthentication_services.dart';
import 'package:flutter_demo_structure/router/app_router.dart';
import 'package:flutter_demo_structure/ui/auth/login/store/login_store.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt.instance;

setupLocator() async {
  locator.registerSingleton(HttpClient());
  locator.registerSingleton(AppRouter());

  locator
      .registerSingleton(EncText(aesKey: "WQXy4CzZyUyJNOr5z5mvcR13dwxBGKnr"));
  locator.registerSingletonAsync<AppDB>(() => AppDB.getInstance());

  locator.registerLazySingleton<UserAuthService>(() => UserAuthService());
  locator.registerLazySingleton<UserAuthRepository>(() => UserAuthRepository());
  locator.registerSingleton<LoginStore>(LoginStore());
}
