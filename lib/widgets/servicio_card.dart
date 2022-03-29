import 'package:flutter/material.dart';
import 'package:login/models/models.dart';

class ServicioCard extends StatelessWidget {
  final Servicio servicio;

  const ServicioCard({Key? key, required this.servicio}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        margin: EdgeInsets.only(top: 30, bottom: 20),
        width: double.infinity,
        height: 250,
        decoration: _cardBorders(),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            _BackgroundImage(servicio.picture),
            _ServicioDetails(
              title: servicio.name,
              subTitle: servicio.horario,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: _PersonasMax(
                servicio.personas,
              ),
            ),
            if (servicio.discapacitados)
              Positioned(
                top: 0,
                left: 0,
                child: _Nodiscapacitados(),
              ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _cardBorders() => BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(25),
          boxShadow: [
            BoxShadow(
                color: Colors.black12, offset: Offset(0, 7), blurRadius: 10)
          ]);
}

class _Nodiscapacitados extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Icon(Icons.wheelchair_pickup_rounded, size: 20),
        ),
      ),
      width: 75,
      height: 60,
      decoration: BoxDecoration(
          color: Colors.green[400],
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25), bottomRight: Radius.circular(25))),
    );
  }
}

class _PersonasMax extends StatelessWidget {
  final int personas;
  const _PersonasMax(this.personas);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: FittedBox(
        fit: BoxFit.contain,
        child: Padding(
          padding: EdgeInsets.symmetric(),
          child: RichText(
            text: TextSpan(
              children: [
                WidgetSpan(
                  child: Icon(Icons.group, size: 24),
                ),
                TextSpan(
                  text: ('$personas'),
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 23,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
      width: 80,
      height: 60,
      alignment: Alignment.center,
      decoration: BoxDecoration(
          color: Colors.indigo,
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(25), bottomLeft: Radius.circular(25))),
    );
  }
}

class _ServicioDetails extends StatelessWidget {
  final String title;
  final String subTitle;

  const _ServicioDetails({required this.title, required this.subTitle});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 50),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              subTitle,
              style: TextStyle(
                fontSize: 15,
                color: Colors.white,
              ),
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      color: Colors.indigo,
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)));
}

class _BackgroundImage extends StatelessWidget {
  final String? url;

  const _BackgroundImage(this.url);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(25),
      child: Container(
        width: double.infinity,
        height: 400,
        child: url == null
            ? Image(
                image: AssetImage('assets/no-image.png'),
                fit: BoxFit.cover,
              )
            : FadeInImage(
                placeholder: AssetImage('assets/jar-loading.gif'),
                image: NetworkImage(url!),
                fit: BoxFit.cover,
              ),
      ),
    );
  }
}
