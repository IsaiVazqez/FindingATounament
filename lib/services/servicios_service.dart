import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:login/models/models.dart';
import 'package:http/http.dart' as http;

class ServicioService extends ChangeNotifier {
  final String _baseUrl = 'flutter-varios-87503-default-rtdb.firebaseio.com';

  final List<Servicio> servicio = [];
  bool isLoading = true;
  bool isSaving = false;
  File? newPictureFile;
  late Servicio selectedServicio;
  bool isDeleting = false;
  final storage = new FlutterSecureStorage();

  ServicioService() {
    this.loadServicios();
  }

  Future<List<Servicio>> loadServicios() async {
    this.isLoading = true;
    notifyListeners();

    final url = Uri.https(_baseUrl, 'products.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.get(url);

    final Map<String, dynamic> serviciosMap = json.decode(resp.body);

    serviciosMap.forEach((key, value) {
      final tempServicio = Servicio.fromMap(value);
      tempServicio.id = key;
      this.servicio.add(tempServicio);
    });

    this.isLoading = false;
    notifyListeners();

    return this.servicio;
  }

  Future saveOrCreateServicio(Servicio servicio) async {
    isSaving = true;
    notifyListeners();

    if (servicio.id == null) {
      await this.createProduct(servicio);
    } else {
      await this.updateServicio(servicio);
    }

    isSaving = false;
    notifyListeners();
  }

  Future deleteServicio(Servicio servicio) async {
    await this.deleteProduct(servicio);
  }

  Future<String> updateServicio(Servicio servicio) async {
    final url = Uri.https(_baseUrl, 'products/${servicio.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.put(url, body: servicio.toJson());
    final decodedData = resp.body;

    final index =
        this.servicio.indexWhere((element) => element.id == servicio.id);
    this.servicio[index] = servicio;

    return servicio.id!;
  }

  Future<String> createProduct(Servicio servicio) async {
    final url = Uri.https(_baseUrl, 'products.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.post(url, body: servicio.toJson());
    final decodedData = json.decode(resp.body);

    servicio.id = decodedData['name'];

    this.servicio.add(servicio);

    return servicio.id!;
  }

  Future<String> deleteProduct(Servicio servicio) async {
    final url = Uri.https(_baseUrl, 'products/${servicio.id}.json',
        {'auth': await storage.read(key: 'token') ?? ''});
    final resp = await http.delete(url, body: servicio.toJson());

    final decodedData = json.decode(resp.body);

    final index =
        this.servicio.indexWhere((element) => element.id == servicio.id);
    this.servicio[index] = servicio;

    return servicio.id!;
  }

  void updateSelectedProductImage(String path) {
    this.selectedServicio.picture = path;

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
