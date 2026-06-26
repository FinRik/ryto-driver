import 'dart:io';

import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/config/multi_blocs_provider.dart';
import 'core/config/multi_repo_provider.dart';
import 'core/routes/router.dart';
import 'ui/styles/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  await App.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiRepoProvider(
      child: MultiBlocsProvider(
        child: MaterialApp.router(
          title: 'Ryto Driver',
          debugShowCheckedModeBanner: false,
          routerDelegate: router.routerDelegate,
          scaffoldMessengerKey: scaffoldMessengerKey,
          routeInformationParser: router.routeInformationParser,
          routeInformationProvider: router.routeInformationProvider,

          theme: AppTheme.light,
          darkTheme: AppTheme.dark,
          themeMode: ThemeMode.light,

          builder: (context, child) => child!,
        ),
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}