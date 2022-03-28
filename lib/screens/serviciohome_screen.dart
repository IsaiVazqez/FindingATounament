import 'package:flutter/material.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:login/models/models.dart';
import 'package:login/services/services.dart';
import 'package:login/widgets/widgets.dart';
import 'package:login/screens/screens.dart';
import 'package:provider/provider.dart';

import '../routes/app_routes.dart';

class ServicioHome extends StatelessWidget {
  int home = 0;

  @override
  Widget build(BuildContext context) {
    final servicioService = Provider.of<ServicioService>(context);

    if (servicioService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(title: Text('Servicios')),
      body: ListView.builder(
          itemCount: servicioService.servicio.length,
          itemBuilder: (BuildContext context, int index) => GestureDetector(
                onTap: () {
                  servicioService.selectedServicio =
                      servicioService.servicio[index].copy();
                  Navigator.pushNamed(context, 'servicioedit');
                },
                child: ServicioCard(
                  servicio: servicioService.servicio[index],
                ),
              )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          servicioService.selectedServicio = new Servicio(
              horario: '', discapacitados: false, name: '', personas: 0);
          Navigator.pushNamed(context, 'servicioedit');
        },
      ),
/*       bottomNavigationBar: SnakeNavigationBar.color(
        behaviour: SnakeBarBehaviour.floating,
        snakeShape: SnakeShape.circle,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        elevation: 5,
        padding: const EdgeInsets.all(11),
        height: 45,

        ///configuration for SnakeNavigationBar.color
        snakeViewColor: const Color.fromARGB(255, 81, 204, 177),
        selectedItemColor:
            SnakeShape.circle == SnakeShape.indicator ? Colors.black : null,
        unselectedItemColor: Colors.blueGrey,

        ///configuration for SnakeNavigationBar.gradient
        //snakeViewGradient: selectedGradient,
        //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
        //unselectedItemGradient: unselectedGradient,

        showUnselectedLabels: false,
        showSelectedLabels: false,

        currentIndex: home,
        onTap: (index) {
          setState(() {
            if (home == index) {
              Navigator.pushReplacementNamed(context, AppRoutes.initialRoute);
            } else {
              Navigator.pushReplacementNamed(context, AppRoutes.profileRoute);
            }
          });
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile'),
        ],
      ), */
    );
  }
}
