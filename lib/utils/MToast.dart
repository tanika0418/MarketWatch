import 'package:flutter/material.dart';
import 'package:market_watch/utils/Constants.dart';
import 'package:market_watch/utils/Extensions.dart';

import 'Responsive.dart';

class MWToast extends StatelessWidget {
  final String message;
  final String? image;
  final AlignmentGeometry? alignment;
  final double width;
  final bool isError;

  MWToast({
    Key? key,
    required this.message,
    this.image,
    required this.alignment,
    this.width = double.infinity,
    required this.isError,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Dialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(10))),
        alignment: alignment,
        child: Container(
          decoration: BoxDecoration(
            color: isError ? Color(0xFFFDEDEE) : Color(0xFFEAF7EE),
            borderRadius: BorderRadius.circular(10),
          ),
          width: width,
          child: Row(
            children: [
              Container(
                margin: EdgeInsets.all(kDefaultPadding / 2),
                child: Icon(
                  isError ? Icons.error : Icons.check_circle,
                  color: isError ? Color(0xFFF14E63) : Color(0xFF3BB55D),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: kDefaultPadding / 2,
                    right: kDefaultPadding / 2,
                    bottom: kDefaultPadding / 2,
                  ),
                  child: Text(
                    message,
                    style: TextStyle(fontStyle: FontStyle.normal),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 6,
                  ),
                ),
              ),
            ],
          ),
        ).addNeumorphism(
          blurRadius: 15,
          borderRadius: 15,
          offset: Offset(4, 4),
          topShadowColor: Colors.white60,
          bottomShadowColor: isError
              ? Colors.red.withOpacity(0.10)
              : Colors.green.withOpacity(0.10),
        ),
      ),
    );
  }
}

showMWToast(
  BuildContext context, {
  required final String message,
  required final isError,
}) {
  return showDialog(
    barrierDismissible: false,
    barrierColor: Colors.white.withOpacity(0),
    context: context,
    builder: (_) {
      Future.delayed(Duration(milliseconds: isError ? 2000 : 1000), () {
        Navigator.of(context).pop();
      });
      return MWToast(
        message: message,
        alignment: Responsive.isMobile(context)
            ? Alignment.topCenter
            : Alignment.topRight,
        width: Responsive.isMobile(context) ? double.infinity : 120,
        isError: isError,
      );
    },
  );
}
