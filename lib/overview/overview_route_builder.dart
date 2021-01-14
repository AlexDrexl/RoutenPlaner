import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/data/custom_colors.dart';
import 'package:routenplaner/provider_classes/final_routes.dart';

import 'overview_route_options.dart';

class OverviewRouteBuilder extends StatefulWidget {
  final Function callback;
  OverviewRouteBuilder({@required void myCallback()}) : callback = myCallback;
  @override
  _OverviewRouteBuilderState createState() => _OverviewRouteBuilderState();
}

class _OverviewRouteBuilderState extends State<OverviewRouteBuilder> {
  /*
  final AsyncMemoizer _memoizer = AsyncMemoizer();
  // Wenn das hier ausgewählt, dann kann nicht mehr aktualisiert werden
  _computeRoute(BuildContext context) {
    return this._memoizer.runOnce(() async {
      await Provider.of<FinalRoutes>(context, listen: false)
          .computeFinalRoutes(context);
      return 'REMOTE DATA';
    });
  }

  _fetchData() async {
    await Future.delayed(Duration(seconds: 2));
    return 'REMOTE DATA';
  }
  */
  Future<bool> computeRoute(BuildContext context) {
    return Provider.of<FinalRoutes>(context, listen: false)
        .computeFinalRoutes(context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: computeRoute(context),
      builder: (context, snapshot) {
        Widget child;
        if (snapshot.hasData &&
            snapshot.connectionState == ConnectionState.done) {
          print("FUTURE BUILDER IS DONE");
          child = OverviewRouteOptions();
        } else if (snapshot.hasError) {
          print("FUTURE BUILDER FAILED");
          print(snapshot.error.toString());
          child = Column(
            children: [
              Text(
                "Routenberechnung gescheitert \nÜberprüfe die Internetverbindung",
                style: TextStyle(color: myDarkGrey),
              ),
              Text(
                "Erneut versuchen?",
                style: TextStyle(color: myDarkGrey),
              ),
              MaterialButton(
                onPressed: () {
                  widget.callback();
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
    );
  }
}
