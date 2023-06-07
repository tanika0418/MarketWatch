import 'dart:async';
import 'dart:html' as html;

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:market_watch/providers/AuthProvider.dart';
import 'package:provider/provider.dart';

import '../models/UserProfile.dart';
import '../providers/DataProvider.dart';
import '../utils/Responsive.dart';
import 'components/ListOfStocks.dart';
import 'components/SideMenu.dart';
import 'components/ViewScreen.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  Future<void> _handleAppClosed() async {
    await html.window.onBeforeUnload.listen((e) async {
      (e as html.BeforeUnloadEvent).returnValue = "Logout? are you sure!";
    });

    await html.window.onUnload.listen((e) async {
      Provider.of<AuthProvider>(context, listen: false).logout();
    });
  }

  Future<void> _createUserProfile() async {
    final _userProfileDBRef = FirebaseDatabase.instance.ref().child("users");
    String userId = Provider.of<AuthProvider>(context, listen: false).user!.uid;
    final _userRefDBRef = FirebaseDatabase.instance.ref().child("userRef");

    await _userProfileDBRef.child(userId).once().then((value) async {
      if (value.snapshot.value != null) {
        return;
      }
      String name, contact = "";
      await _userRefDBRef.child(userId).once().then((event) async {
        var rawDataMap = event.snapshot.value as Map;
        name = rawDataMap["name"].toString();
        contact = rawDataMap["contact"].toString();
        List<Company> company = [];
        final stocks = Provider.of<DataProvider>(context, listen: false).stocks;
        stocks.forEach((element) {
          company.add(Company(id: element.id, stocks: 0));
        });
        final profileData = UserProfile(
          name: name,
          userId: userId,
          amount: 10000,
          company: company,
          contact: contact,
        );
        await _userProfileDBRef.child(userId).set(profileData.toMap());
      });
    });
  }

  Future<void> _fetchData() async {
    await Provider.of<DataProvider>(context, listen: false)
        .subscribeToCurrentYear();
    await Provider.of<DataProvider>(context, listen: false)
        .subscribeToTransactionAccess();
    await Provider.of<DataProvider>(context, listen: false).fetchStocks();
    await _createUserProfile();
    String userId = Provider.of<AuthProvider>(context, listen: false).user!.uid;
    await Provider.of<DataProvider>(context, listen: false)
        .fetchUSerProfile(userId);
  }

  @override
  void initState() {
    _fetchData();
    _handleAppClosed();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    return Scaffold(
      body: Responsive(
        mobile: ListOfStocks(),
        tablet: Row(
          children: [
            Expanded(
              flex: 6,
              child: ListOfStocks(),
            ),
            Expanded(
              flex: 9,
              child: ViewScreen(),
            ),
          ],
        ),
        desktop: Row(
          children: [
            Expanded(
              flex: _size.width > 1340 ? 2 : 4,
              child: SideMenu(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 3 : 5,
              child: ListOfStocks(),
            ),
            Expanded(
              flex: _size.width > 1340 ? 8 : 10,
              child: ViewScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
