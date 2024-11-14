import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:roqqu_assessment/src/core/constants/app_constants.dart';
import 'package:roqqu_assessment/src/core/theme/app_theme.dart';
import 'package:roqqu_assessment/src/dependencies/init_dependencies.dart';
import 'package:roqqu_assessment/src/features/home/presentation/controller/binance_controller.dart';
import 'package:roqqu_assessment/src/features/home/presentation/pages/home_page.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => serviceLocator<BinanceController>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstants.appName,
        theme: DesignThemes.lightThemeData,
        darkTheme: DesignThemes.darkThemeData,
        home: const HomePage(),
      ),
    );
  }
}
