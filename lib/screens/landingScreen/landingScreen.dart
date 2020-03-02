import 'dart:convert';

import 'package:crypto/crypto.dart';

// import 'package:file_service/file_cyper.dart';
// import 'package:file_service/file_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/components/animationOpacity.dart';
import 'package:standapp/components/circularButton.dart';

import 'package:standapp/components/tapableCards.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/screens/termsAndCondition.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/animation.dart';
import 'package:url_launcher/url_launcher.dart';

///Give the user a choice to either enter registration flow or use the app as a guest

class LandingScreen extends StatefulWidget {
  @override
  LandingScreenState createState() {
    return new LandingScreenState();
  }
}

class LandingScreenState extends State<LandingScreen> {
  Widget logo = new SvgPicture.asset(
    'assets/logo_sign.svg',
  );

  Widget logoLabel = new SvgPicture.asset(
    'assets/logo_label.svg',
  );

  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenRatio.setScreenRatio(
        currentScreenHeight: MediaQuery
            .of(context)
            .size
            .height,
        currentScreenWidth: MediaQuery
            .of(context)
            .size
            .width);
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColors,
      body: OrientationBuilder(builder: (context, orientation) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            orientation == Orientation.portrait
                ? SizedBox(
              height: 100 * ScreenRatio.heightRatio,
            )
                : Container(
              width: 0,
              height: 0,
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                AnimationOpacity(
                  child: Hero(
                    tag: "logo",
                    child: SizedBox(
                      width: 130 * ScreenRatio.widthRatio,
                      height: 130 * ScreenRatio.heightRatio,
                      child: logo,
                    ),
                  ),
                ),
                SizedBox(
                  height: 48,
                ),
                AnimationOpacity(
                  child: SizedBox(
                    width: 191 * ScreenRatio.widthRatio,
                    height: 32 * ScreenRatio.heightRatio,
                    child: logoLabel,
                  ),
                ),
              ],
            ),
            AnimationOpacity(
              child: Container(
                margin: orientation == Orientation.portrait
                    ? EdgeInsets.only(left: 20, right: 20)
                    : EdgeInsets.only(left: 20, right: 20),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: TappableCards(
                        text: "Event Key Activation",
                        textSize: 16 * ScreenRatio.widthRatio,
                        assetName: ImageConstants.menuLicense,
                        onTap: () async {
                          //To run on simulator
//                          scanModel.currentScan = Scan();
//                          Navigator.of(context).pushReplacementNamed("/addBadge");

                          Navigator.of(context).pushNamed("/keyActivation");
                        },
                      ),
                    ),
                    Expanded(
                      child: TappableCards(
                        onTap: () async {
                          if (prefs == null) {
                            prefs = await SharedPreferences.getInstance();
                          }
                          prefs.setBool("guest", true);

                          Navigator.of(context).pushNamed("/dashboard");
                        },
                        text: "Use Without License",
                        textSize: 16 * ScreenRatio.widthRatio,
                        assetName: ImageConstants.guest,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            AnimationOpacity(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "\u00a9 2019 Konduko SA",
                          style: TextStyles.textStyle14Black,
                        ),
                        GestureDetector(
                          onTap: () async {
                            try {
                              _launchURL('http://www.konduko.com/terms/');
                            } catch (e) {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text(e.runtimeType.toString() ==
                                      'SocketException'
                                      ? "Connect to the Internet and try again."
                                      : e.toString())));
                            }
                          },
                          child: Text(
                            "View Terms & Conditions",
                            style: TextStyles.textStyle13UnderLined,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 32.0),
                    child: CircularButton(
                      icon: ImageConstants.help,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        showHelpDialog();
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Future<void> showHelpDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Column(
            children: <Widget>[
              Text(
                'For assistance contact',
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {
                  try {
                    _launchURL('https://konduko.com/');
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            e.runtimeType.toString() == 'SocketException'
                                ? "Connect to the Internet and try again."
                                : e.toString())));
                  }
                },
                child: Text(
                  "support@konduko.com",
                  style: TextStyles.textStyle18UnderLined,
                ),
              ),
              Text(
                'or visitor the Konduko Exhibitor Services desk if at an event',
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: ColorConstants.primaryTextColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  _launchURL(Url) async {
    String url = Url;
    if (await canLaunch(url)) {
      await launch(
        url,
        forceWebView: true,
        forceSafariVC: true,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
