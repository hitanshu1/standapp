import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class OfflineBadge extends StatelessWidget {
  double height;
  double width;
  String barcode;

  Orientation orientation;

  OfflineBadge({this.height, this.width, this.orientation,this.barcode});

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
//      width: width / 2,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.asset(
            ImageConstants.badge,
            width: width,
            height: height,
          ),
          Positioned(
            top: 148 * ScreenRatio.heightRatio,
            left: width * 0.2,
            child: RotationTransition(
              turns: AlwaysStoppedAnimation(-30 / 360),
              child: Container(
                child: SvgPicture.asset(
                  ImageConstants.stamp,
                  height: 75 * ScreenRatio.heightRatio,
                  width: 75 * ScreenRatio.widthRatio,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          Positioned(
            top: 160 * ScreenRatio.heightRatio,
//            left: 35 * ScreenRatio.heightRatio,
            child: Container(
//              alignment: Alignment.topRight,
              //color: Colors.blueGrey,
              padding: EdgeInsets.only(top:20),
              width: width*0.7,
//                height: 275* ScreenRatio.heightRatio,
              child: Column(
                children: <Widget>[
                  Container(
                    width: 54 * ScreenRatio.widthRatio,
                    height: 48 * ScreenRatio.heightRatio,
                    child: SvgPicture.asset(
                      ImageConstants.alertOutLine,
                      fit: BoxFit.contain,
                      color: ColorConstants.primaryTextColor,
                    ),
                  ),
                  SizedBox(
                    height: 10  * ScreenRatio.heightRatio,
                  ),
                  Container(
//                      width: 250 * ScreenRatio.widthRatio,
                    child: Text(
                      "Currently Not Recognised",
                      style: TextStyle(
                        fontSize: 28 * ScreenRatio.heightRatio,
                        fontWeight: FontWeight.w800,
                        color: ColorConstants.primaryTextColor,
                        fontFamily: 'Poppins',
                        height: 0.8
                      ),
                      textAlign: TextAlign.center,
                      softWrap: true,
//                      maxLines: 2,
                    ),
                  ),
                  FittedBox(
                    child: Container(
                      width: 175 * ScreenRatio.widthRatio,
                      child: Text(
                        "Record will be updated when data is received. Optionally enter details below.",
                        style: TextStyles.textStyle14Black,
                        textAlign: TextAlign.center,
                        softWrap: true,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20  * ScreenRatio.heightRatio,
                  ),
                  Text(
                    barcode,
                    style: TextStyles.textStyle12Black,

                    textAlign: TextAlign.center,

                  )
                ],
              ),
            ),
          ),
          Positioned(
            top: 535 * ScreenRatio.heightRatio,
            left: 40 * ScreenRatio.heightRatio,
            child: Container(
              height: 85 * ScreenRatio.heightRatio,
              width: 300 * ScreenRatio.heightRatio,
              child: Center(
                child: Text(
                  "ATTENDEE",
                  style: TextStyles.textStyle24White,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
