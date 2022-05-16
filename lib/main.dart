import 'package:flutter/material.dart';
import 'package:login/screens/screens.dart';
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:login/theme_model.dart';
import 'routes/app_routes.dart';
import 'services/services.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); //Se asegura que el token este creado antes de que la aplicación se inicie con los widgets y no caiga la app
  await PushNotificacionService.initializeApp();

  runApp(const AppState());
}

class AppState extends StatelessWidget {
  const AppState({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => ServicioService()),
        ChangeNotifierProvider(create: (_) => TorneoService())
      ],
      child: const MyApp(),
    );
  }
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    PushNotificacionService.messagesStream.listen((message) {
      navigatorKey.currentState?.pushNamed('profile', arguments: message);
      final snackBar = SnackBar(content: Text(message));
      messengerKey.currentState?.showSnackBar(snackBar);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeModel(),
      child: Consumer<ThemeModel>(
        builder: (context, ThemeModel themeNotifier, child) {
          return MaterialApp(
            navigatorKey: navigatorKey,
            title: 'Material App',
            scaffoldMessengerKey: NotificacionsService.messengerKey,
            debugShowCheckedModeBanner: false,
            theme: themeNotifier.isDark
                ? ThemeData.dark().copyWith(
                    appBarTheme: const AppBarTheme(
                        backgroundColor: Colors.indigo,
                        centerTitle: true,
                        foregroundColor: Colors.white),
                    scaffoldBackgroundColor: Colors.black87,
                    textTheme: const TextTheme(),
                  )
                : ThemeData.light().copyWith(
                    appBarTheme: const AppBarTheme(
                        centerTitle: true, backgroundColor: Colors.indigo),
                    scaffoldBackgroundColor: Colors.white),
            home: const SplashScreen(),
            routes: AppRoutes.getRoutes(),
          );
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
      splash: "assets/logogiff.gif",
      backgroundColor: Colors.black,
      nextScreen: LoginScreen(),
      splashIconSize: 400,
      duration: 6000,
      splashTransition: SplashTransition.decoratedBoxTransition,
    );
  }
}
