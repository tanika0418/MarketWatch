import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:market_watch/models/StockView.dart';
import 'package:market_watch/models/UserProfile.dart';
import 'package:market_watch/providers/DataProvider.dart';
import 'package:market_watch/utils/Extensions.dart';
import 'package:market_watch/utils/MToast.dart';
import 'package:provider/provider.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../../components/Chart.dart';
import '../../components/StockViewHeader.dart';
import '../../utils/Constants.dart';
import '../../utils/Responsive.dart';

class StockViewScreen extends StatefulWidget {
  const StockViewScreen({
    Key? key,
    required this.stockViewId,
  }) : super(key: key);

  final String stockViewId;

  @override
  State<StockViewScreen> createState() => _StockViewScreenState();
}

class _StockViewScreenState extends State<StockViewScreen> {
  final _inputController = new TextEditingController();
  bool _inTransaction = false;

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<StockView> stockViews = Provider.of<DataProvider>(context).stocksViews;
    UserProfile? userProfile = Provider.of<DataProvider>(context).userProfile;
    int? yearController = Provider.of<DataProvider>(context).yearController;
    bool transactionAccess =
        Provider.of<DataProvider>(context).transactionAccess;
    int currentYear = yearController! % 10000;
    StockView stockView =
        stockViews.where((element) => element.id == widget.stockViewId).single;
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            StockViewHeader(
              name: stockView.name,
              imgURi: stockView.imgUri,
              person: stockView.person,
            ),
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
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 4,
                                decoration: BoxDecoration(
                                  color: kPrimaryColor,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ).addNeumorphism(
                                blurRadius: 4,
                                borderRadius: 15,
                                offset: Offset(1, 1),
                                topShadowColor: Colors.white60,
                                bottomShadowColor:
                                    Color(0xFF366CF6).withOpacity(0.30),
                              ),
                              SizedBox(width: kDefaultPadding / 2),
                              Flexible(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Newsletter - " + currentYear.toString(),
                                      style: TextStyle(
                                        height: 1.5,
                                        color: kNewsColor,
                                        fontWeight: FontWeight.bold,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(height: kDefaultPadding / 4),
                                    Text(
                                      stockView.currentNews,
                                      style: TextStyle(
                                        height: 1.5,
                                        color: kNewsColor,
                                        fontWeight: FontWeight.w300,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                    SizedBox(height: kDefaultPadding / 8),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: kDefaultPadding / 2),
                        IntrinsicHeight(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Container(
                                width: 4,
                                decoration: BoxDecoration(
                                  color: stockView.isUp
                                      ? Colors.green
                                      : Colors.red,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                              ).addNeumorphism(
                                blurRadius: 4,
                                borderRadius: 15,
                                offset: Offset(1, 1),
                                topShadowColor: Colors.white60,
                                bottomShadowColor: stockView.isUp
                                    ? Colors.green.withOpacity(0.30)
                                    : Colors.red.withOpacity(0.30),
                              ),
                              Padding(
                                padding: EdgeInsets.all(kDefaultPadding / 4),
                                child: stockView.stocks == 0
                                    ? Row(
                                        children: [
                                          SizedBox(width: kDefaultPadding / 4),
                                          Text(
                                            "You have 0 stocks, buy some to update worth.",
                                            style: TextStyle(
                                              color: kNewsColor,
                                            ),
                                          ),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          SizedBox(width: kDefaultPadding / 2),
                                          WebsafeSvg.asset(
                                            "assets/icons/package.svg",
                                            height: 16,
                                            colorFilter: ColorFilter.mode(
                                              kNewsColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          SizedBox(width: kDefaultPadding / 4),
                                          Text(
                                            convertToMoneyFormat(
                                                stockView.stocks),
                                            style: TextStyle(
                                              color: kNewsColor,
                                            ),
                                          ),
                                          SizedBox(width: kDefaultPadding / 2),
                                          Text("X"),
                                          SizedBox(width: kDefaultPadding / 2),
                                          WebsafeSvg.asset(
                                            "assets/icons/dollar-sign.svg",
                                            height: 16,
                                            colorFilter: ColorFilter.mode(
                                              kNewsColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          SizedBox(width: kDefaultPadding / 4),
                                          Text(
                                            convertToMoneyFormat(
                                                stockView.currentValue),
                                            style: TextStyle(
                                              color: kNewsColor,
                                            ),
                                          ),
                                          SizedBox(width: kDefaultPadding / 2),
                                          Text("="),
                                          SizedBox(width: kDefaultPadding / 2),
                                          WebsafeSvg.asset(
                                            "assets/icons/dollar-sign.svg",
                                            height: 16,
                                            colorFilter: ColorFilter.mode(
                                              kNewsColor,
                                              BlendMode.srcIn,
                                            ),
                                          ),
                                          SizedBox(width: kDefaultPadding / 4),
                                          Text(
                                            convertToMoneyFormat(
                                                stockView.worth),
                                            style: TextStyle(
                                              color: kNewsColor,
                                            ),
                                          ),
                                        ],
                                      ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: kDefaultPadding),
                        BuildChart(
                          values: stockView.values,
                          isUp: stockView.isUp,
                        ),
                        SizedBox(height: kDefaultPadding),
                        if (transactionAccess)
                          Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: kDefaultPadding / 2),
                            child: _inTransaction
                                ? Center(
                                    child: CircularProgressIndicator(
                                      color: kPrimaryColor,
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          if (_inputController
                                              .text.isNotEmpty) {
                                            setState(() {
                                              _inTransaction = true;
                                            });
                                            int qty = int.parse(
                                                _inputController.text.trim());
                                            if (qty > 0) {
                                              final userId =
                                                  userProfile?.userId;
                                              await Provider.of<DataProvider>(
                                                context,
                                                listen: false,
                                              ).buyStocks(
                                                qty,
                                                stockView,
                                                userId!,
                                                context,
                                              );
                                            } else {
                                              showMWToast(
                                                context,
                                                message: "Can't buy 0 stocks",
                                                isError: true,
                                              );
                                            }
                                            _inputController.clear();
                                            setState(() {
                                              _inTransaction = false;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              kDefaultPadding * 0.75),
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Text(
                                            "Buy",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).addNeumorphism(
                                          blurRadius: 15,
                                          borderRadius: 15,
                                          offset: Offset(4, 4),
                                          topShadowColor: Colors.white60,
                                          bottomShadowColor: Color(0xFF366CF6)
                                              .withOpacity(0.30),
                                        ),
                                      ),
                                      SizedBox(width: kDefaultPadding / 2),
                                      Container(
                                        width: Responsive.isMobile(context)
                                            ? 120
                                            : 140,
                                        child: TextField(
                                          controller: _inputController,
                                          keyboardType: TextInputType.number,
                                          textAlign: TextAlign.center,
                                          cursorColor: kPrimaryColor,
                                          inputFormatters: <TextInputFormatter>[
                                            FilteringTextInputFormatter
                                                .digitsOnly,
                                            LengthLimitingTextInputFormatter(6),
                                          ],
                                          decoration: InputDecoration(
                                            hintText: "Stocks...",
                                            fillColor: kBgLightColor,
                                            filled: true,
                                            border: OutlineInputBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                              borderSide: BorderSide.none,
                                            ),
                                          ),
                                        ),
                                      ).addNeumorphism(
                                        blurRadius: 15,
                                        borderRadius: 15,
                                        offset: Offset(4, 4),
                                        topShadowColor: Colors.white60,
                                        bottomShadowColor:
                                            Colors.black.withOpacity(0.15),
                                      ),
                                      SizedBox(width: kDefaultPadding / 2),
                                      InkWell(
                                        onTap: () async {
                                          if (_inputController
                                              .text.isNotEmpty) {
                                            setState(() {
                                              _inTransaction = true;
                                            });
                                            int qty = int.parse(
                                                _inputController.text.trim());
                                            int? limit = userProfile?.company
                                                .where((e) =>
                                                    e.id == widget.stockViewId)
                                                .single
                                                .stocks;
                                            if (qty > 0 && qty <= limit!) {
                                              final userId =
                                                  userProfile?.userId;
                                              await Provider.of<DataProvider>(
                                                context,
                                                listen: false,
                                              ).sellStocks(
                                                qty,
                                                stockView,
                                                userId!,
                                                context,
                                              );
                                            } else {
                                              showMWToast(
                                                context,
                                                message:
                                                    "You don't have enough stocks",
                                                isError: true,
                                              );
                                            }
                                            _inputController.clear();
                                            setState(() {
                                              _inTransaction = false;
                                            });
                                          }
                                        },
                                        child: Container(
                                          padding: EdgeInsets.all(
                                              kDefaultPadding * 0.75),
                                          decoration: BoxDecoration(
                                            color: kPrimaryColor,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Text(
                                            "Sell",
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        ).addNeumorphism(
                                          blurRadius: 15,
                                          borderRadius: 15,
                                          offset: Offset(4, 4),
                                          topShadowColor: Colors.white60,
                                          bottomShadowColor: Color(0xFF366CF6)
                                              .withOpacity(0.30),
                                        ),
                                      ),
                                    ],
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
