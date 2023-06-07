import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:market_watch/models/StockView.dart';
import 'package:market_watch/models/UserProfile.dart';

import '../models/Stock.dart';
import '../utils/MToast.dart';

class DataProvider with ChangeNotifier {
  UserProfile? _userProfile;
  int? _yearController;
  bool _transactionAccess = false;
  int _totalWorth = 0;
  List<Stock> _stocks = [];
  List<StockView> _stocksViews = [];

  final _userProfileDBRef = FirebaseDatabase.instance.ref().child("users");
  final _stocksDBRef = FirebaseDatabase.instance.ref().child("stocks");
  final _yearControllerDBRef =
      FirebaseDatabase.instance.ref().child("yearController");
  final _transactionAccessDBRef =
      FirebaseDatabase.instance.ref().child("transactionAccess");

  late StreamSubscription<DatabaseEvent> _userProfileStream;
  late StreamSubscription<DatabaseEvent> _stocksStream;
  late StreamSubscription<DatabaseEvent> _yearControllerStream;
  late StreamSubscription<DatabaseEvent> _transactionAccessStream;

  UserProfile? get userProfile => _userProfile;
  int? get yearController => _yearController;
  bool get transactionAccess => _transactionAccess;
  int get totalWorth => _totalWorth;
  List<Stock> get stocks => _stocks;
  List<StockView> get stocksViews => _stocksViews;

  Future<void> subscribeToCurrentYear() async {
    _yearControllerStream = _yearControllerDBRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _yearController = event.snapshot.value as int?;
        setupStocksView();
      }
    });
  }

  Future<void> subscribeToTransactionAccess() async {
    _transactionAccessStream = _transactionAccessDBRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        _transactionAccess = event.snapshot.value as bool;
        notifyListeners();
      }
    });
  }

  Future<void> fetchUSerProfile(String userId) async {
    _userProfileStream =
        _userProfileDBRef.child(userId).onValue.listen((event) {
      if (event.snapshot.value != null) {
        final userProfileData =
            UserProfile.fromMap(event.snapshot.value as Map);
        _userProfile = userProfileData;
        setupStocksView();
      }
    });
  }

  Future<void> fetchStocks() async {
    _stocksStream = _stocksDBRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final stocksData =
            Map<String, dynamic>.from(event.snapshot.value as Map);
        _stocks = stocksData.values.map((e) => Stock.fromMap(e)).toList();
        setupStocksView();
      }
    });
  }

  void setupStocksView() {
    if (_userProfile != null) {
      _stocksViews.clear();
      _userProfile!.company.forEach((element) {
        var _stock = _stocks.firstWhere((e) => element.id == e.id);
        var _stockView = StockView(
          id: _stock.id,
          name: _stock.name,
          person: _stock.person,
          tagLine: _stock.tagLine,
          imgUri: _stock.imgUri,
          stocks: element.stocks,
          worth: element.stocks *
              _getCurrentValue(_yearController!, _stock.values),
          isUp: _calculateStatus(_yearController!, _stock.values),
          currentValue: _getCurrentValue(_yearController!, _stock.values),
          currentNews: _getCurrentNews(_yearController!, _stock.news),
          values: _stock.values,
          news: _stock.news,
        );
        _stocksViews.add(_stockView);
      });
      calculateTotalWorth();
    }
    notifyListeners();
  }

  Future<void> sellStocks(
    int qty,
    StockView stockView,
    String userId,
    BuildContext context,
  ) async {
    int total = _getCurrentValue(_yearController!, stockView.values) * qty;
    await _userProfileDBRef
        .child(userId)
        .child("amount")
        .set(_userProfile!.amount + total);
    await _userProfileDBRef
        .child(userId)
        .child("company")
        .child(stockView.id)
        .child("stocks")
        .set(stockView.stocks - qty);
    calculateTotalWorth();
    showMWToast(
      context,
      message: "Transaction Successful!",
      isError: false,
    );
  }

  Future<void> buyStocks(
    int qty,
    StockView stockView,
    String userId,
    BuildContext context,
  ) async {
    int total = _getCurrentValue(_yearController!, stockView.values) * qty;
    if (total <= _userProfile!.amount) {
      await _userProfileDBRef
          .child(userId)
          .child("amount")
          .set(_userProfile!.amount - total);
      await _userProfileDBRef
          .child(userId)
          .child("company")
          .child(stockView.id)
          .child("stocks")
          .set(stockView.stocks + qty);
      calculateTotalWorth();
      showMWToast(
        context,
        message: "Transaction Successful!",
        isError: false,
      );
    } else {
      showMWToast(
        context,
        message: "Don't have enough money",
        isError: true,
      );
    }
  }

  bool _calculateStatus(int yearController, Map<String, int> values) {
    int startYear = (yearController / 10000).round();
    int currentYear = yearController % 10000;
    if (currentYear - startYear == 0) {
      return true;
    }
    int? currentValue = values[currentYear.toString()];
    int? previousValue = values[(currentYear - 1).toString()];
    if (currentValue! >= previousValue!) {
      return true;
    }
    return false;
  }

  int _getCurrentValue(int yearController, Map<String, int> values) {
    int currentYear = yearController % 10000;
    int? currentValue = values[currentYear.toString()];
    return currentValue == null ? 0 : currentValue;
  }

  String _getCurrentNews(int yearController, Map<String, String> news) {
    int currentYear = yearController % 10000;
    String? currentNews = news[currentYear.toString()];
    return currentNews == null ? "" : currentNews;
  }

  void calculateTotalWorth() {
    _totalWorth = 0;
    _stocksViews.forEach((element) {
      _totalWorth += element.worth;
    });
  }

  @override
  void dispose() {
    _userProfileStream.cancel();
    _stocksStream.cancel();
    _yearControllerStream.cancel();
    _transactionAccessStream.cancel();
    super.dispose();
  }
}
