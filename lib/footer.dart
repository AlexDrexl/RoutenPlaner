import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:routenplaner/route_planning2.dart';
import 'route_planning.dart';
import 'data/custom_colors.dart';

class Footer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white.withOpacity(0),
      child: Container(
        padding: EdgeInsets.only(top: 5, bottom: 5, left: 5, right: 5),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white.withOpacity(0.1),
              Colors.white.withOpacity(0.9),
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            /*Container(
              decoration: BoxDecoration(
                  color: myMiddleTurquoise,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10, color: Colors.white, spreadRadius: 5),
                  ]),
              child: CircleAvatar(
                  radius: 30,
                  backgroundColor: myMiddleTurquoise,
                  child: IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: myWhite,
                      size: 30,
                    ),
                    onPressed: (){
                      Navigator.pop(context);
                    },
                  )),
            ),*/
            Container(
              decoration: BoxDecoration(
                  color: myMiddleTurquoise,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(blurRadius: 10, color: myWhite, spreadRadius: 5),
                  ]),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: myMiddleTurquoise,
                child: IconButton(
                  icon: Icon(Icons.home, color: myWhite, size: 30),
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, '/');
                  },
                ),
              ),
            ),
            /*Container(
              decoration: BoxDecoration(
                  color: myMiddleTurquoise,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 10, color: Colors.white, spreadRadius: 5),
                  ]),
              child: CircleAvatar(
                radius: 30,
                backgroundColor: myMiddleTurquoise,
                child: IconButton(
                  icon: Icon(Icons.arrow_forward_ios,
                      color: wh_white, size: 30),
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute<Widget>(
                            builder: (BuildContext context) =>
                                RoutePlanning2()));
                  },
                ),
              ),
            ),*/
          ],
        ),
      ),
    );
    /*BottomAppBar(
        shape: CircularNotchedRectangle(),
        color: myMiddleGrey,
        child: new Row(
          mainAxisSize: MainAxisSize.max,
          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back_ios, size: 30,),
              onPressed: () {

              },
            ),
            IconButton(
              icon: Icon(Icons.home, size: 30),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            IconButton(
              icon: Icon(Icons.arrow_forward_ios, size: 30),
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/other');

                //geht beides
                /*Navigator.push(context, MaterialPageRoute<Widget>(
                    builder: (BuildContext context) => RoutePlanning2())
                );*/
              },
            ),
          ],
        ),

      );*/
  }
}

_buildNavItem(IconData icon) {
  return CircleAvatar(
    radius: 30,
    backgroundColor: myMiddleTurquoise,
    child: CircleAvatar(
        radius: 25,
        //backgroundColor: Colors.white.withOpacity(0.9),
        child: Icon(
          Icons.bubble_chart,
          color: myMiddleGrey,
        )),
  );
}
