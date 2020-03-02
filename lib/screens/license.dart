import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/licenseComponent.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:standapp/data/scoped_model_filter.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/data/scoped_model_statistics.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/user.dart';
import 'package:standapp/services/intermediateService.dart';
import 'package:standapp/services/uploadScans.dart';

import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

double height;
double width;

class License extends StatefulWidget {
  @override
  LicenseState createState() {
    return new LicenseState();
  }
}

class LicenseState extends State<License> {

  User user = User();

  bool buttonDisabled = false;



  @override
  void initState() {
    // TODO: implement initState

    if(prefs!=null){
      user = User.fromJson(json.decode(prefs.getString("user")));
    }

    super.initState();
  }
  @override
  Widget build(BuildContext context) {
//    ScreenRatio.setScreenRatio(
//        currentScreenHeight: MediaQuery.of(context).size.height,
//        currentScreenWidth: MediaQuery.of(context).size.width);

    return Scaffold(
      backgroundColor: ColorConstants.backgroundColors,
      body: OrientationBuilder(builder: (context, orientation) {
        height = orientation == Orientation.portrait
            ? MediaQuery.of(context).size.height / 1.1
            : MediaQuery.of(context).size.width / 1.5;
        width = MediaQuery.of(context).size.width;
        return SafeArea(
          child:
              Column(
                children: <Widget>[
                  Flexible(
                    child: Container(
                      //margin: EdgeInsets.only(top: 32),
//                    height: height * ScreenRatio.heightRatio,
                      width: width * ScreenRatio.widthRatio,
                      child: LicenseComponent(
                          height: height, width: width, orientation: orientation,user:user),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        32, 12, 32, 5 ),
                    child: Text(
                      "To remove this licence from the app please use the button below. You must be online to use this function.",
                      style: TextStyles.textStyle14Bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.fromLTRB(32, 2, 32, 12),
                    child: Text(
                      "You’ll be exited to the home screen and your leads will no longer be accesible.",
                      style: TextStyles.textStyle14Bold,
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        CircularButton(
                          heroTag: "4",
                          icon: ImageConstants.menu,
                          backgroundColor: Colors.white,
                          iconcolor: Colors.black,
                          onPressed: () {
                            Navigator.of(context).pushReplacementNamed("/menu");
                          },
                        ),
                        RoundedButton(
                          buttonDisabled:
                         buttonDisabled,
                          width: 185 * ScreenRatio.widthRatio,
                          label: "REVOKE LICENSE",
                          textColor:
                          ColorConstants.primaryTextColor,
                          backgroundColor: buttonDisabled
                              ? ColorConstants.primaryTextColor
                              : Colors.white,
                          onPressed: () async{
                          await showConfirmationDialog(context);

                          },
                          shadow: true,
                        ),
                      ],
                    ),
                  ),

                ],
              ),
//              Padding(
//                padding: orientation == Orientation.portrait
//                    ? EdgeInsets.only(
//                        left: 32.0,
//                        right: 32,
//                        top: MediaQuery.of(context).size.height - 80)
//                    : EdgeInsets.only(
//                        left: 32.0,
//                        right: 32,
//                        top: MediaQuery.of(context).size.height - 80),
//                child: Row(
//                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                  children: <Widget>[
//
//                  ],
//                ),
//              ),

        );
      }),
    );
  }
  Future<void> showConfirmationDialog(parentContext) async {
    return showDialog<void>(
      context: parentContext,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(
            'Are you sure you want to revoke the licence?',
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[

            FlatButton(
              child: Text(
                'YES',
                style: TextStyle(color: ColorConstants.primaryTextColor),
              ),
              onPressed: () async{
                setState(() {
                  buttonDisabled =
                  true;
                });
                Navigator.of(context).pop();
                await revokeLicence(parentContext);
                setState(() {
                  buttonDisabled =
                  false;
                });

              },
            ),
            FlatButton(
              child: Text(
                'NO',
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

  revokeLicence(context)async{
    print("revoked");

    await keyRegModel.revokeLicence(user);

    if(keyRegModel.apiResponse.error == null) {

      String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
      ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();
      if (apiTokenWithLicenceString != null) {
        apiTokenWithLicence =
            ApiTokenWithLicence.fromJson(json.decode(apiTokenWithLicenceString));
//                          print("apiTokenWithLicence.newToken while deleteing => ${apiTokenWithLicence.newToken}");
//                                scanModel.restoreList(apiTokenWithLicence.newToken);

        await Service.storageService(parameter: "scans", user: apiTokenWithLicence.newToken, action: "deleteAll");

//                          print("deleted success => ${success}");



      }
//                            print("prefs => ${prefs.toString()}");
      prefs.remove("eventForValidKey");
      prefs.remove("apiTokenWithLicence");
      prefs.remove("user");
      prefs.setBool("guest", true);
      prefs.remove("questions");
      scanModel.clear();
      sortModel.clear();
      keyRegModel.clear();
      statisticsModel.clear();
      UploadService.stopUpload();

//                           await Service.storageService(parameter: "scans", user: "guest", action: "read");


      Navigator.of(context).pushNamedAndRemoveUntil("/landingScreen",(Route<dynamic> route) => false);
    }else{
      setState(() {
        buttonDisabled =
        false;
      });

      Scaffold.of(context).showSnackBar(SnackBar(
          content: Text(keyRegModel.apiResponse.error)));
    }
  }

}

