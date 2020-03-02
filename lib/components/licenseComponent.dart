import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/models/user.dart';

import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class LicenseComponent extends StatelessWidget {
  double height;
  double width;

  Orientation orientation;
User user;


double frameWidth ;
double contentWidth ;
  LicenseComponent({this.height, this.width, this.orientation,this.user}){
    frameWidth = width - 64;
    contentWidth = frameWidth *0.8;
  }

  @override
  Widget build(BuildContext context) {

    print("user => ${user}");
    return Container(
        margin: EdgeInsets.only(top: 32),
        child: Stack(
          alignment: Alignment.center,
            children: <Widget>[
          Center(
            child: Container(
                width: frameWidth,
                height: height,
                child: SvgPicture.asset(
                  ImageConstants.license,
                  fit: BoxFit.fill,
                )),
          ),
          Positioned(
//            top: 12,
//            left: orientation == Orientation.portrait
//                ? 44
//                : 200 * ScreenRatio.heightRatio,
//            right: orientation == Orientation.portrait
//                ? 44
//                : 200 * ScreenRatio.heightRatio,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
//                  margin: EdgeInsets.only(top: 32, bottom: 5),
                  width: 80 * ScreenRatio.widthRatio,
                  height: 80 * ScreenRatio.heightRatio,
                  child: SvgPicture.asset(
                    ImageConstants.menuLicense,
                    fit: BoxFit.contain,
                  ),
                ),
                FittedBox(
                  child: Container(
                    //color: Colors.blueGrey,
                    //  height: 100,
                    // height: 77 * ScreenRatio.heightRatio,
                    width: orientation == Orientation.portrait
                        ? 250 * ScreenRatio.widthRatio
                        : 200 * ScreenRatio.widthRatio,
                    child: Text(
                      user.ownersName,
                      style: TextStyles.textStyle32Primary,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 6, bottom: 14),
                  width: contentWidth,
                  child: Text(
                    user.deviceId,
                    style: TextStyles.textStyle14Bold,
                    textAlign: TextAlign.center,
                  ),
                ),
                Center(
                  child: Container(
                    width: contentWidth,

                    // margin: orientation == Orientation.portrait
                    //     ? EdgeInsets.fromLTRB(30, 0, 30, 10)
                    //     : EdgeInsets.fromLTRB(130 * ScreenRatio.heightRatio, 0,
                    //         130 * ScreenRatio.heightRatio, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        Container(
//                          margin: EdgeInsets.only(left: 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "LICENSE KEY:",
                                style: TextStyles.textStyle14Bold,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 6.0),
                                child: Text(
                                  user.licenceKey,
                                  style: TextStyles.textStyle14PrimaryBold,
                                ),
                              ),
                              Text(
                                user.companyName,
                                style: TextStyles.textStyle14BoldBlack,
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
//                          margin: EdgeInsets.only(right: 16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Text(
                                  "REDEEMED:",
                                  style: TextStyles.textStyle14Bold,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(top: 6.0),
                                  child: Text(
                                    "${dateIntToStringMonth(DateTime.parse(user.registrationDate).month).substring(0,3)} ${DateTime.parse(user.registrationDate).day}, ${DateTime.parse(user.registrationDate).year} ",
                                    style: TextStyles.textStyle14PrimaryBold,
                                  ),
                                ),
                                Text(
                                  "${DateTime.parse(user.registrationDate).hour}:${DateTime.parse(user.registrationDate).minute}",
                                  style: TextStyles.textStyle14BoldBlack,
                                )
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 6),
                  width: contentWidth,
                  child: Text(
                    "${user.eventName.toUpperCase()} IN ${user.venueName.toUpperCase()}",
                    style: TextStyles.textStyle12Black,
                    textAlign: TextAlign.center,
                    maxLines: 3,
                  ),
                )
              ],
            ),
          )
        ]));
  }
}
// Container(
//   margin: EdgeInsets.all(23),
//   decoration: BoxDecoration(
//       color: ColorConstants.licenseBackground,
//       border: Border.all(
//         color: ColorConstants.border,
//         width: 2,
//       )),
//   child: CustomPaint(
//     foregroundPainter: Painter(),
//     child: Column(

//         ),
//
//     ),
//   ),
// ),
