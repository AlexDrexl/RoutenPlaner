import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/drawer_home.dart';

class Maps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'uPlan',
            style: TextStyle(color: myWhite, fontSize: 30),
          ),
          iconTheme: IconThemeData(color: myWhite)),
      drawer: DrawerHome(), // Drawer in externer Klasse
      body: Container(),
    );
  }
}
