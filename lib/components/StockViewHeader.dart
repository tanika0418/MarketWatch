import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../utils/Constants.dart';
import '../utils/Responsive.dart';

class StockViewHeader extends StatelessWidget {
  const StockViewHeader({
    Key? key,
    required this.name,
    required this.imgURi,
    required this.person,
  }) : super(key: key);

  final String name;
  final String imgURi;
  final String person;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(kDefaultPadding),
      child: Row(
        children: [
          if (Responsive.isMobile(context)) BackButton(),
          if (Responsive.isMobile(context)) SizedBox(width: kDefaultPadding),
          Row(
            children: [
              WebsafeSvg.asset(imgURi, width: 32),
              SizedBox(width: kDefaultPadding),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  SizedBox(height: kDefaultPadding / 4),
                  Text.rich(
                    TextSpan(
                      text: person.split(":").first,
                      style: Theme.of(context).textTheme.labelLarge,
                      children: [
                        TextSpan(
                            text: "  (" + person.split(":").last + ")",
                            style: Theme.of(context).textTheme.bodySmall),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
