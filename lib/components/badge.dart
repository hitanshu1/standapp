import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/components/badge.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/customTextField.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class Badge extends StatelessWidget {
  double height;
  double width;
  bool online = false;

  Scan scan = Scan(
      barCode: "MEED - 46509",
      eEmbed: Embed(
          visitor: Visitor(
        fullName: "Billy Anderson",
        jobTitle: "Vice President",
        company: "Panasonic Corporation",
        email: "billy.a@email.com",
      )));

  Orientation orientation;

  Badge(
      {this.height,
      this.width,
      this.orientation,
      this.scan,
      this.online = false});

  @override
  Widget build(BuildContext context) {
    return Stack(alignment: Alignment.center, children: <Widget>[
      Image.asset(
        ImageConstants.badge,
        fit: BoxFit.cover,
      ),
      Positioned(
        top: 180 * ScreenRatio.heightRatio,
//          left: 30 * ScreenRatio.heightRatio,
        child: Container(
          width: width * 0.8,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: width * 0.8,
//                height: 340 * ScreenRatio.heightRatio,

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    RotationTransition(
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
                    online
                        ? Padding(
                            padding: const EdgeInsets.only(right: 8.0),
                            child: Text(
                              scan.barCode,
//                          scan.barCode,
                              style: TextStyles.textStyle12Black,
                            ),
                          )
                        : Container(
                            width: 0,
                            height: 0,
                          ),
                  ],
                ),
              ),
              online?_buildOnlineCardContent():_buildOfflineContent(),
            ],
          ),
        ),
      ),
    ]);
  }

  _buildOnlineCardContent() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(20),
//                  width: width * 0.8,
      height: 340 * ScreenRatio.heightRatio,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
