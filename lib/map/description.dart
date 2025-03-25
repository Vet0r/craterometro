import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craterometro/theme/theme_colors.dart';
import 'package:craterometro/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class DescriptionScreen extends StatefulWidget {
  final XFile imageFile;
  LatLng userLocation;

  DescriptionScreen({required this.imageFile, required this.userLocation});

  @override
  _DescriptionScreenState createState() => _DescriptionScreenState();
}

class _DescriptionScreenState extends State<DescriptionScreen> {
  final TextEditingController _descriptionController = TextEditingController();
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Enviar ",
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: ThemeColors.primaryColor,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: Image.file(
                  File(widget.imageFile.path),
                  height: 250,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: _descriptionController,
                maxLines: 4,
                decoration: InputDecoration(
                  hintText: "Digite a descrição...",
                  hintStyle: TextStyle(color: Colors.grey[600]),
                  filled: true,
                  fillColor: Colors.grey[200],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () async {
                    setState(() {
                      isLoading = true;
                    });
                    String description = _descriptionController.text;
                    String fileName =
                        DateTime.now().millisecondsSinceEpoch.toString();
                    Reference ref = FirebaseStorage.instance
                        .ref()
                        .child("images")
                        .child(fileName);
                    await ref.putFile(File(widget.imageFile.path));
                    String link = await ref.getDownloadURL();
                    var user =
                        await Provider.of<UserProvider>(context, listen: false);
                    FirebaseFirestore.instance.collection("markers").doc().set({
                      "description": description,
                      'is_confirmed': false,
                      'is_confirmed_by': [],
                      'is_unconfirmed_by': [],
                      "picture": link,
                      "lat": widget.userLocation.latitude,
                      "long": widget.userLocation.longitude,
                      'user': FirebaseAuth.instance.currentUser!.uid,
                      'user_name': user.name,
                    });
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Text("Descrição Salva"),
                        content: Text("Sua descrição: $description"),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              Navigator.pop(context);
                              Navigator.pop(context);
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                    setState(() {
                      isLoading = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.primaryColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: !isLoading
                      ? Text(
                          "Salvar Descrição",
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        )
                      : CircularProgressIndicator(
                          backgroundColor: Colors.white,
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
