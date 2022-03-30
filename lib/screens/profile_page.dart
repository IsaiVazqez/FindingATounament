import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import '../models/user.dart';
import '../routes/app_routes.dart';
import '../themes/user_preferences.dart';
import 'package:login/widgets/widgets.dart';
import 'package:login/screens/screens.dart';
import 'package:location/location.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int home = 1;

  @override
  Widget build(BuildContext context) {
    final user = UserPreferences.myUser;

    return Scaffold(
        appBar: AppBar(
            shape: const RoundedRectangleBorder(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(22))),
            automaticallyImplyLeading: false,
            title: const Center(child: Text('Perfil')),
            elevation: 0,
            titleTextStyle: const TextStyle(
                fontSize: 20,
                color: Color.fromARGB(255, 255, 255, 255),
                fontWeight: FontWeight.bold,
                fontFamily: 'SFPRODISPLAY'),
            actions: []),
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
        bottomNavigationBar: Container(
          decoration: BoxDecoration(
            color: Colors.indigo,
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.black.withOpacity(.1),
              )
            ],
          ),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 8),
              child: GNav(
                rippleColor: Colors.grey[300]!,
                hoverColor: Colors.grey[100]!,
                gap: 8,
                activeColor: Colors.black,
                iconSize: 24,
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                duration: const Duration(milliseconds: 400),
                tabBackgroundColor: Colors.white,
                color: Colors.black,
                tabs: [
                  const GButton(
                    icon: LineIcons.home,
                    text: 'Home',
                  ),
                  const GButton(
                    icon: LineIcons.user,
                    text: 'Profile',
                  ),
                ],
                selectedIndex: home,
                onTabChange: (index) {
                  setState(
                    () {
                      if (home == index) {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.profileRoute);
                      } else {
                        Navigator.pushReplacementNamed(
                            context, AppRoutes.initialRoute);
                      }
                    },
                  );
                },
              ),
            ),
          ),
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
  Location _location = Location();
  Set<Marker> markers = new Set(); //markers for google map
  static const LatLng showLocation =
      LatLng(20.943781926121023, -89.5940972859401);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
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
              _location.onLocationChanged.listen((l) {});
              setState(() {
                mapController = controller;
              });
            },
            myLocationEnabled: true,
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
