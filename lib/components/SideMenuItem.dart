import 'package:flutter/material.dart';
import 'package:websafe_svg/websafe_svg.dart';

import '../utils/Constants.dart';
import 'CounterBadge.dart';

class SideMenuItem extends StatelessWidget {
  const SideMenuItem({
    Key? key,
    required this.isActive,
    this.isHover = false,
    this.itemCount = 0,
    this.showBorder = true,
    required this.iconSrc,
    required this.title,
    required this.press,
  }) : super(key: key);

  final bool isActive, isHover, showBorder;
  final int itemCount;
  final String iconSrc, title;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: kDefaultPadding),
      child: InkWell(
        onTap: press,
        child: Row(
          children: [
            SizedBox(width: kDefaultPadding / 4),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(bottom: 15, right: 5),
                decoration: showBorder
                    ? BoxDecoration(
                        border: Border(
                          bottom: BorderSide(color: Color(0xFFDFE2EF)),
                        ),
                      )
                    : null,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    WebsafeSvg.asset(
                      iconSrc,
                      colorFilter: ColorFilter.mode(
                        (isActive || isHover) ? kPrimaryColor : kTextColor,
                        BlendMode.srcIn,
                      ),
                      height: 20,
                    ),
                    SizedBox(width: kDefaultPadding * 0.75),
                    Text(
                      title,
                      style: Theme.of(context).textTheme.button?.copyWith(
                            color: (isActive || isHover)
                                ? kPrimaryColor
                                : kTextColor,
                          ),
                    ),
                    Spacer(),
                    if (itemCount != 0) CounterBadge(count: itemCount)
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
