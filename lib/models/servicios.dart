// To parse this JSON data, do
//
//     final servicio = servicioFromMap(jsonString);

import 'dart:convert';

class Servicio {
  Servicio(
      {required this.discapacitados,
      required this.horario,
      required this.name,
      required this.personas,
      this.picture,
      this.id});

  bool discapacitados;
  String horario;
  String name;
  int personas;
  String? picture;
  String? id;

  factory Servicio.fromJson(String str) => Servicio.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Servicio.fromMap(Map<String, dynamic> json) => Servicio(
        discapacitados: json["discapacitados"],
        horario: json["horario"],
        name: json["name"],
        personas: json["personas"],
        picture: json["picture"],
      );

  Map<String, dynamic> toMap() => {
        "discapacitados": discapacitados,
        "horario": horario,
        "name": name,
        "personas": personas,
        "picture": picture,
      };

  Servicio copy() => Servicio(
        discapacitados: this.discapacitados,
        horario: this.horario,
        picture: this.picture,
        name: this.name,
        personas: this.personas,
        id: this.id,
      );
}
