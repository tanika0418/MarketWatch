import 'package:flutter/material.dart';
import 'package:market_watch/providers/ScreenProvider.dart';
import 'package:market_watch/screens/components/ResultViewScreen.dart';
import 'package:market_watch/screens/components/StockViewScreen.dart';
import 'package:market_watch/utils/Constants.dart';
import 'package:provider/provider.dart';

class ViewScreen extends StatefulWidget {
  const ViewScreen({Key? key}) : super(key: key);

  @override
  State<ViewScreen> createState() => _ViewScreenState();
}

class _ViewScreenState extends State<ViewScreen> {
  @override
  Widget build(BuildContext context) {
    String? stockViewId = Provider.of<ScreenProvider>(context).stockViewId;
    Menu activeMenu = Provider.of<ScreenProvider>(context).activeMenu;
    return Scaffold(
      body: activeMenu == Menu.RES
          ? ResultViewScreen()
          : stockViewId == null
              ? Container(
                  color: Colors.white,
                  child: Center(
                    child: CircularProgressIndicator(color: kPrimaryColor),
                  ),
                )
              : StockViewScreen(stockViewId: stockViewId),
    );
  }
}
