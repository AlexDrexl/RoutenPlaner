import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/data/layoutData.dart';

class TravelProfilesWelcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: EdgeInsets.fromLTRB(20, 50, 20, 100),
        padding: EdgeInsets.fromLTRB(contentPaddingLR, contentMarginTB,
            contentPaddingLR, contentMarginTB),
        decoration: BoxDecoration(
          color: myLightGrey, //myWhite
          /*boxShadow: [
            BoxShadow(
              color: myMiddleGrey,
              blurRadius: 0, //10
            )
          ],
          border: Border.all(color: myDarkGrey, width: 0), //1 */
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              height: 20,
            ),
            /*Icon(
              Icons.card_travel,
              size: 50,
              color: myDarkGrey,
            ), */
            SizedBox(
              height: 20,
            ),
            Text(
              "Erstellen Sie ein Reiseprofil, um Ihre Routen schneller und einfacher an Ihre Bedürfnisse anzupassen zu können!",
              textAlign: TextAlign.center,
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
