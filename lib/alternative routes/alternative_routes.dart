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
          iconTheme: new IconThemeData(color: Colors.white)),
      drawer: DrawerHome(
        screen: "overview",
      ),
      body: Container(
        padding: EdgeInsets.all(0),
        margin: EdgeInsets.all(0),
        color: backgroundColor,
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
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
