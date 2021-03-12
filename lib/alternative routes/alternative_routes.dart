import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/drawer/drawer_home.dart';
import 'alternative_routes_list.dart';

class AlternativeRoutes extends StatelessWidget {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text(
            'uPlan',
            style: TextStyle(color: Colors.white, fontSize: 30),
          ),
          iconTheme: new IconThemeData(color: Colors.white)
          //backgroundColor: Hexcolor("#48ACB8"),
          ),
      // bottomNavigationBar: Footer(),
      drawer: DrawerHome(
        screen: "overview",
      ),

      body: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        color: backgroundColor, //backgroundColor
        child: Scrollbar(
          controller: _scrollController,
          child: SingleChildScrollView(
            controller: _scrollController,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.all(0),
                    decoration: BoxDecoration(boxShadow: [
                      BoxShadow(
                        color: myWhite,
                        blurRadius: 4,
                      ),
                    ]),

                    child: AlternativeRoutesList(),
                    //child: Text("test "),
                    //child: AlternativeRoutesList(),
                  ),
                ]),
          ),
        ),
      ),
    );

/*

      body: Stack(
        children: [
          // Background
          /*Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.grey.withOpacity(0.15), BlendMode.dstATop),
                image: AssetImage("assets/images/citybackground.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            // Hintergrund für das Scrollable
          ), */
          Container(
            margin: EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Container für die Überschrift
                /*
                Container(
                  padding: EdgeInsets.only(left: 15, top: 1, bottom: 1),
                  decoration: BoxDecoration(
                    border: Border.all(width: 1, color: myMiddleGrey),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                    color: myMiddleTurquoise,
                    boxShadow: [
                      BoxShadow(
                        color: myMiddleGrey,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  child: Container(
                    child: Text(
                      "ALTERNATIVE ROUTEN",
                      style: TextStyle(
                        color: myWhite,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ), */
                // Container für den Body
                Container(
                  decoration: BoxDecoration(
                    border: Border.all(width: 0, color: myMiddleGrey),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10), //14
                      bottomRight: Radius.circular(10), //14
                    ),
                    color: myWhite,
                    boxShadow: [
                      BoxShadow(
                        color: myMiddleGrey,
                        blurRadius: 40,
                      )
                    ],
                  ),
                  child: AlternativeRoutesList(),
                ),
              ],
            ),
          ),
        ],
      ), 
      */
    //);
  }
}
