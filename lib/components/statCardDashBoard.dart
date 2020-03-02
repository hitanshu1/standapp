



import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';

Widget statCard(String icons, String number, String title) {
  return Container(
    child: Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
            width: 80* ScreenRatio.widthRatio,
            height: 24* ScreenRatio.heightRatio,
            child: SvgPicture.asset(
              icons,
              alignment: Alignment.centerLeft,
              fit: BoxFit.fitHeight,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
          Text(
            number,
            style: TextStyle(
                fontSize: 40* ScreenRatio.heightRatio,
                fontWeight: FontWeight.bold,
                color: ColorConstants.primaryTextColor),
          ),
          Text(
            title,
            style: TextStyle(
              fontSize: 12* ScreenRatio.heightRatio,
              fontWeight: FontWeight.bold,
              color: ColorConstants.secondaryTextColor,
            ),
          ),
        ],
      ),
    ),
  );
}