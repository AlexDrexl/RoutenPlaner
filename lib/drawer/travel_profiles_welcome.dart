import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/data/layoutData.dart';

class TravelProfilesWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(30, 50, 30, 100),
        padding: EdgeInsets.fromLTRB(contentPaddingLR, contentMarginTB,
            contentPaddingLR, contentMarginTB),
        decoration: BoxDecoration(
          color: myWhite,
          boxShadow: [
            BoxShadow(
              color: myMiddleGrey,
              blurRadius: 10,
            )
          ],
          border: Border.all(color: myDarkGrey, width: 1),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            Icon(
              Icons.card_travel,
              size: 50,
              color: myDarkGrey,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Erstelle mit dem Icon am unteren rechten Bildschirmrand ein Reiseprofil, um so deine Routen besser an deine Bedürfnisse anzupassen zu können!",
              style: TextStyle(
                fontSize: 20,
                color: myDarkGrey,
              ),
            ),
            SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}
