import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:craterometro/map/widgets/show_full_image.dart';
import 'package:craterometro/theme/theme_colors.dart';
import 'package:craterometro/user.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void showReportPopup(BuildContext context, String imageUrl, String username,
    String description, String id) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
                showFullImage(context, imageUrl);
              },
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                child: Image.network(
                  imageUrl,
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 200,
                      color: Colors.grey[300],
                      child: Icon(Icons.image, size: 80, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    username,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Text(
                    description,
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: Text("Confirmação"),
                            content:
                                Text("Você confirma que esse buraco existe?"),
                            actions: [
                              TextButton(
                                onPressed: () async {
                                  FirebaseFirestore.instance
                                      .collection('markers')
                                      .doc(id)
                                      .update({
                                    'is_unconfirmed_by': FieldValue.arrayUnion([
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .uid
                                    ])
                                  });
                                  var doc = await FirebaseFirestore.instance
                                      .collection('markers')
                                      .doc(id)
                                      .get();
                                  if ((doc.data()!['is_unconfirmed_by']
                                              as List<String>)
                                          .length >
                                      5) {
                                    final Reference ref = FirebaseStorage
                                        .instance
                                        .refFromURL(imageUrl);
                                    ref.delete();
                                    FirebaseFirestore.instance
                                        .collection('markers')
                                        .doc(id)
                                        .delete();
                                  }
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text("Negar",
                                    style: TextStyle(color: Colors.red)),
                              ),
                              TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text("Cancelar",
                                    style: TextStyle(
                                        color: ThemeColors.accentColor)),
                              ),
                              TextButton(
                                onPressed: () async {
                                  await FirebaseFirestore.instance
                                      .collection('markers')
                                      .doc(id)
                                      .update({
                                    'is_confirmed_by': FieldValue.arrayUnion([
                                      Provider.of<UserProvider>(context,
                                              listen: false)
                                          .uid
                                    ])
                                  });
                                  var doc = await FirebaseFirestore.instance
                                      .collection('markers')
                                      .doc(id)
                                      .get();
                                  if ((doc.data()!['is_confirmed_by']
                                              as List<String>)
                                          .length >
                                      5) {
                                    FirebaseFirestore.instance
                                        .collection('markers')
                                        .doc(id)
                                        .update({'is_confirmed': true});
                                  }
                                  Navigator.pop(context);
                                  Navigator.pop(context);
                                },
                                child: Text("Aprovar",
                                    style: TextStyle(color: Colors.green)),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child:
                        Text("Aprovar", style: TextStyle(color: Colors.blue))),
                Provider.of<UserProvider>(context, listen: false).isAdmin
                    ? IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Deletar ponto"),
                                content: Text(
                                    "Tem certeza que deseja deletar este ponto?"),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: Text("Cancelar",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      final Reference ref = FirebaseStorage
                                          .instance
                                          .refFromURL(imageUrl);
                                      ref.delete();
                                      Navigator.pop(context);
                                      Navigator.pop(context);
                                      FirebaseFirestore.instance
                                          .collection('markers')
                                          .doc(id)
                                          .delete();
                                    },
                                    child: Text("Deletar",
                                        style: TextStyle(color: Colors.red)),
                                  ),
                                ],
                              );
                            },
                          );
                        },
                      )
                    : Container(),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text("Fechar", style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        ),
      );
    },
  );
}
