import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class TappableCards extends StatelessWidget {
  final String text;
  final double textSize;
  final Orientation orientation;

  final String assetName;
  final Function onTap;

  TappableCards(
      {this.text, this.textSize, this.orientation, this.assetName, this.onTap});

  @override
  Widget build(BuildContext context) {
    Widget icon = new SvgPicture.asset(
      assetName,
    );

    return InkWell(
      onTap: onTap,
      child: Container(
          //width: MediaQuery.of(context).size.width / 3 * ScreenRatio.widthRatio,
          margin: EdgeInsets.only(left: 5, right: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey[200],
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ]),
          height:
//          150,
              (MediaQuery.of(context).size.height / 5),
          child: Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 24 * ScreenRatio.heightRatio,
                  width: 24* ScreenRatio.widthRatio,
                  child: icon,
                ),
                Container(
                  height: 40 * ScreenRatio.heightRatio,
                  width: 102 * ScreenRatio.widthRatio,
                  child: Text(
                    text,
                    //maxLines: 2,
                    // softWrap: true,
                    style: TextStyles.textStyle16Card,
                  ),
                ),
              ],
            ),
          )),
    );
  }
}
