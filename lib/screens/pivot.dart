import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/components/animationOpacity.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/eventDetails.dart';
import 'package:standapp/models/user.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:device_info/device_info.dart';

///The screen widget's functionality is to decide which screen to show to the user when the app is opened.
///landingScreen or DashBoard with appropriate settings.

class Pivot extends StatefulWidget {
  @override
  PivotState createState() {
    return new PivotState();
  }
}

class PivotState extends State<Pivot> {
  Widget logo = new SvgPicture.asset(
    'assets/logo_sign.svg',
  );

  Widget logoLabel = new SvgPicture.asset(
    'assets/logo_label.svg',
  );
  @override
  initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (prefs == null) {
        prefs = await SharedPreferences.getInstance();
      }
      new Timer(Duration(milliseconds: 1502), () async {
        if (prefs.getBool("guest") ?? true) {
          print("guest user");
          await scanModel.restoreList("guest");
          Navigator.of(context).pushReplacementNamed("/landingScreen");
        } else {
          print("registered user");

          String userString = prefs.getString("user");
          User user = User.fromJson(json.decode(userString));
          String apiTokenWithLicenceString =
              prefs.getString("apiTokenWithLicence");
          ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();
          String eventForValidKey = prefs.getString("eventForValidKey");
          if (apiTokenWithLicenceString != null && eventForValidKey != null) {
            apiTokenWithLicence = ApiTokenWithLicence.fromJson(
                json.decode(apiTokenWithLicenceString));
            keyRegModel.eventForValidKey =
                Event.fromJson(json.decode(eventForValidKey));
            await scanModel.restoreList(apiTokenWithLicence.newToken);
          }
          keyRegModel.user = user;
          Navigator.of(context).pushReplacementNamed("/dashboard");
        }
      });
    });

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ScreenRatio.setScreenRatio(
        currentScreenHeight: MediaQuery.of(context).size.height,
        currentScreenWidth: MediaQuery.of(context).size.width);
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColors,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            AnimationOpacity(
              durationInMM: 1500,
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
              height: 48 * ScreenRatio.heightRatio,
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
      ),
    );
  }
}
