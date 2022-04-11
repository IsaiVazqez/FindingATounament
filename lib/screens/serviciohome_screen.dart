import 'package:flutter/material.dart';
import 'package:login/models/models.dart';
import 'package:login/services/services.dart';
import 'package:login/widgets/widgets.dart';
import 'package:login/screens/screens.dart';
import 'package:provider/provider.dart';

class ServicioHome extends StatelessWidget {
  int home = 0;

  @override
  Widget build(BuildContext context) {
    final servicioService = Provider.of<ServicioService>(context);

    if (servicioService.isLoading) return LoadingScreen();

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pushNamed(context, 'HomeScreen'),
        ),
        title: Text('Servicios'),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      ),
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
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.indigo,
        onPressed: () {
          servicioService.selectedServicio = new Servicio(
              horario: '', discapacitados: false, name: 'Fútbol', personas: 0);
          Navigator.pushNamed(context, 'servicioedit');
        },
      ),
    );
  }
}
