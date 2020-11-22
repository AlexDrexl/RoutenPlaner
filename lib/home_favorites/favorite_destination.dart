import 'package:flutter/material.dart';
import 'favorite_destination_item.dart';

///////////////NUTZERPROFILE///////////////
class FavoriteDestination extends StatefulWidget {
  @override
  _FavoriteDestinationState createState() => _FavoriteDestinationState();
}

class _FavoriteDestinationState extends State<FavoriteDestination> {
  List<String> favorite = ['Zu Hause > Arbeit', 'Zu Hause > Schule'];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView.builder(
        itemCount: favorite.length,
        itemBuilder: (context, i) {
          return FavoriteItem(
            favorite[i],
          );
        },
      ),
    );
  }
}
