import 'package:flutter/cupertino.dart';

class OverviewChange with ChangeNotifier {
  void refresh() {
    notifyListeners();
  }
}
