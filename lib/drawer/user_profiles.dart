import 'package:flutter/material.dart';
import 'package:routenplaner/drawer/user_profile_addUser.dart';
import 'package:routenplaner/main/footer.dart';
import 'package:routenplaner/provider_classes/user_profile_collection.dart';
import 'delete_pupup.dart';
import 'drawer_home.dart';
import '../data/custom_colors.dart';
import 'package:provider/provider.dart';

class UserProfiles extends StatefulWidget {
  @override
  _UserProfilesState createState() => _UserProfilesState();
}

class _UserProfilesState extends State<UserProfiles> {
  GlobalKey key = GlobalKey();
  List<Widget> printUserProfiles(UserProfileCollection profiles) {
    List<Widget> widgetList = List<Widget>();
    for (int i = 0; i < profiles.userProfileCollection.length; i++) {
      GlobalKey key = GlobalKey();
      widgetList.add(
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // MAIN CONTAINER
            Container(
              key: key,
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
                        fontSize: 20,
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
                        // DIese Button ersetzen durch ein Dropout Menu
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
                            // profiles.deleteProfile(indexUserProfile: i);
                            RenderBox box =
                                key.currentContext.findRenderObject();
                            Offset position = box.localToGlobal(Offset.zero);
                            var fullHeight = MediaQuery.of(context).size.height;
                            var fullWidth = MediaQuery.of(context).size.width;
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: EdgeInsets.only(
                                    top: position.dy - 10,
                                    right: 25,
                                    bottom: fullHeight - position.dy - 83,
                                    left: fullWidth - 310,
                                  ),
                                  backgroundColor: myMiddleTurquoise,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      // Drei Container für die Drei Button
                                      // Bearbeiten
                                      Container(
                                        padding: EdgeInsets.only(right: 5),
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                            showDialog(
                                              context: context,
                                              // Dialog Popup
                                              builder: (context) => Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return AddUserProfileDialogue(
                                                    modifyMode: true,
                                                    profileIndex4modify: i,
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.edit,
                                            color: myWhite,
                                          ),
                                        ),
                                      ),
                                      // Delete
                                      Container(
                                        padding: EdgeInsets.only(right: 5),
                                        child: FloatingActionButton(
                                          onPressed: () async {
                                            Navigator.of(context).pop(true);
                                            await showDialog(
                                              context: context,
                                              // Dialog Popup, fragt den user nach bestätigung
                                              builder: (context) => Builder(
                                                builder:
                                                    (BuildContext context) {
                                                  return DeletePopUp(
                                                    index: i,
                                                    userProfileCollection: Provider
                                                        .of<UserProfileCollection>(
                                                            context,
                                                            listen: false),
                                                  );
                                                },
                                              ),
                                            );
                                          },
                                          child: Icon(
                                            Icons.delete,
                                            color: myWhite,
                                          ),
                                        ),
                                      ),
                                      // Duplicate
                                      Container(
                                        padding: EdgeInsets.only(right: 5),
                                        child: FloatingActionButton(
                                          onPressed: () {
                                            profiles.duplicateProfile(
                                                indexUserProfile: i);
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Icon(
                                            Icons.copy,
                                            color: myWhite,
                                          ),
                                        ),
                                      ),
                                      // Container für vertikalen Strich
                                      Container(
                                        height: 40,
                                        width: 2,
                                        color: myWhite,
                                      ),
                                      // Container für den Drei Punkte Icon, Wird
                                      // verwendet um Höhe einzustellen
                                      Container(
                                        padding: EdgeInsets.only(
                                            right: 0, top: 10, bottom: 10),
                                        child: MaterialButton(
                                          minWidth: 0,
                                          onPressed: () {
                                            Navigator.of(context).pop(true);
                                          },
                                          child: Icon(
                                            Icons.more_vert,
                                            color: myWhite,
                                            size: 50,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
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
                return AddUserProfileDialogue(modifyMode: false);
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
