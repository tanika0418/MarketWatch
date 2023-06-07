import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:market_watch/models/UserProfile.dart';
import 'package:market_watch/utils/Extensions.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../components/SideMenuItem.dart';
import '../../providers/DataProvider.dart';
import '../../providers/ScreenProvider.dart';
import '../../utils/Constants.dart';
import '../../utils/MToast.dart';
import '../../utils/Responsive.dart';
import 'ViewScreen.dart';

class SideMenu extends StatefulWidget {
  const SideMenu({Key? key}) : super(key: key);

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  @override
  Widget build(BuildContext context) {
    UserProfile? userProfile = Provider.of<DataProvider>(context).userProfile;
    Menu activeMenu = Provider.of<ScreenProvider>(context).activeMenu;
    return Container(
      height: double.infinity,
      padding: EdgeInsets.only(top: kIsWeb ? kDefaultPadding : 0),
      color: Colors.white,
      child: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: kDefaultPadding),
          child: Column(
            children: [
              SizedBox(height: kDefaultPadding / 2),
              Row(
                children: [
                  WebsafeSvg.asset(
                    "assets/icons/marketwatch-logo.svg",
                    height: 22,
                  ),
                  Spacer(),
                  if (!Responsive.isDesktop(context)) CloseButton(),
                ],
              ),
              SizedBox(height: kDefaultPadding * 1.5),
              Container(
                padding: EdgeInsets.all(kDefaultPadding),
                decoration: BoxDecoration(
                  color: kPrimaryColor,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: userProfile == null
                    ? Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      )
                    : Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: FittedBox(
                                  child: Text(
                                    userProfile.name,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: kDefaultPadding / 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Flexible(
                                child: FittedBox(
                                  child: Text(
                                    userProfile.contact,
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
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
                bottomShadowColor: Color(0xFF366CF6).withOpacity(0.50),
              ),
              SizedBox(height: kDefaultPadding),
              SideMenuItem(
                press: () {
                  if (activeMenu == Menu.HOME) {
                    return;
                  }
                  Provider.of<ScreenProvider>(context, listen: false)
                      .setActiveMenu(Menu.HOME);
                  if (!Responsive.isDesktop(context)) {
                    Navigator.of(context).pop();
                  }
                },
                title: "Home",
                iconSrc: "assets/icons/home.svg",
                isActive: activeMenu == Menu.HOME,
              ),
              SideMenuItem(
                press: () {
                  showMWToast(
                    context,
                    message: "Transaction history locked",
                    isError: true,
                  );
                },
                title: "Transactions",
                iconSrc: "assets/icons/dollar-sign.svg",
                isActive: activeMenu == Menu.TRANS,
              ),
              SideMenuItem(
                press: () async {
                  if (activeMenu == Menu.RES) {
                    return;
                  }
                  final _resultOpenDBRef =
                      FirebaseDatabase.instance.ref().child("resultOpen");
                  await _resultOpenDBRef.once().then((value) async {
                    if (value.snapshot.value as bool) {
                      Provider.of<ScreenProvider>(context, listen: false)
                          .setActiveMenu(Menu.RES);
                      if (Responsive.isMobile(context)) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ViewScreen(),
                          ),
                        );
                      }
                      if (Responsive.isTablet(context)) {
                        Navigator.of(context).pop();
                      }
                    } else {
                      showMWToast(
                        context,
                        message: "Results will be declared after final round",
                        isError: false,
                      );
                    }
                  });
                },
                title: "Results",
                iconSrc: "assets/icons/file-text.svg",
                isActive: activeMenu == Menu.RES,
              ),
              SideMenuItem(
                press: () {},
                title: "Version 0.1.1",
                iconSrc: "assets/icons/info.svg",
                isActive: false,
                showBorder: false,
              ),
              SizedBox(height: kDefaultPadding * 2),
            ],
          ),
        ),
      ),
    );
  }
}
