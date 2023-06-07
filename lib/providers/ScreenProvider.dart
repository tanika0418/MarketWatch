import 'package:flutter/cupertino.dart';
import 'package:market_watch/utils/Constants.dart';

class ScreenProvider with ChangeNotifier {
  String? _stockViewId;
  Menu _activeMenu = Menu.HOME;

  String? get stockViewId => _stockViewId;
  Menu get activeMenu => _activeMenu;

  Future<void> setStockView(String stockViewId) async {
    _stockViewId = stockViewId;
    notifyListeners();
  }

  Future<void> setActiveMenu(Menu menu) async {
    _activeMenu = menu;
    notifyListeners();
  }
}
