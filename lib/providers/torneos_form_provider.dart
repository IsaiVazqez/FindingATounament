import 'package:flutter/material.dart';
import 'package:login/models/models.dart';

class TorneoFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Torneos torneo;

  TorneoFormProvider(this.torneo);

  updateAvailability(bool value) {
    print(value);
    this.torneo.disponibilidad = value;
    notifyListeners();
  }

  bool isValidForm() {
    print(torneo.disciplina);
    print(torneo.equipos);
    print(torneo.disponibilidad);
    print(torneo.rondas);
    print(torneo.costo);
    print(torneo.bases);
    print(torneo.tipotorneo);
    return formKey.currentState?.validate() ?? false;
  }
}
