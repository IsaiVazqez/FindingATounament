import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:login/models/models.dart';
import 'package:http/http.dart' as http;

class TorneoService extends ChangeNotifier {
  final String _baseUrl = 'fluttertrone-default-rtdb.firebaseio.com';

  final List<Torneos> torneo = [];
  bool isLoading = true;
  late Torneos selectedTorneo;

  TorneoService() {
    this.loadTorneos();
  }
  Future<List<Torneos>> loadTorneos() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'torneos.json');
    final resp = await http.get(url);

    final Map<String, dynamic> torneosMap = json.decode(resp.body);

    torneosMap.forEach((key, value) {
      final tempTorneo = Torneos.fromMap(value);
      tempTorneo.id = key;
      this.torneo.add(tempTorneo);
    });

    this.isLoading = false;

    notifyListeners();

    return this.torneo;
  }
}
