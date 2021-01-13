import 'package:flutter/material.dart';
import 'travel_profiles_collection.dart';
import 'package:provider/provider.dart';

// travel Proile Modifier speichert die eingegebenen Daten in dieser
// datei. Sollte der User speichern wollen, werden diese durch die funktion
// save in travel Profile collection gepushed
class TravelProfileDetailModifier with ChangeNotifier {
  // TravelProfileCollection collection;
  TravelProfileDetailModifier();
  TravelProfileData localTravelProfile = TravelProfileData();
  int indexTriangleLocal, maxDetourLocal;
  double minDurationAutomSegmentLocal;

  // init FUnktion, setzt die Werte auf den Start, der von Collection gegeben
  // wird. DIe Werte werden aber noch nicht übertragen
  void init({@required int indexProfile, @required BuildContext context}) {
    localTravelProfile =
        Provider.of<TravelProfileCollection>(context, listen: false)
            .getTravelProfile(indexProfile: indexProfile);
    // Man muss die Variablen noch einmal lokal speichern, da Provider sonst immer
    // die Werte in Collection mit ändert, save dadurch nicht möglich
    indexTriangleLocal = localTravelProfile.indexTriangle;
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
      indexTriangle: indexTriangleLocal,
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

  void setIndexTriangle({int indexTriangle}) {
    indexTriangleLocal = indexTriangle;
  }

  // getter methoden
  int getMinAutomLength() {
    return minDurationAutomSegmentLocal.toInt();
  }

  int getMaxDetour() {
    return maxDetourLocal.toInt();
  }

  int getIndexTriangle() {
    return indexTriangleLocal;
  }
}
