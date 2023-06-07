import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const kPrimaryColor = Color(0xFF366CF6);
const kNewsColor = Color(0xFF4D5875);
const kSecondaryColor = Color(0xFFF5F6FC);
const kBgLightColor = Color(0xFFF2F4FC);
const kBgDarkColor = Color(0xFFEBEDFA);
const kBadgeColor = Color(0xFFEE376E);
const kGrayColor = Color(0xFF8793B2);
const kTitleTextColor = Color(0xFF30384D);
const kTextColor = Color(0xFF4D5875);

const kDefaultPadding = 20.0;

const ExceptionString = "Exception: ";
const SYSTEM_ERROR = "SYSTEM_ERROR";

enum Menu { HOME, TRANS, RES }

String convertToMoneyFormat(int? amount) {
  if (amount == null) {
    return "";
  }
  var formatter = NumberFormat('#,##,000');
  if (amount > 999) {
    return formatter.format(amount);
  }
  return amount.toString();
}

// Chart Constants
final List<Color> colorsGreen = <Color>[
  Colors.green.shade50,
  Colors.green.shade200,
  Colors.green
];

final List<Color> color = <Color>[
  Colors.red.shade50,
  Colors.red.shade200,
  Colors.red
];

final List<double> stops = <double>[0.0, 0.5, 1.0];

final LinearGradient gradientGreen = LinearGradient(
  colors: colorsGreen,
  stops: stops,
  transform: GradientRotation(-90 * (3.14 / 180)),
);

final LinearGradient gradientRed = LinearGradient(
  colors: color,
  stops: stops,
  transform: GradientRotation(-90 * (3.14 / 180)),
);
