import 'package:flutter/material.dart';
import 'drawer_home.dart';
import '../main/footer.dart';

// popup, das kommt wenn man auf ein Nutzerprofil klickt
class UserDetail extends StatelessWidget {
  const UserDetail(this.user);
  final String user;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Nutzerprofile',
          style: TextStyle(fontSize: 30, color: Colors.white),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
        //backgroundColor: Colors.transparent,
      ),
      drawer: DrawerHome(),
      bottomNavigationBar: Footer(),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 70),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                alignment: Alignment.center,
                child: Text(
                  'Das ist dein Nutzerprofil',
                  style: TextStyle(fontSize: 20, color: Colors.black),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Expanded(
              child: Container(
                  alignment: Alignment.center,
                  child: Text(user,
                      style: TextStyle(fontSize: 50, color: Colors.black))),
            ),
            Expanded(
              child: IconButton(
                iconSize: 60,
                onPressed: () => Navigator.pop(context),
                icon: Icon(Icons.person, color: Colors.black),
              ),
            )
          ],
        ),
      ),
    );
  }
}
