import 'package:flutter/material.dart';
import 'route_planning.dart';

class HomeButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      //backgroundColor: Hexcolor('48ACB8'),
      child: const Icon(
        Icons.home,
        color: Colors.white,
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute<Widget>(
            builder: (BuildContext context) => RoutePlanning(),
          ),
        );
      },
    );
  }
}
