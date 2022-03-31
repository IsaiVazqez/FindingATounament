import 'package:flutter/material.dart';
import 'package:login/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:login/theme_model.dart';
import 'routes/app_routes.dart';
import 'services/services.dart';

void main() => runApp(AppState());

class AppState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ServicioService()),
        ChangeNotifierProvider(create: (_) => TorneoService())
      ],
      child: MyApp(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            title: 'Material App',
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.isDark
                ? ThemeData.dark().copyWith(
                    appBarTheme: const AppBarTheme(
                        backgroundColor: Colors.indigo,
                        centerTitle: true,
                        foregroundColor: Colors.white),
                    scaffoldBackgroundColor: Colors.black87,
/*                     textTheme: TextTheme(
                      bodyText1: TextStyle(),
                      bodyText2: TextStyle(),
                    ).apply(
                      bodyColor: Colors.orange,
                      displayColor: Colors.blue,
                    ), */
                    textTheme: TextTheme(),
                  )
                : ThemeData.light().copyWith(
                    appBarTheme: const AppBarTheme(
                        centerTitle: true, backgroundColor: Colors.indigo),
                    scaffoldBackgroundColor: Colors.white),
            home: const SplashScreen(),
            routes: AppRoutes
                .getRoutes(), /*       initialRoute: Login.id,
      routes: {
        Login.id: (context) => Login(), */
          );
          dividerColor:
          Colors.black;
        },
      ),
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      splash: "assets/Comp 1.gif",
      backgroundColor: Colors.black,
      nextScreen: LoginScreen(),
      splashIconSize: 400,
      duration: 6000,
      splashTransition: SplashTransition.decoratedBoxTransition,
    );
  }
}
