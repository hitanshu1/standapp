import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:standapp/main.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/textStyles.dart';


///Information widget screen that let's the user know what can be done in the app if they chose to move forward with their selection

class GuestMode extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColors,
      body: OrientationBuilder(builder: (context, orientation) {
        return Stack(
          children: <Widget>[
            Column(
              children: <Widget>[
                Container(
                  height: MediaQuery.of(context).size.height / 2,
                  width: MediaQuery.of(context).size.width,
                  color: ColorConstants.primaryTextColor,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: orientation == Orientation.portrait
                            ? MediaQuery.of(context).size.height / 8
                            : 10,
                      ),
                      Container(
                        width: 54,
                        height: 48,
                        child: SvgPicture.asset(
                          ImageConstants.alertSolid,
                          fit: BoxFit.contain,
                        ),
                      ),
                      SizedBox(
                        height: orientation == Orientation.portrait ? 30 : 6,
                      ),
                      Container(
                        width: 311,
                        height: 45,
                        child: Center(
                          child: Text(
                            "Please Note",
                            style: TextStyles.textStyle32,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: orientation == Orientation.portrait ? 15 : 4,
                      ),
                    ],
                  ),
                ),
                FittedBox(
                  child: Container(
                    margin: orientation == Orientation.portrait
                        ? EdgeInsets.fromLTRB(32, 25, 32, 12)
                        : EdgeInsets.fromLTRB(100, 25, 100, 0),
                    width: MediaQuery.of(context).size.width,
                    // height: orientation == Orientation.portrait
                    //     ? 160 * ScreenRatio.heightRatio
                    //     : 50,
                    child: Column(
                      children: <Widget>[
                        Text(
                            "You have chosen to use the StandApp without activating your app.",
                            style: TextStyles.textStyle18),
                        SizedBox(
                          height: 6,
                        ),
                        Text(
                            "You can continue to scan and store barcodes, however, the attendee’s personal data will not automatically synchronize until you enter a valid activation key.",
                            style: TextStyles.textStyle18),
                      ],
                    ),
                  ),
                ),
                FittedBox(
                  child: Container(
                      width: MediaQuery.of(context).size.width,
                      //height: 60,

                      margin: orientation == Orientation.portrait
                          ? EdgeInsets.only(
                              left: 32,
                              right: 32,
                            )
                          : EdgeInsets.only(
                              left: 100,
                              right: 100,
                            ),
                      child: Text(
                          "You can enter an activation key at any time.",
                          style: TextStyles.textStyle14Black)),
                ),
              ],
            ),
            Padding(
              padding: orientation == Orientation.portrait
                  ? EdgeInsets.only(
                      left: 32.0,
                      right: 32,
                      top: MediaQuery.of(context).size.height - 70)
                  : EdgeInsets.only(
                      left: 32.0,
                      right: 32,
                      top: MediaQuery.of(context).size.height - 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircularButton(
                    backgroundColor: Colors.white,
                    icon: ImageConstants.back,
                    iconcolor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  RoundedButton(
                    shadow: false,
                    width: 137,
                    label: "CONTINUE",
                    textColor: Colors.white,
                    backgroundColor: ColorConstants.primaryTextColor,
                    onPressed: () async {
                      if (prefs == null) {
                        prefs = await SharedPreferences.getInstance();
                      }
                      prefs.setBool("guest", true);

                      Navigator.of(context).pushNamedAndRemoveUntil(
                          "/dashboard", (Route<dynamic> route) => false);
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

}
