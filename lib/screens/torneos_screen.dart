import 'package:flutter/material.dart';
import 'package:login/models/models.dart';
import 'package:login/services/services.dart';
import 'package:login/widgets/widgets.dart';
import 'package:login/screens/screens.dart';
import 'package:provider/provider.dart';

class TorneosHome extends StatelessWidget {
  int home = 0;

  @override
  Widget build(BuildContext context) {
    final torneoService = Provider.of<TorneoService>(context);

    if (torneoService.isLoading) return LoadingTorneoScreen();

    return Scaffold(
      appBar: AppBar(
        title: Text('Torneos'),
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(10))),
      ),
      body: ListView.builder(
        itemCount: torneoService.torneo.length,
        itemBuilder: (BuildContext context, int index) => GestureDetector(
          onTap: () {
            torneoService.selectedTorneo = torneoService.torneo[index].copy();
            Navigator.pushNamed(context, 'servicioedit');
          },
          child: TorneoCard(
            torneo: torneoService.torneo[index],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          Icons.add,
        ),
        backgroundColor: Colors.indigo,
        onPressed: () {
          torneoService.selectedTorneo = new Torneos(
            disciplina: '',
            disponibilidad: false,
            equipos: 0,
            bases: '',
            costo: 0,
            rondas: 0,
            tipotorneo: '',
          );
          Navigator.pushNamed(context, 'servicioedit');
        },
      ),
    );
  }
}
