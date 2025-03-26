import 'package:craterometro/firebase_options.dart';
import 'package:craterometro/login/login_page.dart';
import 'package:craterometro/map/map_page.dart';
import 'package:craterometro/theme/theme_colors.dart';
import 'package:craterometro/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => UserProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Craterometro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MapScreen(),
    );
  }
}

class MapScreen extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  MapController mapController = MapController();
  LatLng? _userLocation;
  @override
  void initState() {
    super.initState();
    _getUserLocation();
    Provider.of<UserProvider>(context, listen: false).loadUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 10,
        backgroundColor: Colors.white,
      ),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            return snapshot.data?.email == null
                ? Stack(
                    children: [
                      FlutterMap(
                        mapController: mapController,
                        options: MapOptions(
                          initialCenter: LatLng(
                            -6.11198,
                            -38.20528,
                          ),
                          initialZoom: 15.0,
                        ),
                        children: [
                          TileLayer(
                            urlTemplate:
                                "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                            subdomains: ['a', 'b', 'c'],
                          ),
                        ],
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: MediaQuery.of(context).size.height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.transparent,
                              Colors.transparent,
                              Color.fromARGB(233, 0, 0, 0),
                            ],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Ajude a mapear os problemas das ruas!',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 36,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Registre buracos na cidade e contribua para ruas mais seguras e bem cuidadas.',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                              textAlign: TextAlign.center,
                            ),
                            SizedBox(height: 10),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                fixedSize: Size(250, 50),
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Comece Agora',
                                      style: TextStyle(fontSize: 22)),
                                  Icon(
                                    Icons.arrow_forward,
                                    size: 20,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                            ),
                            SizedBox(height: 5),
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => MapPage(),
                                  ),
                                );
                              },
                              child: Text(
                                'Continuar sem login',
                                style: TextStyle(
                                    color: ThemeColors.primaryColor,
                                    decoration: TextDecoration.underline,
                                    decorationThickness: 2,
                                    decorationColor: ThemeColors.primaryColor),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  )
                : MapPage();
          }),
    );
  }

  Future<void> _getUserLocation() async {
    var status = await Permission.location.request();
    if (status.isGranted) {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      setState(() {
        _userLocation = LatLng(position.latitude, position.longitude);
      });
      mapController.move(_userLocation!, 15.0);
    } else {
      print("Permissão negada");
    }
  }
}
