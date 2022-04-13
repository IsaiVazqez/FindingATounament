import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/providers/services_form_provider.dart';
import 'package:login/routes/app_routes.dart';
import 'package:login/services/services.dart';
import 'package:login/userinterface/input_decorations.dart';
import 'package:login/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';

class ServicioScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final servicioService = Provider.of<ServicioService>(context);

    return ChangeNotifierProvider(
      create: (_) => ServiceFormProvider(servicioService.selectedServicio),
      child: _ServicesScreenBody(servicioService: servicioService),
    );
  }
}

class _ServicesScreenBody extends StatelessWidget {
  const _ServicesScreenBody({
    Key? key,
    required this.servicioService,
  }) : super(key: key);

  final ServicioService servicioService;

  @override
  Widget build(BuildContext context) {
    final servicioForm = Provider.of<ServiceFormProvider>(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                ServicioImage(url: servicioService.selectedServicio.picture),
                Positioned(
                    top: 60,
                    left: 20,
                    child: IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_ios_new,
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
                        servicioService
                            .updateSelectedProductImage(pickedFile.path);
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
      floatingActionButton: ExpandableFab(
        distance: 112.0,
        children: [
          FloatingActionButton(
            backgroundColor: Colors.indigo,
            child: servicioService.isSaving
                ? const CircularProgressIndicator(
                    color: Colors.white,
                  )
                : const Icon(
                    Icons.save_outlined,
                  ),
            onPressed: servicioService.isSaving
                ? null
                : () async {
                    if (!servicioForm.isValidForm()) return;

                    final String? imageUlr =
                        await servicioService.uploadImage();

                    if (imageUlr != null)
                      servicioForm.servicio.picture = imageUlr;
                    await servicioService
                        .saveOrCreateServicio(servicioForm.servicio);
                    Navigator.pushNamed(context, 'servicios');
                  },
          ),
          FloatingActionButton(
            backgroundColor: Colors.indigo,
            child: servicioService.isDeleting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(
                    Icons.delete_outline_rounded,
                  ),
            onPressed: () async {
              await servicioService.deleteServicio(servicioForm.servicio);
              servicioService.servicio.clear();
              servicioService.loadServicios();
              Navigator.pushReplacementNamed(context, AppRoutes.serviciohome);
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
    final servicioForm = Provider.of<ServiceFormProvider>(context);
    final servicio = servicioForm.servicio;
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
          key: servicioForm.formKey,
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
                value: servicio.name.isEmpty ? 'Fútbol' : servicio.name,
                focusColor: Colors.white,
                iconDisabledColor: Colors.black,
                iconEnabledColor: Colors.black,
                dropdownColor: Colors.white,
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
                onChanged: (items) => servicio.name = items!,
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: servicio.horario,
                style: TextStyle(color: Colors.black),
                onChanged: (value) => servicio.horario = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El horario es obligatoio';
                },
                decoration: InputDecorations.authInputDecoration(
                    hintText: 'Horario del servicio', labelText: 'Horarios'),
              ),
              SizedBox(height: 30),
              TextFormField(
                initialValue: servicio.personas.toString() == '0'
                    ? null
                    : '${servicio.personas}',
                inputFormatters: [
                  FilteringTextInputFormatter.allow(
                      RegExp(r'^(\d+)?\.?\d{0,2}'))
                ],
                onChanged: (value) {
                  servicio.personas = int.parse(value);
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
                    hintText: 'Capacidad de personas',
                    labelText: 'Máximo de personas'),
              ),
              SizedBox(height: 30),
              SwitchListTile.adaptive(
                  value: servicio.discapacitados,
                  title: Text(
                    'Adecuado para personas con movilidad reducida',
                    style: TextStyle(color: Colors.black),
                  ),
                  activeColor: Colors.indigo,
                  onChanged: servicioForm.updateAvailability),
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
