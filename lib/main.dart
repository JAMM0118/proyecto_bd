import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:proyecto_bd/config/router/app_router.dart';
import 'package:proyecto_bd/config/theme/app_theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
  
     SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp, // set orientation to portrait
        DeviceOrientation.portraitDown,
      ]);
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      theme: AppTheme().getTheme(),
    );
  }
}
 

