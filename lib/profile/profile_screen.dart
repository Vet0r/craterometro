import 'package:craterometro/theme/theme_colors.dart';
import 'package:craterometro/user.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Perfil", style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          CircleAvatar(
            backgroundColor: ThemeColors.appBarColor,
            radius: 50,
            child: Icon(
              Icons.person,
              size: 50,
              color: ThemeColors.primaryColor,
            ),
          ),
          SizedBox(height: 10),
          Text(
            Provider.of<UserProvider>(context, listen: false).name,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          Text(
            Provider.of<UserProvider>(context, listen: false).email,
            style: TextStyle(fontSize: 16, color: Colors.grey),
          ),
          SizedBox(height: 20),
          Divider(
            thickness: 3,
            color: ThemeColors.primaryColor,
          ),
          SizedBox(height: 10),
          _buildMenuButton(Icons.map, "Buracos na cidade"),
          _buildMenuButton(Icons.home, "Buracos cadastrados por mim"),
          _buildMenuButton(Icons.edit, "Editar dados cadastrais"),
          Spacer(),
          TextButton(
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.of(context).pop();
              Provider.of<UserProvider>(context, listen: false).clearUser();
            },
            child: Text(
              "Desconectar",
              style: TextStyle(color: ThemeColors.primaryColor, fontSize: 16),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildMenuButton(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          padding: EdgeInsets.symmetric(vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: ThemeColors.primaryColor,
            ),
          ),
          elevation: 2,
        ),
        onPressed: () {},
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    icon,
                    color: ThemeColors.primaryColor,
                  ),
                  SizedBox(width: 10),
                  Text(
                    text,
                    style: TextStyle(
                        fontSize: 16, color: ThemeColors.primaryColor),
                  ),
                ],
              ),
              Icon(Icons.arrow_forward_rounded,
                  color: ThemeColors.primaryColor, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
