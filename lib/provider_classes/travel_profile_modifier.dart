import 'dart:math';

import 'package:flutter/material.dart';
import 'package:vector_math/vector_math.dart';
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
      factorMaxAutomLocal,
      factorMinTravTimeLocal,
      factorMinADMDLocal;

  // init FUnktion, setzt die Werte auf den Start, der von Collection gegeben
  // wird. DIe Werte werden aber noch nicht übertragen
  void initializeTravelProfile(
      {@required int indexProfile, @required BuildContext context}) {
    localTravelProfile =
        Provider.of<TravelProfileCollection>(context, listen: false)
            .getTravelProfile(indexProfile: indexProfile);
    // Man muss die Variablen noch einmal lokal speichern, da Provider sonst immer
    // die Werte in Collection mit ändert, save dadurch nicht möglich
    factorMaxAutomLocal = localTravelProfile.factorMaxAutom;
    factorMinADMDLocal = localTravelProfile.factorMinADMD;
    factorMinTravTimeLocal = localTravelProfile.factorMinTravTime;
    minDurationAutomSegmentLocal =
        localTravelProfile.minDurationAutomSegment.toDouble();
    maxDetourLocal = localTravelProfile.maxDetour;
  }

  // Speicher Methode
  void safe(int indexProfile, BuildContext context) {
    print("SAVE CALLED");
    // Wenn gesaved werden soll, wird das gewünschte Profil in der Collection
    // geändert. Die lokalen Daten werden also in Collection gepushed
    Provider.of<TravelProfileCollection>(context, listen: false)
        .modifyTravelProfile(
      profileIndex: indexProfile,
      maxDetour: maxDetourLocal,
      minDurationAutomSegment: minDurationAutomSegmentLocal,
      factorMaxAutom: factorMaxAutomLocal,
      factorMinADMD: factorMinADMDLocal,
      factorMinTravTime: factorMinTravTimeLocal,
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

  int getMinAutomLength() {
    return minDurationAutomSegmentLocal.toInt();
  }

  int getMaxDetour() {
    return maxDetourLocal.toInt();
  }

  // interpretiert die Position des Dreiecks
  void setTriangleFactors(Offset position, Offset dimensionsTriangle) {
    // Abmaße und Position
    var width = dimensionsTriangle.dx;
    var height = dimensionsTriangle.dy;
    var posX = position.dx;
    var posY = position.dy;
    // Vectoren
    var posMiddle = Vector2(width / 2, (width / 2) * tan(pi * 1 / 6));
    var posIcon = Vector2(posX, posY);
    var rotMatrixLeft = Matrix2(
        cos(pi * 2 / 3), sin(pi * 2 / 3), -sin(pi * 2 / 3), cos(pi * 2 / 3));
    var rotMatrixRight = Matrix2(
        cos(pi * 2 / 3), -sin(pi * 2 / 3), sin(pi * 2 / 3), cos(pi * 2 / 3));

    //Verschiebung in die Mitte
    posIcon -= posMiddle;
    // Abstand zu maxAutom direkt ablesbar
    factorMaxAutomLocal = (posIcon.y + posMiddle.y) / height;
    // Rotation um 120 grad im Urzeigersinn
    factorMinTravTimeLocal =
        ((rotMatrixRight * posIcon).y + posMiddle.y) / height;
    // Rotation um 120 grad gegen den Uhrzeigersinn, geht von mittlerem Kosy aus
    factorMinADMDLocal = ((rotMatrixLeft * posIcon).y + posMiddle.y) / height;

    // Erneut berechnen
    /*
    var py = werte[0] * height;
    var px = (py - 2 * height * (1 - werte[1])) / -(sqrt(3));
    print(py);
    print(px);
    */
  }

  // Rück-Interpretiert die Gewichtungsfaktoren in die Icon Position
  Offset getTrianglePosition(Offset triangleDimensions) {
    var py = factorMaxAutomLocal * triangleDimensions.dy;
    var px = (py - 2 * triangleDimensions.dy * (1 - factorMinTravTimeLocal)) /
        -(sqrt(3));
    return Offset(px, py);
  }
}
