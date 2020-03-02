import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';

class CircularButton extends StatelessWidget {
  final String icon;
  final Color iconcolor;
  final Color backgroundColor;
  final Function onPressed;
  final String heroTag;
   bool dotNeeded = false;

  CircularButton(
      {this.icon,
      this.onPressed,
      this.backgroundColor,
      this.iconcolor,
      this.heroTag,this.dotNeeded});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60 * ScreenRatio.heightRatio ,
      width: 60 * ScreenRatio.widthRatio  ,
      child: FloatingActionButton(
        heroTag: heroTag ?? "0",
        onPressed: onPressed,
        child: Stack(
          children: <Widget>[
            Container(
              width: 30 * ScreenRatio.widthRatio,
              height: 30 * ScreenRatio.heightRatio,
              child: SvgPicture.asset(
                icon,
                color: iconcolor,
                fit: BoxFit.contain,
              ),
            ),
            Positioned(
              left: 15 * ScreenRatio.widthRatio,
              top: 0,
              child: dotNeeded??false ? Container(
                width: 12 * ScreenRatio.widthRatio,
                height: 12 * ScreenRatio.heightRatio,
                decoration: BoxDecoration(
                    color: ColorConstants.primaryTextColor,
                  shape: BoxShape.circle,
                ),
              ):Container(width: 0,height: 0,),
            ),
          ],
        ),
        backgroundColor: backgroundColor,
      ),
    );
  }
}
