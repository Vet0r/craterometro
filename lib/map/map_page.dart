import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craterometro/map/picture.dart';
import 'package:craterometro/map/widgets/standard_marker.dart';
import 'package:craterometro/profile/profile_screen.dart';
import 'package:craterometro/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  MapController mapController = MapController();
  LatLng? _userLocation;
  LatLng _markerPosition = LatLng(-5.1870, -37.3443);
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  void initState() {
    super.initState();
    _getUserLocation();
  }

  void _onMapMoved() {
    setState(() {
      _markerPosition = mapController.camera.center;
    });
  }

  bool showmarker = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: ThemeColors.appBarColor,
        title: Row(
          children: [
            Image.asset('assets/logo.png', height: 30),
            Padding(
              padding: const EdgeInsets.only(left: 4.0),
              child: Text(
                'CRATERÔMETRO ',
                style: TextStyle(
                    color: ThemeColors.primaryColor,
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
              ),
            ),
            Text(
              'PDF ',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 14),
            ),
          ],
        ),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
              icon: Icon(
                Icons.person,
                color: ThemeColors.primaryColor,
              ))
        ],
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: _firestore.collection('markers').snapshots(),
        builder: (context, snapshot) {
          List<Marker> markers = snapshot.data!.docs.map((doc) {
            double latitude = doc.data()['lat'];
            double longitude = doc.data()['long'];
            return Marker(
                width: 50,
                height: 50,
                point: LatLng(latitude, longitude),
                child: GestureDetector(
                  child: Icon(
                    Icons.location_on,
                    color: doc.data()['is_confirmed']
                        ? ThemeColors.pinColor
                        : ThemeColors.pinUnconfirmedColor,
                    size: 40,
                  ),
                  onTap: () {
                    showReportPopup(
                      context,
                      doc.data()['picture'],
                      doc.data()['user_name'],
                      doc.data()['description'],
                      doc.id,
                    );
                  },
                ),
                rotate: false);
          }).toList();
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return Stack(
            children: [
              FlutterMap(
                mapController: mapController,
                options: MapOptions(
                  onPositionChanged: (_, hasGesture) {
                    if (hasGesture) {
                      _onMapMoved();
                    }
                  },
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
                  MarkerLayer(
                    markers: markers,
                  ),
                ],
              ),
              showmarker
                  ? Align(
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.location_on,
                        color: Colors.blue,
                      ),
                    )
                  : Container(),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (showmarker) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    CameraScreen(userLocation: _markerPosition),
              ),
            );
            showmarker = false;
          } else {
            setState(() {
              _markerPosition = mapController.camera.center;
              showmarker = true;
            });
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(left: 4.0),
          child: Image.asset('assets/pin.png', height: 35),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(50),
        ),
        backgroundColor: const Color.fromARGB(39, 0, 0, 0),
        elevation: 0.0,
      ),
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
