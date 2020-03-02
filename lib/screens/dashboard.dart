import 'dart:convert';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:standapp/components/animationOpacity.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/contactCard.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:flutter/scheduler.dart';
import 'package:standapp/components/statCardDashBoard.dart';
import 'package:standapp/data/scoped_model_camera_initialise.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/data/scoped_model_questions.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/data/scoped_model_statistics.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/dynamicQuestions.dart';
import 'package:standapp/screens/allContacts.dart';
import 'package:standapp/screens/guestModeOfflineAddBadge.dart';
import 'package:standapp/screens/barcodeSacnner/barcodeCamera.dart';
import 'package:standapp/services/uploadScans.dart';
import 'package:standapp/main.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

///Dashboard widget screen is the base of the app that shows some stats, information and a list of cards that the user scans using the barcode scanner
///A floating action button allows the user to navigate to the barcode scanner camera and initiates the scan flow.
///This screen is also responsible for starting the upload service that will upload a scan when internet is available.

//Todo: clean up code to reduce number of lines
class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}
//CameraController controller;

class _DashboardState extends State<Dashboard>
    with SingleTickerProviderStateMixin {
  Widget logo = new SvgPicture.asset(
    'assets/logo_sign.svg',
  );
  ScrollController _scrollController = new ScrollController();
  bool scrolling = false;
  bool onlineStatus = true;
  final String logoImage = 'assets/Images/logo_sign.svg';

  bool guestMode = false;
  @override
  void initState() {
    super.initState();
//    buildContactCardsForName();

    guestMode = prefs.getBool("guest");

    print(guestMode);
//    initializeCamera().then((camController){
//      controller = camController;
//    });

    initialiseCameraModel.initializeCamera(context);

    WidgetsBinding.instance.addPostFrameCallback((_) async {
//      if (statisticsModel.apiResponse.error != null) {
//        showErrorDialog();
//      }

      if (!prefs.getBool("guest")) {
//        await statisticsModel.fetchStats();

        if (prefs.getString("questions") == null ||
            prefs.getString("questions").isEmpty) {
//          await questionsModel.fetchQuestions();

          if (questionsModel.apiResponseForScanDetails.error == null) {
            if (scanModel.contactList.isEmpty) {
              String apiTokenWithLicenceString =
                  prefs.getString("apiTokenWithLicence");
              ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();
              String eventForValidKey = prefs.getString("eventForValidKey");
              if (apiTokenWithLicenceString != null &&
                  eventForValidKey != null) {
                apiTokenWithLicence = ApiTokenWithLicence.fromJson(
                    json.decode(apiTokenWithLicenceString));

                await scanModel.restoreList(apiTokenWithLicence.newToken);
              }
            }
          } else {
            Scaffold.of(context).showSnackBar(
                SnackBar(content: Text(keyRegModel.apiResponse.error)));
          }
        } else {
          questionsModel.dynamicQuestions = DynamicQuestions.fromJson(
              json.decode(prefs.getString("questions")));
        }

        //TODO: scans to upload must be updated in real time

        UploadService(scansFromModel: scanModel.contactList);

        UploadService.init();
      }
    });
  }

  @override
  dispose() {
    UploadService.stopUpload();
    super.dispose();
  }

  checkCameraPermission() {}

  @override
  Widget build(BuildContext context) {
    if (prefs.getBool("guest") || prefs.getBool("guest") == null) {
      ScreenRatio.setScreenRatio(
          currentScreenHeight: MediaQuery.of(context).size.height,
          currentScreenWidth: MediaQuery.of(context).size.width);
    }
//    WidgetsBinding.instance.addPostFrameCallback((_) async {
//      print("built");
//      await statisticsModel.fetchStats();
//    });

    return ScopedModel<ScanModel>(
      model: scanModel,
      child: ScopedModelDescendant<ScanModel>(
        builder: (context, child, onlineStatusModel) {
          return Scaffold(
            backgroundColor: ColorConstants.backgroundColors,
            appBar: onlineStatusModel.onlineStatus
                ? PreferredSize(
                    preferredSize: Size.zero,
                    child: Container(),
                  )
                : AppBar(
                    title: Text("OFFLINE"),
                    centerTitle: true,
                    automaticallyImplyLeading: true,
                    backgroundColor: ColorConstants.primaryTextColor,
                  ),
            body: OrientationBuilder(builder: (context, orientation) {
              return ScopedModel<KeyRegModel>(
                model: keyRegModel,
                child: ScopedModel<StatisticsModel>(
                  model: statisticsModel,
                  child: ScopedModel<InitialiseCamera>(
                    model: initialiseCameraModel,
                    child: Stack(
                      children: <Widget>[
                        CustomScrollView(
                          controller: _scrollController,
                          slivers: <Widget>[
                            SliverList(
                              delegate: SliverChildListDelegate([
                                ScopedModelDescendant<KeyRegModel>(
                                    builder: (context, child, model) {
                                  return Padding(
                                    padding: EdgeInsets.only(top: 20),
                                    child: Container(
                                      margin: EdgeInsets.only(
                                          left: 28.0, right: 32),
                                      // height: 128 * ScreenRatio.heightRatio,
                                      // width: 311 * ScreenRatio.heightRatio,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceEvenly,
                                        children: <Widget>[
                                          Container(
                                            height:
                                                20 * ScreenRatio.heightRatio,
                                            child: Text(
                                              model.eventForValidKey
                                                      .companyName ??
                                                  "Konduko SA",
                                              style: TextStyles.textStyle14Bold,
                                            ),
                                          ),
                                          Row(
                                            mainAxisSize: MainAxisSize.max,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Expanded(
                                                child: Container(
                                                    margin: EdgeInsets.only(
                                                        top: 12),
//                                              width: 50 * ScreenRatio.widthRatio,
//                                              height: 80,
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: <Widget>[
                                                        Text(
                                                          guestMode
                                                              ? "No Current Event"
                                                              : "${model.eventForValidKey?.eventName} in ${model.eventForValidKey?.venueName}",
//                                                        "Middle East Electricity 2019 in Dubai World Trade Centre",
                                                          style: TextStyle(
                                                              fontSize: 18 *
                                                                  ScreenRatio
                                                                      .heightRatio,
                                                              color: ColorConstants
                                                                  .primaryTextColor,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        ),
                                                        guestMode
                                                            ? Container(
                                                                width: 0,
                                                                height: 0,
                                                              )
                                                            : Container(
                                                                margin:
                                                                    EdgeInsets
                                                                        .only(
                                                                  top: 18 *
                                                                      ScreenRatio
                                                                          .heightRatio,
                                                                ),
                                                                child: Text(
                                                                  "${dateIntToStringMonth(model.eventForValidKey?.eventStartDate.month)} ${model.eventForValidKey?.eventStartDate.day} - ${model.eventForValidKey?.eventEndDate.day}, ${model.eventForValidKey?.eventStartDate.year}",
                                                                  style: TextStyles
                                                                      .textStyle11w600Secondary,
                                                                ),
                                                              )
                                                      ],
                                                    )),
                                              ),
                                              SizedBox(width: 32),
                                              AnimationOpacity(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 32.0),
                                                  child: SizedBox(
                                                    width: 64,
                                                    height: 64,
                                                    child: logo,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(
                                            height:
                                                12 * ScreenRatio.heightRatio,
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                }),
                                ScopedModelDescendant<ScanModel>(
                                    builder: (context, child, model) {
                                  return Container(
                                    margin: orientation == Orientation.portrait
                                        ? EdgeInsets.fromLTRB(25, 10, 20, 20)
                                        : EdgeInsets.fromLTRB(50, 30, 60, 30),
                                    height: 130 * ScreenRatio.heightRatio,
                                    child:
                                        ScopedModelDescendant<StatisticsModel>(
                                      builder: (context, child, statModel) {
                                        return Row(
                                          children: <Widget>[
                                            Expanded(
                                                child: InkWell(
                                              onTap: () {
                                                Navigator.of(context)
                                                    .pushNamed("/allContacts");
                                              },
                                              child: statCard(
                                                  ImageConstants.contacts,
                                                  model.contactList.length
                                                      .toString(),
                                                  "My Scans"),
                                            )),
                                            Expanded(
                                              child: statCard(
                                                  ImageConstants.touches,
                                                  prefs.getBool("guest")
                                                      ? "0"
                                                      : statModel.statistics
                                                                  .touchCount
                                                                  .toString() ==
                                                              "null"
                                                          ? "0"
                                                          : statModel.statistics
                                                              .touchCount
                                                              .toString(),
                                                  "Touches"),
                                            ),
                                            Expanded(
                                              child: statCard(
                                                  ImageConstants.statsAll,
                                                  prefs.getBool("guest")
                                                      ? "0"
                                                      : statModel
                                                          .statistics.leadCount
                                                          .toString(),
                                                  "All Leads"),
                                            ),
                                          ],
                                        );
                                      },
                                    ),
                                  );
                                }),
                                ScopedModelDescendant<ScanModel>(
                                    builder: (context, child, model) {
                                  return
//                                    model.contactList.isNotEmpty
//                                      ?
                                      AnimatedCrossFade(
                                          firstChild: Container(
                                            margin: orientation ==
                                                    Orientation.portrait
                                                ? EdgeInsets.all(25)
                                                : EdgeInsets.only(
                                                    left: 50, bottom: 25),
                                            child: Row(
                                              children: <Widget>[
                                                Text(
                                                  "Recent ",
                                                  style: TextStyle(
                                                      letterSpacing: 1,
                                                      fontSize: 32 *
                                                          ScreenRatio
                                                              .heightRatio,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: ColorConstants
                                                          .primaryTextColor),
                                                ),
                                                Text(
                                                  "Scans",
                                                  style: TextStyle(
                                                    letterSpacing: 1,
                                                    fontSize: 32 *
                                                        ScreenRatio.heightRatio,
                                                    inherit: true,
                                                    color: ColorConstants
                                                        .backgroundColors,
                                                    fontWeight: FontWeight.bold,
                                                    shadows: [
                                                      Shadow(
                                                          offset: Offset(-1, 0),
                                                          color: Colors.black),
                                                      Shadow(
                                                          offset: Offset(0, 1),
                                                          color: Colors.black),
                                                      Shadow(
                                                          offset: Offset(1, 0),
                                                          color: Colors.black),
                                                      Shadow(
                                                          offset: Offset(0, -1),
                                                          color: Colors.black),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          secondChild: Container(
//                                            height:
//                                                100 * ScreenRatio.heightRatio,
                                            alignment: Alignment.centerRight,

                                            margin: EdgeInsets.only(
                                                left: 30.0, right: 16.0,top: 50),
//                                          width:
//                                              MediaQuery.of(context).size.width,
//                                          height: 0,
                                            child: Text(
                                              "You currently have no scans",
                                              maxLines: 2,
                                              softWrap: true,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                  fontSize: 32 *
                                                      ScreenRatio.heightRatio,
                                                  fontWeight: FontWeight.w700,
                                                  color: ColorConstants
                                                      .lightBlack),
                                            ),
                                          ),
                                          crossFadeState:
                                              model.contactList.isNotEmpty
                                                  ? CrossFadeState.showFirst
                                                  : CrossFadeState.showSecond,
                                          duration:
                                              Duration(milliseconds: 1000));
                                }),
                              ]),
                            ),
                            ScopedModelDescendant<ScanModel>(
                                builder: (context, child, model) {
                              return SliverPadding(
                                padding: orientation == Orientation.portrait
                                    ? EdgeInsets.only(
                                        left: 20, right: 20, bottom: 100)
                                    : EdgeInsets.only(
                                        left: 50, right: 50, bottom: 100),
                                sliver: SliverGrid(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: orientation ==
                                                  Orientation.portrait
                                              ? 2
                                              : 3,
                                          childAspectRatio: 1.2,
                                          mainAxisSpacing: 10,
                                          crossAxisSpacing: 10),
                                  delegate: SliverChildBuilderDelegate(
                                    (BuildContext context, int index) {
                                      scrollStatus();
                                      return AnimationOpacity(
                                        durationInMM: 1000,
                                        child: GestureDetector(
                                          onTap: () async {
                                            model.currentScan =
                                                model.contactList[index];

                                            if (model
                                                .contactList[index].uploaded) {
                                              await Navigator.of(context)
                                                  .pushNamed("/addBadge");
                                            } else {
                                              if (!prefs.getBool("guest")) {
                                                print(
                                                    "model.contactList[index] => ${model.contactList[index]}");
//                                               await  Navigator.of(context).pushNamed(
//                                                    "/addOfflineBadge");

                                                if (model.contactList[index]
                                                    .uploadedSuccessfullyOnce) {
                                                  await Navigator.of(context)
                                                      .pushNamed("/addBadge");
                                                } else {
                                                  await Navigator.of(context)
                                                      .pushNamed(
                                                          "/addOfflineBadge");
                                                }
//

                                              } else {
                                                await Navigator.of(context)
                                                    .push(MaterialPageRoute(
                                                        builder: (context) =>
                                                            GuestModeAddOfflineBadge(
                                                                online: true)));
                                              }
                                            }
                                          },
                                          child: ContactCard(
                                            name: model.contactList[index]
                                                    .eEmbed.visitor.fullName ??
                                                "",
                                            uploaded: model.contactList[index]
                                                    .uploaded ??
                                                false,
                                            jobTitle: model.contactList[index]
                                                .eEmbed.visitor.jobTitle,
                                            company: model.contactList[index]
                                                .eEmbed.visitor.company,
                                          ),
                                        ),
                                      );
                                    },
                                    childCount: model.contactList.length > 20
                                        ? 20
                                        : model.contactList.length,
                                  ),
                                ),
                              );
                            }),
// Needed to add the yesterday section of the dashboard

//                  SliverList(
//                      delegate: SliverChildListDelegate([
//                    Container(
//                      //margin: EdgeInsets.fromLTRB(25, 50, 50, 50),
//                      margin: orientation == Orientation.portrait
//                          ? EdgeInsets.only(left: 25, top: 50, bottom: 50)
//                          : EdgeInsets.only(left: 50, top: 25, bottom: 25),
//                      child: Text(
//                        "Yesterday",
//                        style: TextStyle(
//                            letterSpacing: 1,
//                            fontSize: 35,
//                            fontWeight: FontWeight.bold,
//                            color: ColorConstants.primaryTextColor),
//                      ),
//                    ),
//                  ])),
//                  SliverPadding(
//                    padding: orientation == Orientation.portrait
//                        ? EdgeInsets.only(
//                            left: 20,
//                            right: 20,
//                            bottom: 120 * ScreenRatio.heightRatio)
//                        : EdgeInsets.only(left: 50, right: 50),
//                    sliver: SliverGrid(
//                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                          crossAxisCount:
//                              orientation == Orientation.portrait ? 2 : 3,
//                          childAspectRatio: 1.5,
//                          mainAxisSpacing: 10,
//                          crossAxisSpacing: 10),
//                      delegate: SliverChildBuilderDelegate(
//                        (BuildContext context, int index) {
//                          scrollStatus();x
//                          return Container(child: ContactCard(name: "name"));
//                        },
//                        childCount: names.length,
//                      ),
//                    ),
//                  ),
                          ],
                        ),
                        Positioned(
                          bottom: 32,
                          left: 32,
                          right: 32,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircularButton(
                                heroTag: "7",
                                icon: ImageConstants.menu,
                                backgroundColor: Colors.white,
                                iconcolor: Colors.black,
                                onPressed: () async {
                                  await Navigator.of(context)
                                      .pushNamed("/menu");
//                                        await statisticsModel.fetchStats();
                                },
                              ),
                              scrolling
                                  ? RoundedButton(
                                      shadow: true,
                                      label: "VIEW ALL",
                                      width: orientation == Orientation.portrait
                                          ? 120 * ScreenRatio.widthRatio
                                          : 200,
                                      textColor:
                                          ColorConstants.primaryTextColor,
                                      backgroundColor: Colors.white,
                                      onPressed: () async {
                                        await Navigator.of(context)
                                            .pushNamed("/allContacts");
//                                        await statisticsModel.fetchStats();
                                      },
                                    )
                                  : SizedBox(),
                              ScopedModelDescendant<InitialiseCamera>(
                                  builder: (context, child, initCameraModel) {
                                return CircularButton(
                                  heroTag: "6",
                                  icon: ImageConstants.scan,
                                  backgroundColor:
                                      ColorConstants.primaryTextColor,
                                  iconcolor: Colors.white,
                                  onPressed: () async {
                                    if (initCameraModel.controller == null) {
                                      initCameraModel.controller =
                                          await initCameraModel
                                              .initializeCamera(context);
                                      if (initCameraModel.controller != null &&
                                          initCameraModel
                                              .controller.value.isInitialized) {
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BarcodeCamera(
                                                        controller:
                                                            initCameraModel
                                                                .controller)));
                                      }
                                    } else {
                                      if (initCameraModel
                                          .controller.value.isInitialized) {
                                        await Navigator.of(context).push(
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    BarcodeCamera(
                                                        controller:
                                                            initCameraModel
                                                                .controller)));
                                      }
                                    }
                                  },
                                );
                              }),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }

  scrollStatus() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.offset > 200) {
        setState(() {
          scrolling = true;
        });
      }
      if (_scrollController.position.userScrollDirection.index == 1) {
        setState(() {
          scrolling = false;
        });
      }
    });
  }
}
