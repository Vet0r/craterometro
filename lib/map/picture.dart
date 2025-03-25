import 'package:craterometro/map/description.dart';
import 'package:craterometro/theme/theme_colors.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:latlong2/latlong.dart';

class CameraScreen extends StatefulWidget {
  LatLng userLocation;
  CameraScreen({super.key, required this.userLocation});
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;

  Future<void> _takePhoto() async {
    final XFile? image =
        await _picker.pickImage(source: ImageSource.camera, imageQuality: 50);
    setState(() {
      if (image != null) {
        _imageFile = image;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text(
          "Capturar Foto",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: ThemeColors.primaryColor,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            _imageFile == null
                ? Icon(
                    Icons.camera_alt,
                    size: 120,
                    color: ThemeColors.primaryColor,
                  )
                : ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Image.file(
                      File(_imageFile!.path),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _takePhoto,
                icon: Icon(Icons.camera, color: Colors.white),
                label: Text(
                  "Tirar Foto",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ThemeColors.primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
            SizedBox(height: 15),
            _imageFile != null
                ? SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => DescriptionScreen(
                                imageFile: _imageFile!,
                                userLocation: widget.userLocation),
                          ),
                        );
                      },
                      icon: Icon(Icons.edit, color: Colors.white),
                      label: Text(
                        "Adicionar Descrição",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}
