import '../models/item_menu.dart';
import '../screens/screens.dart';
import '../services/services.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String initialRoute = 'HomeScreen';
  static const String serviceseditRoute = 'servicioedit';
  static const String loginscreen = 'login';
  static const String serviciohome = 'servicios';
  static const String basicl = 'bl';
  static const String profileRoute = 'prof';
  static const String carrousel = 'slider';
  static const String regClub = 'regClubs';

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
      label: 'servicios',
      route: serviciohome,
      screen: ServicioHome(),
    ),
    ItemMenu(
      label: 'login',
      route: regClub,
      screen: LoginScreen(),
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
