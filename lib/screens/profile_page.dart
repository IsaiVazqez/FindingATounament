/* import 'package:finding_a_tour/models/user.dart';
import 'package:finding_a_tour/screens/edit_profile_page.dart';
import 'package:finding_a_tour/screens/register_new_club.dart';
import 'package:finding_a_tour/widget/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:finding_a_tour/routes/app_routes.dart';
import 'package:flutter_snake_navigationbar/flutter_snake_navigationbar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../routes/app_routes.dart';
import '../utils/user_preferences.dart';
import '../widget/appbar_widget.dart';
import '../widget/button_widget.dart';
import '../widget/numbers_widget.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int home = 1;

  @override
  Widget build(BuildContext context) {
    final menuOptions = AppRoutes.menuOptions;
    final user = UserPreferences.myUser;

    return Scaffold(
        appBar: buildAppBar(context),
        body: ListView(
          physics: const BouncingScrollPhysics(),
          children: [
            const SizedBox(height: 10),
            ProfileWidget(
              imagePath: user.imagePath,
              onClicked: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => EditProfilePage()),
                );
              },
            ),
            const SizedBox(height: 24),
            buildName(user),
            const SizedBox(height: 24),
            Center(child: buildUpgradeButton(context)),
            const SizedBox(height: 24),
            NumbersWidget(),
            const SizedBox(height: 24),
            buildDirecc(user),
            const SizedBox(height: 24),
            buildHorario(user),
            const SizedBox(height: 20),
            buildUbicacion(user),
            Container(
              child: MapScreen(),
              margin: const EdgeInsets.only(
                  top: 20, left: 35, right: 35, bottom: 5),
              width: 20,
              height: 200,
            )
          ],
        ),
        bottomNavigationBar: SnakeNavigationBar.color(
          behaviour: SnakeBarBehaviour.floating,
          snakeShape: SnakeShape.circle,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),

          elevation: 5,
          padding: const EdgeInsets.all(20),

          ///configuration for SnakeNavigationBar.color
          snakeViewColor: const Color.fromARGB(255, 81, 204, 177),
          selectedItemColor:
              SnakeShape.circle == SnakeShape.indicator ? Colors.black : null,
          unselectedItemColor: Colors.blueGrey,

          ///configuration for SnakeNavigationBar.gradient
          //snakeViewGradient: selectedGradient,
          //selectedItemGradient: snakeShape == SnakeShape.indicator ? selectedGradient : null,
          //unselectedItemGradient: unselectedGradient,

          showUnselectedLabels: false,
          showSelectedLabels: false,

          currentIndex: home,
          onTap: (index) {
            setState(() {
              if (home == index) {
                Navigator.pushReplacementNamed(context, AppRoutes.profileRoute);
              } else {
                Navigator.pushReplacementNamed(context, AppRoutes.initialRoute);
              }
            });
          },
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'home'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'profile')
          ],
        ));
  }
}

Widget buildName(User user) => Column(
      children: [
        Text(
          user.name,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
        ),
        const SizedBox(height: 10),
        Text(
          user.number,
          style: const TextStyle(color: Colors.grey),
        )
      ],
    );

Widget buildUpgradeButton(context) => ButtonWidget(
      text: 'Agregar Nuevo Club',
      onClicked: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const RegisterNew()));
      },
    );

Widget buildDirecc(User user) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Dirección',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            user.adress,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );

Widget buildHorario(User user) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(
            'Horario',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            user.horarios,
            style: const TextStyle(fontSize: 16, height: 1.4),
          ),
        ],
      ),
    );

Widget buildUbicacion(User user) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const [
          Text(
            'Ubicación',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );

class MapScreen extends StatefulWidget {
  List<Marker> myMarker = [];

  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController; //contrller for Google map
  Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation =
      const LatLng(20.943781926121023, -89.5940972859401);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
          bottomRight: const Radius.circular(30),
          bottomLeft: Radius.circular(30),
        ),
        child: Align(
          alignment: Alignment.bottomRight,
          heightFactor: 10,
          widthFactor: 2.5,
          child: GoogleMap(
            zoomGesturesEnabled: true,
            initialCameraPosition: const CameraPosition(
              //innital position in map
              target: showLocation, //initial position
              zoom: 15.0, //initial zoom level
            ),
            markers: getmarkers(), //markers to show on map
            mapType: MapType.normal, //map type
            onMapCreated: (controller) {
              //method called when map is created
              setState(() {
                mapController = controller;
              });
            },
          ),
        ),
      ),
    );
  }

  Set<Marker> getmarkers() {
    //markers to place on map
    setState(() {
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(showLocation.toString()),
        position: showLocation, //position of marker
        infoWindow: const InfoWindow(
          //popup info
          title: 'Deportivo Kukulkan',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
    return markers;
  }
}
 */