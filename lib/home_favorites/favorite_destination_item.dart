import 'package:flutter/material.dart';
import '../data/custom_colors.dart';

class FavoriteItem extends StatelessWidget {
  final String favorite;
  const FavoriteItem(this.favorite);
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 22),
      margin: EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: 150,
        height: 70,
        alignment: Alignment.center,
        decoration: new BoxDecoration(
          color: myWhite, //#FFFFFF
          borderRadius: new BorderRadius.circular(14),
        ),
        child: ListTile(
          contentPadding: EdgeInsets.symmetric(vertical: 8.0),
          leading: Icon(Icons.star, color: myYellow, size: 50), //#FFCC80
          title: Text(
            favorite,
            style: TextStyle(
              fontSize: 20,
              color: myDarkGrey, //#707070
            ),
          ),
          /*trailing: IconButton(
                icon:
                Icon(Icons.more_vert, color: Hexcolor('48ACB8'), size: 50),
                onPressed: () => remove(),
              ),*/
          onTap: () {},
        ),
      ),
    );
  }
}
