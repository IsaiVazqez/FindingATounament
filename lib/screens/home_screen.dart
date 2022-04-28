import 'package:login/routes/AnimationPageRoute.dart';
import 'package:login/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:login/screens/torneos_screen.dart';
import 'package:login/services/auth_service.dart';
import 'package:provider/provider.dart';
import '../theme_model.dart';
import 'serviciohome_screen.dart';
import 'package:google_nav_bar/google_nav_bar.dart' show GButton, GNav;
import 'package:line_icons/line_icons.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int home = 0;
  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context, listen: false);
    return Consumer<ThemeModel>(
      builder: (context, ThemeModel themeNotifier, child) {
        return Scaffold(
          appBar: AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(10))),
            automaticallyImplyLeading: false,
            title: const Text(
              'Finding A Tournament',
            ),
            elevation: 0,
            titleTextStyle: const TextStyle(
              fontSize: 20,
              color: Colors.white,
              fontFamily: 'SFPRODISPLAY2',
              fontWeight: FontWeight.bold,
            ),
            actions: [
              IconButton(
                  color: const Color.fromARGB(255, 255, 255, 255),
                  icon: Icon(themeNotifier.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny),
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  })
            ],
            leading: IconButton(
                icon: Icon(Icons.login_outlined),
                onPressed: () {
                  authService.logout();
                  Navigator.pushReplacementNamed(context, 'login');
                }),
          ),
          body: SafeArea(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(
                8.0,
              ),
              children: [
                const Padding(
                  padding: EdgeInsets.only(top: 0, left: 10, right: 10),
                ),
                const SizedBox(
                  height: 22,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, AnimationPageRoute(widget: ServicioHome()));
                  },
                  child: const card1(),
                ),
                const SizedBox(
                  height: 22,
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context, AnimationPageRoute(widget: TorneosHome()));
                  },
                  child: const card2(),
                ),
              ],
            ),
          ),
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              color: Colors.indigo,
              boxShadow: [
                BoxShadow(
                  blurRadius: 20,
                  color: Colors.black.withOpacity(.1),
                )
              ],
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
                child: GNav(
                  rippleColor: Colors.grey[300]!,
                  hoverColor: Colors.grey[100]!,
                  gap: 8,
                  activeColor: Colors.black,
                  iconSize: 24,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  duration: const Duration(milliseconds: 400),
                  tabBackgroundColor: Colors.white,
                  color: Colors.black,
                  tabs: const [
                    GButton(
                      icon: LineIcons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: LineIcons.user,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: home,
                  onTabChange: (index) {
                    setState(
                      () {
                        if (home == index) {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.initialRoute);
                        } else {
                          Navigator.pushReplacementNamed(
                              context, AppRoutes.profileRoute);
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class card1 extends StatelessWidget {
  const card1({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: (Card(
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/BalonB.png'),
                alignment: Alignment.topRight,
                scale: 4,
                opacity: 40),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 50, 107, 156),
                Color.fromARGB(255, 66, 226, 186)
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          width: 200,
          height: 175,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 120,
                  width: 150,
                  child: Text(
                    'Gestiona tus Servicios',
                    textAlign: TextAlign.left,
                    textWidthBasis: TextWidthBasis.parent,
                    maxLines: 3,
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'SFPRODISPLAY0',
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }
}

class card2 extends StatelessWidget {
  const card2({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        clipBehavior: Clip.antiAlias,
        shadowColor: Colors.black,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage('assets/trofB.png'),
                alignment: Alignment.topRight,
                scale: 4,
                opacity: 50),
            gradient: LinearGradient(
              colors: [
                Color.fromARGB(255, 203, 56, 248),
                Color.fromARGB(255, 106, 15, 190)
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          width: 200,
          height: 175,
          child: Padding(
            padding: const EdgeInsets.all(15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                SizedBox(
                  height: 120,
                  width: 150,
                  child: Text(
                    'Gestiona tus Torneos',
                    textAlign: TextAlign.start,
                    textWidthBasis: TextWidthBasis.parent,
                    maxLines: 3,
                    style: TextStyle(
                      fontSize: 30,
                      fontFamily: 'SFPRODISPLAY0 ',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
