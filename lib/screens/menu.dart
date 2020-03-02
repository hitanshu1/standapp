import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:standapp/components/animationOpacity.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/menuCard.dart';
import 'package:standapp/components/slideAnimation.dart';
import 'package:standapp/data/scoped_model_filter.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/data/scoped_model_statistics.dart';
import 'package:standapp/data/scoped_model_support.dart';
import 'package:standapp/data/scoped_model_upload.dart';
import 'package:standapp/main.dart';

import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/animation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class MenuState extends StatefulWidget {
  @override
  MenuStateState createState() {
    return new MenuStateState();
  }
}

class MenuStateState extends State<MenuState> {
  Animation<double> animation;

  bool statButtonInActive = false;
//  AnimationController controller;

  @override
  initState() {

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColors,
      body: OrientationBuilder(builder: (context, orientation) {
        return ScopedModel<KeyRegModel>(
          model: keyRegModel,
          child: SingleChildScrollView(
              child: Container(
                  margin: orientation == Orientation.portrait
                      ? EdgeInsets.fromLTRB(32, 88, 32, 32)
                      : EdgeInsets.fromLTRB(0, 50, 32, 32),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        ScopedModelDescendant<KeyRegModel>(
                          builder: (context, child, model) {
                            String firstName = "";
                            String lastName = "";
                            try {
                              List<String> splitNames = model.user.ownersName
                                  .split(" ");
                              print("splitNames.length=> ${splitNames.length}");
                              firstName = splitNames.length >= 2
                                  ? splitNames[0]
                                  : "FirstName";
                              lastName = splitNames.length >= 2
                                  ? splitNames[1]
                                  : "LastName";
                            }catch(e){
                              print("Error with name entered during registration");
                            }
                            return Container(
//                              margin: EdgeInsets.only(left: 32),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  FittedBox(
                                    child: Container(
                                      width: orientation == Orientation.portrait
                                          ? 250 * ScreenRatio.widthRatio
                                          : 400 * ScreenRatio.heightRatio,
                                      child: Text(
//                                        "${firstName} ${lastName}",
                                        "${model.user.ownersName.isNotEmpty ? firstName : "Name"} ${model.user.ownersName.isNotEmpty ? lastName : "N"}",
                                        style: TextStyles.textStyle32Primary,
                                      ),
                                    ),
                                  ),
                                  FittedBox(
                                    child: Container(
                                      margin: EdgeInsets.only(bottom: 32),
                                      width: orientation == Orientation.portrait
                                          ? 300* ScreenRatio.widthRatio
                                          : 400 * ScreenRatio.heightRatio,
                                      child: Text(
                                        model.user.deviceId.isEmpty
                                            ? "EmailId"
                                            : model.user.deviceId,
                                        style:
                                            orientation == Orientation.portrait
                                                ? TextStyles.textStyle14Black
                                                : TextStyles.textStyle22Black,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                        Container(
                          height: orientation == Orientation.portrait
                              ? 250 * ScreenRatio.heightRatio
                              : 140 * ScreenRatio.widthRatio,
                          child: Stack(
                            children: <Widget>[
                              AnimationOpacity(
                                durationInMM: 1000,

//                                controller: controller,
//                              left: animation.value,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    MenuCards(
                                      text: "Dashboard",
                                      assetName: ImageConstants.menuDash,
                                      orientation: orientation,
                                      onTap: () {
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    MenuCards(
                                      text: "Scans",
                                      assetName: ImageConstants.contacts,
                                      orientation: orientation,
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                                "/allContacts");
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    AbsorbPointer(
                                      absorbing: statButtonInActive,
                                      child: MenuCards(
                                        text: "Statistics",
                                        assetName: ImageConstants.menuStats,
                                        orientation: orientation,
                                        onTap: () async {
//                                         try {
//                                           _launchURL(url: new Uri.dataFromString('<html><body>hello world</body></html>', mimeType: 'text/html').toString());
//                                        }catch (e){
//                                          Scaffold.of(context).showSnackBar(SnackBar(
//                                              content: Text(e.runtimeType.toString() == 'SocketException'? "Connect to the Internet and try again.":e.toString())));
//                                        }
                                        setState(() {
                                          statButtonInActive = true;
                                        });

                                          if (prefs.getBool("guest") ||
                                              prefs.getBool("guest") == null) {

                                            setState(() {
                                              statButtonInActive = false;
                                            });

                                            Scaffold.of(context).showSnackBar(
                                                SnackBar(
                                                    content: Text("Information: You are required to activate your StandApp to view this page")));

                                          } else {
                                            await statisticsModel
                                                .fetchStatisticsWebPage();

                                            if (statisticsModel
                                                    .apiResponse.error ==
                                                null) {
                                              setState(() {
                                                statButtonInActive = false;
                                              });
                                              Navigator.of(context).push(
                                                MaterialPageRoute(
                                                    builder: (BuildContext
                                                            context) =>
                                                        new WebviewScaffold(
                                                            appBar: AppBar(
                                                              automaticallyImplyLeading: true,
                                                              title: Text("Statistics"),
                                                            ),
                                                            url: new Uri.dataFromString(
                                                                    statisticsModel
                                                                        .webPageData,
                                                                    mimeType:
                                                                        'text/html')
                                                                .toString())),
                                              );
                                            } else {
                                              setState(() {
                                                statButtonInActive = false;
                                              });
                                              Scaffold.of(context).showSnackBar(
                                                  SnackBar(
                                                      content: Text(
                                                          statisticsModel
                                                              .apiResponse
                                                              .error)));
                                            }
//                                        showErrorDialog();
//                                        scanModel.clear();
//                                        sortModel.clear();
                                          }
                                          // Navigator.of(context).pushReplacementNamed("/dashboard");
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 32,
                          ),
                          child: Text(
                            "INFORMATION",
                            style: orientation == Orientation.portrait
                                ? TextStyles.textStyle16Black
                                : TextStyles.textStyle22Black,
                          ),
                        ),
                        Container(
                          height: orientation == Orientation.portrait
                              ? 180 * ScreenRatio.heightRatio
                              : 100 * ScreenRatio.widthRatio,
                          child: Stack(
                            children: <Widget>[
                              AnimationOpacity(
                                durationInMM: 1000,

//                              left: animation.value,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10,
                                    ),
                                    MenuCards(
                                      text: "Activation key",
                                      assetName: ImageConstants.menuLicense,
                                      orientation: orientation,
                                      onTap: () {
                                        if (prefs.getBool("guest") ?? true) {
//                                          print("modal route => ${ModalRoute.withName(
//                                              "/landingScreen")}");
                                          Navigator.of(context)
                                              .pushNamedAndRemoveUntil(
                                              "/landingScreen", (
                                              route) => false);
                                        } else {
                                          Navigator.of(context)
                                              .pushReplacementNamed("/License");
                                        }
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    MenuCards(
                                      text: "Get Help",
                                      assetName: ImageConstants.help,
                                      orientation: orientation,
                                      onTap: () {
//                                        try {
////                                          _launchURL(
////                                              url: 'https://konduko.com/');
////                                        } catch (e) {
////                                          Scaffold.of(context).showSnackBar(
////                                              SnackBar(
////                                                  content: Text(e.runtimeType
////                                                              .toString() ==
////                                                          'SocketException'
////                                                      ? "Connect to the Internet and try again."
////                                                      : e.toString())));
////                                        }
                                        Navigator.pushNamed(
                                            context, "/GuestSupport");

//                                      Navigator.of(context)
//                                          .pushReplacementNamed(
//                                              "/addOfflineBadge");
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                            top: 32,
                          ),
                          child: Text(
                            "KONDUKO",
                            style: orientation == Orientation.portrait
                                ? TextStyles.textStyle16Black
                                : TextStyles.textStyle22Black,
                          ),
                        ),
                        Container(
                          height: orientation == Orientation.portrait
                              ? 180 * ScreenRatio.heightRatio
                              : 100 * ScreenRatio.widthRatio,
                          child: Stack(
                            children: <Widget>[
                              AnimationOpacity(
                                durationInMM: 1000,

//                              left: animation.value,
                                child: Column(
                                  children: <Widget>[
                                    SizedBox(
                                      height: 10 * ScreenRatio.heightRatio,
                                    ),
                                    MenuCards(
                                      text: "About",
                                      assetName: ImageConstants.menuAbout,
                                      orientation: orientation,
                                      onTap: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed("/About");
                                      },
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    MenuCards(
                                      text: "Terms & Conditions",
                                      assetName: ImageConstants.menuTerms,
                                      orientation: orientation,
                                      onTap: () {
                                        try {
                                          _launchURL(
                                              url:
                                                  'http://www.konduko.com/terms/');
                                        } catch (e) {
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(e.runtimeType
                                                              .toString() ==
                                                          'SocketException'
                                                      ? "Connect to the Internet and try again."
                                                      : e.toString())));
                                        }
//                                        Navigator.of(context)
//                                            .pushReplacementNamed(
//                                                "/TermsAndConditions");
                                      },
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 32, left: 32),
                          width: orientation == Orientation.portrait
                              ? MediaQuery.of(context).size.width *
                                  ScreenRatio.widthRatio
                              : MediaQuery.of(context).size.height *
                                  ScreenRatio.heightRatio,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "© 2019 Konduko SA",
                                style: orientation == Orientation.portrait
                                    ? TextStyles.textStyle14Black
                                    : TextStyles.textStyle22Black,
                              ),
                              Text(
                                "Version 3.0.0 (3087)",
                                style: orientation == Orientation.portrait
                                    ? TextStyles.textStyle14Black
                                    : TextStyles.textStyle22Black,
                              ),
                            ],
                          ),
                        )
                      ]))),
        );
      }),
      floatingActionButton: CircularButton(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.of(context).pop();
        },
        iconcolor: Colors.black,
        icon: ImageConstants.close,
      ),
    );
  }

  Future<void> showErrorDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(
            'Statistics for your event are currently unavailable. Please check again later.',
            softWrap: true,
            textAlign: TextAlign.center,
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

  Widget buildCards(
    text,
    assetNames,
    Orientation orientation,
  ) {
    return MenuCards(
      text: text,
      assetName: assetNames,
      orientation: orientation,
      onTap: () {},
    );
  }

//  Future<void> showHelpDialog() async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: true, // user must tap button!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.all(Radius.circular(10))),
//          title: Text(""),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('OK',
//                style: TextStyle(color: ColorConstants.primaryTextColor),),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }
  

  _launchURL({String url}) async {
//    const url = 'http://www.konduko.com/terms/';
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
