import 'package:flutter/material.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/drawer/drawer_home.dart';
import 'package:routenplaner/overview/overview_footer_pupup.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';
import 'package:routenplaner/provider_classes/overview_change.dart';
import 'overview_route_input.dart';
import 'package:routenplaner/overview/overview_route_options.dart';

class Overview extends StatefulWidget {
  @override
  _OverviewState createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  final _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'uPlan',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
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
              Container(
                decoration: BoxDecoration(
                    color: myMiddleTurquoise,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                          blurRadius: 10, color: myWhite, spreadRadius: 5),
                    ]),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: myMiddleTurquoise,
                  child: IconButton(
                    icon: Icon(Icons.home, color: myWhite, size: 30),
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return OverviewFooterPopup();
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      drawer: DrawerHome(),
      body: Scrollbar(
        controller: _scrollController,
        isAlwaysShown: true,
        child: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
            // Container benötigt, um den Background zu erstellen
            decoration: BoxDecoration(
              image: DecorationImage(
                colorFilter: new ColorFilter.mode(
                    Colors.grey.withOpacity(0.15), BlendMode.dstATop),
                image: AssetImage("assets/images/citybackground.png"),
                fit: BoxFit.fitWidth,
              ),
            ),
            // Spalte für die zwei Cards
            child: Column(
              // Damit der Container über die gesamte Breite geht
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Überschrift ROUTENEINGABE
                Container(
                  // generelles Aussehen
                  decoration: BoxDecoration(
                    border: Border.all(width: 0, color: myMiddleGrey),
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(14),
                        topRight: Radius.circular(14)),
                    color: myMiddleTurquoise,
                    boxShadow: [
                      BoxShadow(
                        color: myMiddleGrey,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  // Platzierung des Text Widgets in der Zeile
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, top: 25),
                  // String ROUTENEINGABE
                  child: Text(
                    "ROUTENEINGABE",
                    style: TextStyle(
                      color: myWhite,
                      fontSize: 20,
                    ),
                  ),
                  // Eigentlicher Überblick über eingegebe Route
                ),
                // Routen input Overview
                Container(
                  // generelles Aussehen
                  decoration: BoxDecoration(
                      border: Border.all(width: 0, color: myMiddleGrey),
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(14),
                        bottomRight: Radius.circular(14),
                      ),
                      color: myWhite,
                      boxShadow: [
                        BoxShadow(
                          color: myMiddleGrey,
                          blurRadius: 4,
                        )
                      ]),
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  child: OverviewRouteInput(),
                ),
                // Überschrift ROUTENOPTIONEN
                Container(
                  // generelles Aussehen
                  decoration: BoxDecoration(
                      border: Border.all(width: 0, color: myMiddleGrey),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(14),
                          topRight: Radius.circular(14)),
                      color: myMiddleTurquoise,
                      boxShadow: [
                        BoxShadow(
                          color: myMiddleGrey,
                          blurRadius: 4,
                        )
                      ]),
                  // Platzierung des Text Widgets in der Zeile
                  padding: EdgeInsets.only(top: 8, bottom: 8, left: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, top: 25),
                  // String ROUTENEINGABE
                  child: Text(
                    "ROUTENOPTIONEN",
                    style: TextStyle(
                      color: myWhite,
                      fontSize: 20,
                    ),
                  ),
                  // Eigentlicher Überblick über eingegebe Route
                ),
                // Routen Optionen
                Container(
                  // generelles Aussehen
                  decoration: BoxDecoration(
                    border: Border.all(width: 0, color: myMiddleGrey),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                    color: myWhite,
                    boxShadow: [
                      BoxShadow(
                        color: myMiddleGrey,
                        blurRadius: 4,
                      )
                    ],
                  ),
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 15, right: 15),
                  margin: EdgeInsets.only(left: 25, right: 25, bottom: 25),
                  // Gesamtübersicht Routenoptionen
                  ///////////
                  ///
                  ///
                  /// WICHTIG: Wenn Änderung, dann wird dieser Block rebuilded
                  /// dadurch wird der gesamte Routenerstellungsprozess erneut gestartet
                  child: Consumer<OverviewChange>(
                    builder: (context, finalRoutes, _) => FutureBuilder<bool>(
                      future: Provider.of<FinalRoutes>(context, listen: false)
                          .computeFinalRoutes(context),
                      builder: (context, snapshot) {
                        Widget child;
                        if (snapshot.hasData &&
                            snapshot.connectionState == ConnectionState.done) {
                          print("FUTURE BUILDER IS DONE");
                          child = OverviewRouteOptions();
                        } else if (snapshot.hasError) {
                          print("FUTURE BUILDER FAILED");
                          print(snapshot.error);
                          child = Column(
                            children: [
                              Text(
                                "Routenberechnung gescheitert",
                                style: TextStyle(color: myDarkGrey),
                              ),
                              Text(
                                "Erneut versuchen?",
                                style: TextStyle(color: myDarkGrey),
                              ),
                              MaterialButton(
                                onPressed: () {
                                  Provider.of<OverviewChange>(context,
                                          listen: false)
                                      .refresh();
                                },
                                child: Icon(
                                  Icons.refresh,
                                  size: 30,
                                  color: myMiddleTurquoise,
                                ),
                              ),
                            ],
                          );
                        } else {
                          print("ONGOING FUTURE BUILDER");
                          child = Align(
                            alignment: Alignment.center,
                            child: SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            ),
                          );
                        }
                        return Container(
                          child: child,
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
