import 'package:flutter/material.dart';

import '../utils/Constants.dart';
import '../utils/Responsive.dart';

class ResultHeader extends StatelessWidget {
  const ResultHeader({Key? key}) : super(key: key);

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
              Text("Result"),
            ],
          ),
        ],
      ),
    );
  }
}
