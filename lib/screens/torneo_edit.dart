import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/providers/torneos_form_provider.dart';
import 'package:login/services/services.dart';
import 'package:login/userinterface/input_decorations.dart';
import 'package:login/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ToneoEditar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final torneoService = Provider.of<TorneoService>(context);

    return ChangeNotifierProvider(
      create: (_) => TorneoFormProvider(torneoService.selectedTorneo),
      child: _TorneosScreenBody(torneoService: torneoService),
    );
  }
}

class _TorneosScreenBody extends StatelessWidget {
  const _TorneosScreenBody({
    Key? key,
    required this.torneoService,
  }) : super(key: key);

  final TorneoService torneoService;

  @override
  Widget build(BuildContext context) {
    final torneoForm = Provider.of<TorneoFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                TorneoImage(url: torneoService.selectedTorneo.picture),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(Icons.arrow_back_ios_new,
                          size: 40, color: Colors.white),
                    )),
                Positioned(
                    top: 60,
                    right: 20,
                    child: IconButton(
                      onPressed: () async {
                        final picker = new ImagePicker();
                        final PickedFile? pickedFile = await picker.getImage(
                            source: ImageSource.gallery, imageQuality: 100);
                        if (pickedFile == null) {
                          print('No selecciono una imagén');
                          return;
                        }
                        torneoService
                            .updateSelectedTorneoImage(pickedFile.path);
                      },
                      icon: Icon(Icons.camera_alt_outlined,
                          size: 40, color: Colors.white),
                    )),
              ],
            ),
            _ServicioForm(),
            SizedBox(height: 100),
          ],
        ),
      ),
      /*  floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
      floatingActionButton: FloatingActionButton(
        child: torneoService.isSaving
            ? CircularProgressIndicator(color: Colors.white)
            : Icon(
                Icons.save_outlined,
              ),
        backgroundColor: Colors.indigo,
        onPressed: torneoService.isSaving
            ? null
            : () async {
                final String? imageUlr = await torneoService.uploadImage();

                if (imageUlr != null) torneoForm.torneo.picture = imageUlr;
                await torneoService.saveOrCreateTorneos(torneoForm.torneo);
              },
      ), */
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          FloatingActionButton(
            heroTag: "btn3",
            backgroundColor: Colors.indigo,
            child: torneoService.isSaving
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.save_outlined,
                  ),
            onPressed: torneoService.isSaving
                ? null
                : () async {
                    if (!torneoForm.isValidForm()) return;

                    final String? imageUlr = await torneoService.uploadImage();

                    if (imageUlr != null) torneoForm.torneo.picture = imageUlr;
                    await torneoService.saveOrCreateTorneos(torneoForm.torneo);
                    Navigator.pushNamed(context, 'torneohome');
                  },
          ),
          FloatingActionButton(
            heroTag: "btn4",
            backgroundColor: Colors.indigo,
            child: torneoService.isDeleting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(
                    Icons.delete_outline_rounded,
                  ),
            onPressed: () async {
              await torneoService.deleteTorneoU(torneoForm.torneo);
              torneoService.torneo.clear();
              torneoService.loadTorneos();
              Navigator.pushNamed(context, 'torneohome');
            },
          ),
        ],
      ),
    );
  }
}

class _ServicioForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final torneoForm = Provider.of<TorneoFormProvider>(context);
    final torneo = torneoForm.torneo;
    List<String?> items = [
      'Fútbol',
      'Béisbol',
      'Básquetbol',
      'Natación',
      'Tenis',
      'Voleibol',
      'Boxeo',
      'Atletismo',
      'Golf',
      'Juego de pelota',
      'Taekwondo',
      'Karate',
      'Esgrima',
      'Gimnasia',
      'Handball',
      'Judo',
      'Softbol',
    ];
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        width: double.infinity,
        decoration: _buildBoxDecoration(),
        child: Form(
          key: torneoForm.formKey,
/*           autovalidateMode: AutovalidateMode.onUserInteraction,
 */
          child: Column(
            children: [
              SizedBox(height: 30),
              DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  labelText: 'Horarios',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide:
                        const BorderSide(width: 1, color: Colors.indigo),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                      borderSide:
                          BorderSide(color: Colors.deepPurple, width: 2)),
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
                value: torneo.disciplina.isEmpty ? 'Fútbol' : torneo.disciplina,
                focusColor: Colors.white,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                dropdownColor: Colors.white,

                // Down Arrow Icon
                icon: const Icon(Icons.keyboard_arrow_down),
                items: items
                    .map((
                      items,
                    ) =>
                        DropdownMenuItem<String>(
                          value: items,
                          child: Text(
                            items!,
                            style: const TextStyle(
                                fontSize: 15, color: Colors.black),
                          ),
                        ))
                    .toList(),

                onChanged: (items) => torneo.disciplina = items!,
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: torneo.bases,
                style: TextStyle(color: Colors.black),
                onChanged: (value) => torneo.bases = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'Las bases son obligatorias';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Round Robin', labelText: 'Bases del torneo'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: torneo.equipos.toString() == '0'
                    ? null
                    : '${torneo.equipos}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  // if (double.tryParse(value) == null) {
                  //   servicio.personas = 0;
                  // } else {

                  // }
                  torneo.equipos = int.parse(value);
                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  final n = num.tryParse(value!);
                  if (n == 0 || n == null) {
                    return 'El numero de personas debe de ser mayor a 0';
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Capacidad de equipos',
                    labelText: 'Máximo de equipos'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue:
                    torneo.rondas.toString() == '0' ? null : '${torneo.rondas}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  // if (double.tryParse(value) == null) {
                  //   servicio.personas = 0;
                  // } else {

                  // }
                  torneo.rondas = int.parse(value);
                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  final n = num.tryParse(value!);
                  if (n == 0 || n == null) {
                    return 'El numero de rondas debe de ser mayor a 0';
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Cantidad de Rondas',
                    labelText: 'Cantidad de Rondas'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue:
                    torneo.costo.toString() == '0' ? null : '${torneo.costo}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  torneo.costo = int.parse(value);
                },
                keyboardType: TextInputType.number,
                validator: (value) {
                  final n = num.tryParse(value!);
                  if (n == 0 || n == null) {
                    return 'El costo debe ser mayor a 0';
                  }
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Precio por equipo',
                    labelText: 'Precio por equipo'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: torneo.tipotorneo,
                style: TextStyle(color: Colors.black),
                onChanged: (value) => torneo.tipotorneo = value,
                validator: (value) {
                  if (value == null || value.length < 0)
                    return 'El tipo de torneo es obligatorio';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Una eliminación', labelText: 'Tipo de torneo'),
              ),
              SizedBox(height: 30),
              SwitchListTile.adaptive(
                  value: torneo.disponibilidad,
                  title: Text(
                    'Disponibilidad de Equipos',
                    style: TextStyle(color: Colors.black),
                  ),
                  activeColor: Colors.indigo,
                  onChanged: torneoForm.updateAvailability),
              SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomRight: Radius.circular(25),
          bottomLeft: Radius.circular(25),
        ),
        border: Border.all(
          color: Colors.indigo,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              offset: Offset(0, 5),
              blurRadius: 5)
        ],
      );

/*   setState(String Function() param0) {}
} */
}
