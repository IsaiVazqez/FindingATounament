import 'package:flutter/material.dart';

class LoadingTorneoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Torneos'),
      ),
      body: Center(
        child: CircularProgressIndicator(color: Colors.indigo),
      ),
    );
  }
}