//            color: Colors.red,
            height: 86 * ScreenRatio.heightRatio,
            width: orientation == Orientation.portrait
                ? 180 * ScreenRatio.widthRatio
                : 400 * ScreenRatio.heightRatio,
            child: Text(
//              "qwdfdf",
//                  "fdgfdgfdgfgggdfg",
              scan.eEmbed.visitor.fullName,
//              style: TextStyles.textStyle32Primary,
            style: TextStyle(

            fontSize: 32 * ScreenRatio.heightRatio,
              fontWeight: FontWeight.w800,
              color: ColorConstants.primaryTextColor,
              fontFamily: 'Poppins',
//                height: 0.8,
            ),
              maxLines: 2,
              softWrap: true,
            ),
          ),
          Container(
//            margin: EdgeInsets.only(top: 12*ScreenRatio.heightRatio,),
            width:100 * ScreenRatio.widthRatio,
            height: 50 * ScreenRatio.heightRatio,

//                      alignment: Alignment.centerLeft,
//                      width: MediaQuery.of(context).size.width / 2,
            child: Align(
              alignment: Alignment.centerLeft,

              child: FittedBox(
                child: Text(
                  scan.eEmbed.visitor.jobTitle??"",
                  style: TextStyle(
//                  fontSize: 14 * ScreenRatio.widthRatio,
                    color: ColorConstants.secondaryTextColor,
//                  fontWeight: FontWeight.w100,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),
          Container(
//            margin: EdgeInsets.only(left: 12*ScreenRatio.widthRatio),

            width:167 * ScreenRatio.widthRatio,
            height: 20 * ScreenRatio.heightRatio,
//                      width: MediaQuery.of(context).size.width / 2,
            child: Align(
              alignment: Alignment.centerLeft,

              child: FittedBox(
                child: Text(
                  scan.eEmbed.visitor.company,

                  style:TextStyle(
//                  fontSize: 14 * ScreenRatio.widthRatio,
                    color: ColorConstants.secondaryTextColor,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Poppins',
                  ),
                  maxLines: 1,
                ),
              ),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Container(
                height: 30 * ScreenRatio.heightRatio,
                width: 20 * ScreenRatio.widthRatio,
                child: SvgPicture.asset(
                  ImageConstants.infoEmail,
                  fit: BoxFit.contain,
                  color: ColorConstants.secondaryTextColor,
                ),
              ),
                SizedBox(
                  width: 10 * ScreenRatio.widthRatio,
                ),
              Container(
                width: 122 * ScreenRatio.widthRatio,
                height: 20 * ScreenRatio.heightRatio,
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: FittedBox(
                    child: Text(
                      scan.eEmbed.visitor.email,
                      style: TextStyle(
//                        fontSize: 14 * ScreenRatio.widthRatio,
                        color: ColorConstants.primaryTextColor,
                        decoration: TextDecoration.underline,

//                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 2,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            ],
          ),


          scan.eEmbed.visitor.phoneNumber!=null&&scan.eEmbed.visitor.phoneNumber.isNotEmpty?
              Row(
                mainAxisAlignment: MainAxisAlignment.start,

                children: <Widget>[
                  Container(
                    height: 30 * ScreenRatio.heightRatio,
                    width: 20 * ScreenRatio.widthRatio,
                    child: SvgPicture.asset(
                      ImageConstants.infoPhone,
                      fit: BoxFit.contain,
                      color: ColorConstants.secondaryTextColor,
                    ),
                  ),

                  SizedBox(
                    width: 10 * ScreenRatio.widthRatio,
                  ),
                  Container(
                    width:132  * ScreenRatio.widthRatio,
                    height: 20 * ScreenRatio.heightRatio,
                    child: Align(
                      alignment: Alignment.centerLeft,

                      child: FittedBox(
                        child: Text(
                          "+1 ${scan.eEmbed.visitor.phoneNumber}",
                          style: TextStyle(
//                        fontSize: 14 * ScreenRatio.widthRatio,
                            color: ColorConstants.primaryTextColor,
                            decoration: TextDecoration.underline,

//                        fontWeight: FontWeight.bold,
                            fontFamily: 'Poppins',
                          ),
                          maxLines: 1,
                        ),
                      ),
                    ),
                  ),
                ],
              ):Container(width: 0,height: 0,),



          Expanded(
            child: Align(
              alignment: AlignmentDirectional.center,
              child: Container(
              margin: EdgeInsets.only(top: 20*ScreenRatio.heightRatio),
                width:215 * ScreenRatio.widthRatio,
                height: 33 * ScreenRatio.heightRatio,
                child: FittedBox(
                  child: Text(
                    "Attendee",
                    style: TextStyles.textStyle24White,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _buildOfflineContent(){
    return  Container(
      alignment: Alignment.center,
      padding: EdgeInsets.all(15),
//                  width: width * 0.8,
      height: 340 * ScreenRatio.heightRatio,
      child: Column(

        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Container(
              width: 64 * ScreenRatio.widthRatio,
              height: 58 * ScreenRatio.heightRatio,
              child: SvgPicture.asset(
                ImageConstants.alertOutLine,
                fit: BoxFit.contain,
                color: ColorConstants.primaryTextColor,
              ),
            ),
          ),
//          SizedBox(
//            height: 10  * ScreenRatio.heightRatio,
//          ),
          Center(
            child: Container(
              height: 65 * ScreenRatio.heightRatio,
              width: orientation == Orientation.portrait
                  ? 215 * ScreenRatio.widthRatio
                  : 400 * ScreenRatio.heightRatio,
              child: FittedBox(
                child: Text(
                  "Currently Not Recognised",
                  style: TextStyle(
//                  fontSize: 32 * ScreenRatio.widthRatio,
                    fontWeight: FontWeight.w800,
                    color: ColorConstants.primaryTextColor,
                    fontFamily: 'Poppins',
                    height: 0.8,
                  ),
                ),
              ),
            ),
          ),
          Container(
//            width:215 * ScreenRatio.widthRatio,
//            height: 30 * ScreenRatio.heightRatio,
//            width: 175 * ScreenRatio.widthRatio,
            child: Text(
              "Record will be updated when data is received. Optionally enter details below.",
              style: TextStyle(
                fontSize: 14 * ScreenRatio.widthRatio,
                color: ColorConstants.secondaryTextColor,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top:12.0),
            child: Center(
//            width:215 * ScreenRatio.widthRatio,
//            height: 17 * ScreenRatio.heightRatio,
              child: FittedBox(
                child: Text(
                  scan.barCode,
                  style: TextStyle(
                  fontSize: 12 * ScreenRatio.widthRatio,
                    color: ColorConstants.secondaryTextColor,
                    fontFamily: 'Poppins',
                  ),
                ),
              ),
            ),
          ),

        ],
      ),
    );
  }
}
