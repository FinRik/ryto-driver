import 'package:flutter/material.dart';

import 'app/app.dart';
import 'core/config/multi_blocs_provider.dart';
import 'core/config/multi_repo_provider.dart';
import 'core/routes/router.dart';
import 'ui/styles/app_theme.dart';

Future<void> main() async {
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
