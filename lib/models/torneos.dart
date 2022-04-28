import 'dart:convert';

class Torneos {
  Torneos({
    required this.bases,
    required this.costo,
    required this.disciplina,
    required this.disponibilidad,
    required this.equipos,
    required this.fecha,
    this.picture,
    this.id,
    required this.rondas,
    required this.tipotorneo,
  });

  String bases;
  int costo;
  String disciplina;
  bool disponibilidad;
  int equipos;
  DateTime fecha;
  String? picture;
  int rondas;
  String tipotorneo;
  String? id;

  factory Torneos.fromJson(String str) => Torneos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Torneos.fromMap(Map<String, dynamic> json) => Torneos(
        bases: json["bases"],
        costo: json["costo"],
        disciplina: json["disciplina"],
        disponibilidad: json["disponibilidad"],
        equipos: json["equipos"],
        fecha: DateTime.parse(json["fecha"]),
        picture: json["picture"],
        rondas: json["rondas"],
        tipotorneo: json["tipotorneo"],
      );

  Map<String, dynamic> toMap() => {
        "bases": bases,
        "costo": costo,
        "disciplina": disciplina,
        "disponibilidad": disponibilidad,
        "equipos": equipos,
        "fecha":
            "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "picture": picture,
        "rondas": rondas,
        "tipotorneo": tipotorneo,
      };

  Torneos copy() => Torneos(
        bases: this.bases,
        costo: this.costo,
        disciplina: this.disciplina,
        disponibilidad: this.disponibilidad,
        equipos: this.equipos,
        fecha: this.fecha,
        picture: this.picture,
        rondas: this.rondas,
        tipotorneo: this.tipotorneo,
        id: this.id,
      );
}
