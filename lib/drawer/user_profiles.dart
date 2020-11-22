import 'package:flutter/material.dart';
import 'package:routenplaner/drawer/user_profile_addUser.dart';
import 'package:routenplaner/footer.dart';
import 'package:routenplaner/provider_classes/user_profile_collection.dart';
import 'user_item.dart';
import 'drawer_home.dart';
import '../data/custom_colors.dart';
import 'package:provider/provider.dart';

class UserProfiles extends StatefulWidget {
  @override
  _UserProfilesState createState() => _UserProfilesState();
}

class _UserProfilesState extends State<UserProfiles> {
  List<Widget> printUserProfiles(UserProfileCollection profiles) {
    List<Widget> widgetList = List<Widget>();
    for (int i = 0; i < profiles.userProfileCollection.length; i++) {
      widgetList.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                color: myWhite,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  width: (i == profiles.selectedUserProfileIndex ? 4 : 1),
                  color: (i == profiles.selectedUserProfileIndex
                      ? myMiddleTurquoise
                      : myDarkGrey),
                ),
              ),
              margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
              padding: EdgeInsets.fromLTRB(20, 10, 0, 10),
              // Main Row, enthät alles
              child: MaterialButton(
                // Wenn der Button gedrückt, dann soll dieses
                // user Profil ausgewählt werden
                onPressed: () {
                  profiles.selectUserProfile(userIndex: i);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Nur der Icon
                    Icon(
                      Icons.person,
                      color: myYellow,
                      size: 50,
                    ),
                    // Name
                    Text(
                      profiles.userProfileCollection[i].name,
                      style: TextStyle(
                        color: myDarkGrey,
                        fontSize: 25,
                      ),
                    ),
                    // Reihe, um Divider und Punkte näher aneinander zu bringen
                    Row(
                      children: [
                        Container(
                          color: myMiddleGrey,
                          width: 2,
                          height: 40,
                        ),
                        MaterialButton(
                          // Folgende zwei Properties benötigt, um Button kleiner zu machen
                          minWidth: 0,
                          padding: EdgeInsets.all(0),
                          child: Icon(
                            Icons.more_vert,
                            color: myMiddleTurquoise,
                            size: 50,
                          ),
                          onPressed: () {
                            profiles.deleteProfile(indexUserProfile: i);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      );
    }
    return widgetList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff0f0f0),
      appBar: AppBar(
        title: Text(
          'Nutzerprofile',
          style: TextStyle(color: Colors.white, fontSize: 30),
        ),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      drawer: DrawerHome(),
      bottomNavigationBar: Footer(),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            colorFilter: new ColorFilter.mode(
                Colors.grey.withOpacity(0.15), BlendMode.dstATop),
            image: AssetImage("assets/images/citybackground.png"),
            fit: BoxFit.fitWidth,
          ),
        ),
        child: Consumer<UserProfileCollection>(
          builder: (context, profiles, _) => ListView(
            children: printUserProfiles(profiles),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: myMiddleTurquoise,
        onPressed: () {
          showDialog(
            context: context,
            // Dialog Popup
            builder: (context) => Builder(
              builder: (BuildContext context) {
                return AddUserProfileDialogue();
              },
            ),
          );
        },
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),
    );
  }
}

/*
ListView.builder(
          itemCount: user.length,
          itemBuilder: (context, i) {
            return TravelItem(
              user[i],
              () => deleteUser(i),
            );
          },
        ),
        */
