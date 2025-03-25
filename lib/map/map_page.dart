import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craterometro/theme/theme_colors.dart';
import 'package:firebase_auth/firebase_auth.dart';
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
  @override
  void initState() {
    super.initState();
    _getUserLocation();
  }

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
                FirebaseAuth.instance.signOut();
              },
              icon: Icon(
                Icons.person,
                color: ThemeColors.primaryColor,
              ))
        ],
        elevation: 0,
      ),
      body: StreamBuilder(
          stream: FirebaseFirestore.instance.collection('markers').snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
            return FlutterMap(
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
                MarkerLayer(
                  markers: [
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: LatLng(-5.1870, -37.3443),
                      child: GestureDetector(
                          child: Icon(Icons.location_on,
                              color: Colors.red, size: 40),
                          onTap: () {
                            print('Marker tapped');
                          }),
                    ),
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: LatLng(-5.2000, -37.3500),
                      child:
                          Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                    Marker(
                      width: 40.0,
                      height: 40.0,
                      point: LatLng(-5.2100, -37.3600),
                      child:
                          Icon(Icons.location_on, color: Colors.red, size: 40),
                    ),
                  ],
                ),
              ],
            );
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
