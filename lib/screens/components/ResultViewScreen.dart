import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:market_watch/components/ResultHeader.dart';
import 'package:market_watch/providers/DataProvider.dart';
import 'package:provider/provider.dart';

import '../../models/StockView.dart';
import '../../models/UserProfile.dart';
import '../../utils/Constants.dart';

class ResultViewScreen extends StatefulWidget {
  const ResultViewScreen({Key? key}) : super(key: key);

  @override
  State<ResultViewScreen> createState() => _ResultViewScreen();
}

class _ResultViewScreen extends State<ResultViewScreen> {
  List<UserResult> _userResults = [];

  Future<List<UserResult>> _getResults(
      int currentYear, List<StockView> stockViews) async {
    final List<UserResult> userResult = [];
    final _userProfileDBRef = FirebaseDatabase.instance.ref().child("users");

    await _userProfileDBRef.onValue.listen((event) {
      if (event.snapshot.value != null) {
        final userProfileData = event.snapshot.value as Map;
        userProfileData.forEach((k, v) {
          final userProfileData = UserProfile.fromMap(v as Map);
          int totalWorth = 0;
          for (Company company in userProfileData.company) {
            int worth = company.stocks *
                stockViews
                    .firstWhere((element) => element.id == company.id)
                    .currentValue;
            totalWorth += worth;
          }
          userResult.add(
              UserResult(name: userProfileData.name, totalWorth: totalWorth));
        });
      }
    });
    return userResult;
  }

  @override
  Widget build(BuildContext context) {
    List<StockView> stockViews = Provider.of<DataProvider>(context).stocksViews;
    int? yearController = Provider.of<DataProvider>(context).yearController;
    int currentYear = yearController! % 10000;
    Future.delayed(Duration.zero, () async {
      if (mounted && stockViews.isNotEmpty) {
        final List<UserResult> userResults =
            await _getResults(currentYear, stockViews);
        setState(() {
          _userResults = userResults;
          _userResults.sort((a, b) => b.totalWorth - a.totalWorth);
        });
      }
    });
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            ResultHeader(),
            Divider(thickness: 1),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(kDefaultPadding),
                child: LayoutBuilder(
                  builder: (context, constraints) => SizedBox(
                    width:
                        constraints.maxWidth > 850 ? 800 : constraints.maxWidth,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _userResults.isEmpty
                            ? Center(
                                child: CircularProgressIndicator(),
                              )
                            : SingleChildScrollView(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: kDefaultPadding / 2),
                                  child: ListView.builder(
                                    shrinkWrap: true,
                                    itemCount: _userResults.length,
                                    itemBuilder: (context, index) => ListTile(
                                      title: Text(_userResults[index].name),
                                      leading: Text(convertToMoneyFormat(
                                          _userResults[index].totalWorth)),
                                    ),
                                  ),
                                ),
                              ),
                        SizedBox(height: kDefaultPadding / 2),
                        Divider(thickness: 1),
                        SizedBox(height: kDefaultPadding / 2),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class UserResult {
  String name;
  int totalWorth;

  UserResult({
    required this.name,
    required this.totalWorth,
  });
}
