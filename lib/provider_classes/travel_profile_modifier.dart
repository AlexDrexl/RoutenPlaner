import 'package:flutter/material.dart';
import 'travel_profiles_collection.dart';

// Travel Profile Details, Extra Klasse, die gewisse Profile aktualisiert
// Erhöt einerseits den Index, anderer Seits das TravelProfileCollection Objekt, dass
// in main erzeugt wurde
class TravelProfileDetailModifier with ChangeNotifier {
  TravelProfileCollection collection;
  TravelProfileDetailModifier({@required this.collection});

  // Setter Methoden
  void setMinAutomLength({int indexProfile, int length}) {
    collection.travelProfileCollection[indexProfile].minDurationAutomSegment =
        length.toDouble();
    notifyListeners();
  }

  void setMaxDetour({int indexProfile, int length}) {
    collection.travelProfileCollection[indexProfile].maxDetour = length;
    notifyListeners();
  }

  void setIndexTriangle({int indexProfile, int indexTriangle}) {
    collection.travelProfileCollection[indexProfile].indexTriangle =
        indexTriangle;
  }

  // getter methoden
  int getMinAutomLength({int indexProfile}) =>
      collection.travelProfileCollection[indexProfile].minDurationAutomSegment
          .toInt();
  int getMaxDetour({int indexProfile}) =>
      collection.travelProfileCollection[indexProfile].maxDetour.toInt();
  int getIndexTriangle({int indexProfile}) =>
      collection.travelProfileCollection[indexProfile].indexTriangle;
}
