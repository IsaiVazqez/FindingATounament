import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:login/models/servicios.dart';
import 'package:login/providers/services_form_provider.dart';
import 'package:login/services/services.dart';
import 'package:login/userinterface/input_decorations.dart';
import 'package:login/widgets/widgets.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:math' as math;

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
            child: servicioService.isSaving
                ? const CircularProgressIndicator(color: Colors.white)
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
                  },
          ),
          FloatingActionButton(
            child: servicioService.isDeleting
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(
                    Icons.delete_outline_rounded,
                  ),
            onPressed: servicioService.isDeleting
                ? null
                : () async {
                    await servicioService.deleteProduct(servicioForm.servicio);
                    servicioForm.updateAvailability2;
                    Navigator.pushNamed(context, 'servicios');
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

/*               TextFormField(
                initialValue: servicio.name,
                style: TextStyle(color: Colors.black),
                onChanged: (value) => servicio.name = value,
                validator: (value) {
                  if (value == null || value.length < 1)
                    return 'El nombre es obligatoio';
                },
                decoration: InputDecorations.authInputDecoration(
                  hintText: 'Nombre del Sevicio',
                  labelText: 'Nombre',
                ),
              ), */
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

@immutable
class ExpandableFab extends StatefulWidget {
  const ExpandableFab({
    Key? key,
    this.initialOpen,
    required this.distance,
    required this.children,
  }) : super(key: key);

  final bool? initialOpen;
  final double distance;
  final List<Widget> children;

  @override
  _ExpandableFabState createState() => _ExpandableFabState();
}

class _ExpandableFabState extends State<ExpandableFab>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _expandAnimation;
  bool _open = false;

  @override
  void initState() {
    super.initState();
    _open = widget.initialOpen ?? false;
    _controller = AnimationController(
      value: _open ? 1.0 : 0.0,
      duration: const Duration(milliseconds: 250),
      vsync: this,
    );
    _expandAnimation = CurvedAnimation(
      curve: Curves.fastOutSlowIn,
      reverseCurve: Curves.easeOutQuad,
      parent: _controller,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggle() {
    setState(() {
      _open = !_open;
      if (_open) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Stack(
        alignment: Alignment.bottomRight,
        clipBehavior: Clip.none,
        children: [
          _buildTapToCloseFab(),
          ..._buildExpandingActionButtons(),
          _buildTapToOpenFab(),
        ],
      ),
    );
  }

  Widget _buildTapToCloseFab() {
    return SizedBox(
      width: 56.0,
      height: 56.0,
      child: Center(
        child: Material(
          shape: const CircleBorder(),
          clipBehavior: Clip.antiAlias,
          elevation: 4.0,
          child: InkWell(
            onTap: _toggle,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(
                Icons.close,
                color: Theme.of(context).primaryColor,
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildExpandingActionButtons() {
    final children = <Widget>[];
    final count = widget.children.length;
    final step = 90.0 / (count - 1);
    for (var i = 0, angleInDegrees = 0.0;
        i < count;
        i++, angleInDegrees += step) {
      children.add(
        _ExpandingActionButton(
          directionInDegrees: angleInDegrees,
          maxDistance: widget.distance,
          progress: _expandAnimation,
          child: widget.children[i],
        ),
      );
    }
    return children;
  }

  Widget _buildTapToOpenFab() {
    return IgnorePointer(
      ignoring: _open,
      child: AnimatedContainer(
        transformAlignment: Alignment.center,
        transform: Matrix4.diagonal3Values(
          _open ? 0.7 : 1.0,
          _open ? 0.7 : 1.0,
          1.0,
        ),
        duration: const Duration(milliseconds: 250),
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
        child: AnimatedOpacity(
          opacity: _open ? 0.0 : 1.0,
          curve: const Interval(0.25, 1.0, curve: Curves.easeInOut),
          duration: const Duration(milliseconds: 250),
          child: FloatingActionButton(
            backgroundColor: Colors.indigo,
            onPressed: _toggle,
            child: const Icon(Icons.create),
          ),
        ),
      ),
    );
  }
}

@immutable
class _ExpandingActionButton extends StatelessWidget {
  const _ExpandingActionButton({
    Key? key,
    required this.directionInDegrees,
    required this.maxDistance,
    required this.progress,
    required this.child,
  }) : super(key: key);

  final double directionInDegrees;
  final double maxDistance;
  final Animation<double> progress;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: progress,
      builder: (context, child) {
        final offset = Offset.fromDirection(
          directionInDegrees * (math.pi / 180.0),
          progress.value * maxDistance,
        );
        return Positioned(
          right: 4.0 + offset.dx,
          bottom: 4.0 + offset.dy,
          child: Transform.rotate(
            angle: (1.0 - progress.value) * math.pi / 2,
            child: child!,
          ),
        );
      },
      child: FadeTransition(
        opacity: progress,
        child: child,
      ),
    );
  }
}
