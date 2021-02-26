import 'package:flutter/material.dart';
import 'travel_profiles_collection.dart';
import 'package:provider/provider.dart';
import 'package:routenplaner/data_structures/TravelProfileData.dart';

// travel Proile Modifier speichert die eingegebenen Daten in dieser
// datei. Sollte der User speichern wollen, werden diese durch die funktion
// save in travel Profile collection gepushed
class TravelProfileDetailModifier with ChangeNotifier {
  // TravelProfileCollection collection;
  TravelProfileDetailModifier();
  TravelProfileData localTravelProfile = TravelProfileData();
  int maxDetourLocal;
  double minDurationAutomSegmentLocal,
      xPosTriangleLocal,
      yPosTriangleLocal,
      heightTriangle,
      widthTriangle;

  // init FUnktion, setzt die Werte auf den Start, der von Collection gegeben
  // wird. DIe Werte werden aber noch nicht übertragen
  void init({@required int indexProfile, @required BuildContext context}) {
    localTravelProfile =
        Provider.of<TravelProfileCollection>(context, listen: false)
            .getTravelProfile(indexProfile: indexProfile);
    // Man muss die Variablen noch einmal lokal speichern, da Provider sonst immer
    // die Werte in Collection mit ändert, save dadurch nicht möglich
    xPosTriangleLocal = localTravelProfile.xPosTriangle;
    yPosTriangleLocal = localTravelProfile.yPosTriangle;
    widthTriangle = localTravelProfile.triangleWidth;
    heightTriangle = localTravelProfile.triangleHeight;
    minDurationAutomSegmentLocal =
        localTravelProfile.minDurationAutomSegment.toDouble();
    maxDetourLocal = localTravelProfile.maxDetour;
  }

  // Setter Methoden
  void safe(int indexProfile, BuildContext context) {
    print("SAVE CALLED");
    // Wenn gesaved werden soll, wird das gewünschte Profil in der Collection
    // geändert. Die lokalen Daten werden also in Collection gepushed
    Provider.of<TravelProfileCollection>(context, listen: false)
        .modifyTravelProfile(
      profileIndex: indexProfile,
      maxDetour: maxDetourLocal,
      minDurationAutomSegment: minDurationAutomSegmentLocal,
      xPosTriangle: xPosTriangleLocal,
      yPosTriangle: yPosTriangleLocal,
      heightTriangle: heightTriangle,
      widthTriangle: widthTriangle,
    );
  }

  // In folgenden Setter kein index mehr benötigt, da ohnehin
  // alles nur lokal gespeichert wird
  void setMinAutomLength({int length}) {
    minDurationAutomSegmentLocal = length.toDouble();
    notifyListeners();
  }

  void setMaxDetour({int length}) {
    maxDetourLocal = length;
    notifyListeners();
  }

  // getter methoden
  int getMinAutomLength() {
    return minDurationAutomSegmentLocal.toInt();
  }

  int getMaxDetour() {
    return maxDetourLocal.toInt();
  }

  void setTriangle(Offset position, Offset dimensionsTriangle) {
    xPosTriangleLocal = position.dx;
    yPosTriangleLocal = position.dy;
    heightTriangle = dimensionsTriangle.dy;
    widthTriangle = dimensionsTriangle.dx;
  }
}
