import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

standardMarker(Color color, LatLng latLng, Function onTap) {
  return Marker(
    width: 40.0,
    height: 40.0,
    point: latLng,
    child: GestureDetector(
        child: Icon(Icons.location_on, color: color, size: 40),
        onTap: () {
          onTap();
        }),
  );
}
