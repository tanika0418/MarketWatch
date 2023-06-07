import 'package:flutter/material.dart';
import 'package:market_watch/models/StockView.dart';
import 'package:market_watch/utils/Extensions.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../utils/Constants.dart';

class StockCard extends StatelessWidget {
  const StockCard({
    Key? key,
    this.isActive = true,
    required this.stockView,
    required this.press,
  }) : super(key: key);

  final bool isActive;
  final StockView stockView;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: kDefaultPadding, vertical: kDefaultPadding / 2),
      child: InkWell(
        onTap: press,
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.all(kDefaultPadding),
              decoration: BoxDecoration(
                color: isActive ? Colors.white : kBgLightColor,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      WebsafeSvg.asset(stockView.imgUri, width: 32),
                      SizedBox(width: kDefaultPadding / 2),
                      Expanded(
                        child: Text.rich(
                          TextSpan(
                            text: stockView.name + "\n",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                              color: kTextColor,
                            ),
                            children: [
                              TextSpan(
                                text: stockView.tagLine,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: kTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: kDefaultPadding / 2),
                      WebsafeSvg.asset(
                        stockView.isUp
                            ? "assets/icons/trending-up.svg"
                            : "assets/icons/trending-down.svg",
                        height: 20,
                        colorFilter: ColorFilter.mode(
                          stockView.isUp ? Colors.green : Colors.red,
                          BlendMode.srcIn,
                        ),
                      ).addNeumorphism(),
                    ],
                  ),
                  SizedBox(height: kDefaultPadding),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          SizedBox(width: kDefaultPadding / 4),
                          WebsafeSvg.asset(
                            "assets/icons/package.svg",
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              kTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: kDefaultPadding / 4),
                          Text(
                            convertToMoneyFormat(stockView.stocks),
                            style: TextStyle(
                              color: kTextColor,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          SizedBox(width: kDefaultPadding / 4),
                          WebsafeSvg.asset(
                            "assets/icons/dollar-sign.svg",
                            height: 16,
                            colorFilter: ColorFilter.mode(
                              kTextColor,
                              BlendMode.srcIn,
                            ),
                          ),
                          SizedBox(width: kDefaultPadding / 4),
                          Text(
                            convertToMoneyFormat(stockView.currentValue),
                            style: TextStyle(
                              color: kTextColor,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        height: 1,
                        width: 1,
                        color: isActive ? Colors.white : kBgLightColor,
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
              bottomShadowColor: Color(0xFF234395).withOpacity(0.15),
            ),
          ],
        ),
      ),
    );
  }
}
