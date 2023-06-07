import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:market_watch/models/StockView.dart';
import 'package:market_watch/providers/ScreenProvider.dart';
import 'package:market_watch/screens/components/SideMenu.dart';
import 'package:market_watch/utils/Extensions.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../components/StockCard.dart';
import '../../models/UserProfile.dart';
import '../../providers/DataProvider.dart';
import '../../utils/Constants.dart';
import '../../utils/Responsive.dart';
import 'ViewScreen.dart';

class ListOfStocks extends StatefulWidget {
  const ListOfStocks({Key? key}) : super(key: key);

  @override
  _ListOfStocksState createState() => _ListOfStocksState();
}

class _ListOfStocksState extends State<ListOfStocks> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  int activeIndex = 0;

  String _getCurrentYear(int? yearController) {
    if (yearController == null || yearController.toString().length != 8) {
      return "****";
    }
    return (yearController % 10000).toString();
  }

  String _getRevision(int? yearController) {
    if (yearController == null || yearController.toString().length != 8) {
      return "*";
    }
    int startYear = (yearController / 10000).round();
    int currentYear = yearController % 10000;
    return (currentYear - startYear).toString();
  }

  void _setStockViewId(String stockViewId) {
    Provider.of<ScreenProvider>(context, listen: false)
        .setStockView(stockViewId);
  }

  void _setActive(int index) {
    setState(() {
      activeIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    UserProfile? userProfile = Provider.of<DataProvider>(context).userProfile;
    List<StockView> stockViews = Provider.of<DataProvider>(context).stocksViews;
    int? yearController = Provider.of<DataProvider>(context).yearController;
    Menu activeMenu = Provider.of<ScreenProvider>(context).activeMenu;
    Future.delayed(Duration.zero, () {
      if (mounted && stockViews.isNotEmpty) {
        _setStockViewId(stockViews[activeIndex].id);
      }
    });
    return stockViews.isEmpty
        ? Center(
            child: CircularProgressIndicator(color: kPrimaryColor),
          )
        : Scaffold(
            key: _scaffoldKey,
            drawer: ConstrainedBox(
              constraints: BoxConstraints(maxWidth: 250),
              child: SideMenu(),
            ),
            body: Container(
              padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
              color: kBgDarkColor,
              child: SafeArea(
                right: false,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          if (!Responsive.isDesktop(context))
                            IconButton(
                              icon: Icon(Icons.menu),
                              onPressed: () {
                                _scaffoldKey.currentState?.openDrawer();
                              },
                            ),
                          if (!Responsive.isDesktop(context))
                            SizedBox(width: 5),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(kDefaultPadding),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: FittedBox(
                                      fit: BoxFit.scaleDown,
                                      child: Text(
                                        "Your Bal:",
                                        style: TextStyle(color: kTextColor),
                                      ),
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      WebsafeSvg.asset(
                                        "assets/icons/dollar-sign.svg",
                                        colorFilter: ColorFilter.mode(
                                          kTextColor,
                                          BlendMode.srcIn,
                                        ),
                                        height: 16,
                                      ),
                                      Text(
                                        convertToMoneyFormat(
                                            userProfile?.amount),
                                        style: TextStyle(color: kTextColor),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ).addNeumorphism(
                              blurRadius: 15,
                              borderRadius: 15,
                              offset: Offset(5, 5),
                              topShadowColor: Colors.white60,
                              bottomShadowColor:
                                  Color(0xFF234395).withOpacity(0.15),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: kDefaultPadding),
                      child: Row(
                        children: [
                          WebsafeSvg.asset(
                            "assets/icons/calendar.svg",
                            height: 16,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Current Year : " + _getCurrentYear(yearController),
                            style: TextStyle(fontWeight: FontWeight.w500),
                          ),
                          Spacer(),
                          Text(
                            "Rev (" + _getRevision(yearController) + ")",
                            style: TextStyle(color: kTextColor),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: kDefaultPadding),
                    Expanded(
                      child: Padding(
                        padding:
                            const EdgeInsets.only(bottom: kDefaultPadding / 2),
                        child: ListView.builder(
                          itemCount: stockViews.length,
                          itemBuilder: (context, index) => StockCard(
                            isActive: Responsive.isMobile(context)
                                ? false
                                : activeMenu == Menu.HOME
                                    ? index == activeIndex
                                    : false,
                            stockView: stockViews[index],
                            press: () {
                              Provider.of<ScreenProvider>(context,
                                      listen: false)
                                  .setActiveMenu(Menu.HOME);
                              if (Responsive.isMobile(context)) {
                                _setActive(index);
                                _setStockViewId(stockViews[index].id);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ViewScreen(),
                                  ),
                                );
                              } else {
                                _setActive(index);
                                _setStockViewId(stockViews[index].id);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}
