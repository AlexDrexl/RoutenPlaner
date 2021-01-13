import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:async/async.dart';

class OverviewChange with ChangeNotifier {
  // NUR EINMAL AUFGERUFEN
  void refresh() {
    notifyListeners();
  }
}
