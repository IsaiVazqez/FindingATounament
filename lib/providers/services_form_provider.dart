import 'package:flutter/material.dart';
import 'package:login/models/models.dart';

class ServiceFormProvider extends ChangeNotifier {
  GlobalKey<FormState> formKey = new GlobalKey<FormState>();

  Servicio servicio;

  ServiceFormProvider(this.servicio);

  updateAvailability(bool value) {
    print(value);
    this.servicio.discapacitados = value;
    notifyListeners();
  }

  updateAvailability2(value) {
    print(value);
    notifyListeners();
  }

  bool isValidForm() {
    print(servicio.name);
    print(servicio.personas);
    print(servicio.discapacitados);

    return formKey.currentState?.validate() ?? false;
  }
}
