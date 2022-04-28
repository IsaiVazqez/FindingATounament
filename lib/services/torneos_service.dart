import 'dart:convert';
import 'dart:io';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'package:flutter/material.dart';
import 'package:login/models/models.dart';
import 'package:http/http.dart' as http;

class TorneoService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-87503-default-rtdb.firebaseio.com';

  final List<Torneos> torneo = [];
  bool isLoading = true;
  bool isSaving = false;
  File? newPictureFile;
  late Torneos selectedTorneo;
  final storage = new FlutterSecureStorage();

  TorneoService() {
    this.loadTorneos();
  }
  Future<List<Torneos>> loadTorneos() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'torneos.json',
        {'auth': await storage.read(key: 'token') ?? ''});
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

  Future saveOrCreateTorneos(Torneos torneo) async {
    isSaving = true;
    notifyListeners();

    if (torneo.id == null) {
      await this.CreateTorneos(torneo);
    } else {
      await this.updateTorneos(torneo);
    }
    isSaving = false;
    notifyListeners();
  }

  Future<String> updateTorneos(Torneos torneo) async {
    final url = Uri.https(_baseUrl, 'torneos/${torneo.id}.json');
    final resp = await http.put(url, body: torneo.toJson());
    final decodedData = resp.body;

    final index = this.torneo.indexWhere((element) => element.id == torneo.id);
    this.torneo[index] = torneo;

    return torneo.id!;
  }

  Future<String> CreateTorneos(Torneos torneo) async {
    final url = Uri.https(_baseUrl, 'torneos.json');
    final resp = await http.post(url, body: torneo.toJson());
    final decodedData = json.decode(resp.body);

    torneo.id = decodedData['name'];

    this.torneo.add(torneo);

    return torneo.id!;
  }

  void updateSelectedTorneoImage(String path) {
    this.selectedTorneo.picture = path;

    this.newPictureFile = File.fromUri(Uri(path: path));

    notifyListeners();
  }

  Future<String?> uploadImage() async {
    if (this.newPictureFile == null) return null;

    this.isSaving = true;
    notifyListeners();

    final url = Uri.parse(
        'https://api.cloudinary.com/v1_1/dtfknt03k/image/upload?upload_preset=hen9lowa');

    final imageUploadRequest = http.MultipartRequest('POST', url);

    final file =
        await http.MultipartFile.fromPath('file', newPictureFile!.path);

    imageUploadRequest.files.add(file);

    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
      print('algo salio mal');
      print(resp.body);
      return null;
    }

    this.newPictureFile = null;

    final decodedData = json.decode(resp.body);
    return decodedData['secure_url'];
  }
}
