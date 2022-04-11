import '../models/item_menu.dart';
import '../screens/screens.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String initialRoute = 'HomeScreen';
  static const String serviceseditRoute = 'servicioedit';
  static const String loginscreen = 'login';
  static const String serviciohome = 'servicios';
  static const String profileRoute = 'profile';
  static const String carrousel = 'slider';
  static const String torneosedit = 'torneosedit';
  static const String serviciosloading = 'loading';

  static final menuOptions = <ItemMenu>[
    ItemMenu(
      label: 'HomeScreen',
      route: initialRoute,
      screen: const HomeScreen(),
    ),
    ItemMenu(
      label: 'servicioedit',
      route: serviceseditRoute,
      screen: ServicioScreen(),
    ),
    ItemMenu(
      label: 'login',
      route: loginscreen,
      screen: LoginScreen(),
    ),
    ItemMenu(
      label: 'loading',
      route: serviciosloading,
      screen: LoadingScreen(),
    ),
    ItemMenu(
      label: 'torneosedit',
      route: torneosedit,
      screen: ToneoEditar(),
    ),
    ItemMenu(
      label: 'servicios',
      route: serviciohome,
      screen: ServicioHome(),
    ),
    ItemMenu(
      label: 'profile',
      route: profileRoute,
      screen: const ProfilePage(),
    ),

/*     ItemMenu(
      label: 'Perfil',
      route: profileRoute,
      screen: const ProfilePage(),
    ), */
  ];

  static Map<String, Widget Function(BuildContext)> getRoutes() {
    Map<String, Widget Function(BuildContext)> appRoutes = {};

    for (final item in menuOptions) {
      appRoutes.addAll({item.route: (BuildContext context) => item.screen});
    }
    return appRoutes;
  }
}
