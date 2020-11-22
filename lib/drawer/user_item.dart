import 'package:flutter/material.dart';
import '../data/custom_colors.dart';

import 'user_detail.dart';

class TravelItem extends StatelessWidget {
  final String user;
  final Function remove;
  const TravelItem(this.user, this.remove);
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 25, left: 25, right: 25),
      child: Container(
        width: 150,
        height: 70,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          color: myWhite,
          borderRadius: new BorderRadius.circular(14),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 25, right: 15),
          leading: Icon(Icons.person, color: myYellow, size: 50),
          title: Text(
            user,
            style: TextStyle(
              fontSize: 20,
              color: myDarkGrey,
            ),
          ),
          trailing: IconButton(
            icon: Icon(Icons.more_vert, color: myMiddleTurquoise, size: 50),
            onPressed: () => remove(),
          ),
          onTap: () {
            Navigator.push<Widget>(
              context,
              MaterialPageRoute<Widget>(
                builder: (BuildContext context) => UserDetail(user),
              ),
            );
          },
        ),
      ),
    );
  }
}
