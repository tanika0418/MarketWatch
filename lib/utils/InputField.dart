import 'package:flutter/material.dart';
import 'package:market_watch/utils/Extensions.dart';

import 'Constants.dart';

Widget buildInputField({
  required TextEditingController controller,
  required String name,
  required IconData icon,
  required double width,
  bool isObs = false,
  bool hideIcon = false,
}) {
  bool _obscure = isObs;
  return Container(
    decoration: BoxDecoration(
      color: kBgLightColor,
      borderRadius: BorderRadius.circular(15),
    ),
    padding: isObs
        ? EdgeInsets.only(left: kDefaultPadding / 2)
        : EdgeInsets.symmetric(horizontal: kDefaultPadding / 2),
    width: width,
    child: StatefulBuilder(
      builder: (context, setState) => TextField(
        maxLines: 1,
        obscureText: isObs ? _obscure : false,
        controller: controller,
        cursorColor: kPrimaryColor,
        style: TextStyle(color: kTextColor),
        decoration: InputDecoration(
          hintText: name,
          hintStyle: TextStyle(color: kTextColor),
          icon: hideIcon
              ? null
              : Icon(
                  icon,
                  color: kTextColor,
                ),
          border: InputBorder.none,
          suffixIcon: isObs
              ? IconButton(
                  hoverColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  icon: Icon(
                    _obscure ? Icons.visibility : Icons.visibility_off,
                    color: kTextColor,
                  ),
                  onPressed: () {
                    setState(() {
                      _obscure = !_obscure;
                    });
                  },
                )
              : null,
        ),
      ),
    ),
  ).addNeumorphism(
    blurRadius: 15,
    borderRadius: 15,
    offset: Offset(4, 4),
    topShadowColor: Colors.white60,
    bottomShadowColor: Colors.black.withOpacity(0.15),
  );
}
