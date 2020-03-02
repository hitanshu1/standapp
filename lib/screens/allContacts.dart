import 'dart:math';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:standapp/components/animationOpacity.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/contactCard.dart';
import 'package:standapp/components/searchBar.dart';
import 'package:standapp/data/scoped_model_camera_initialise.dart';
import 'package:standapp/data/scoped_model_filter.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/screens/barcodeSacnner/barcodeCamera.dart';
import 'package:standapp/screens/dashboard.dart';
import 'package:standapp/screens/guestModeOfflineAddBadge.dart';

import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

import 'package:random_string/random_string.dart' as random;

///Displays all scans made by the user and also includes features to search and sort them accordingly.
///All the scans are grouped with respect to the first letter of their first name

class AllContacts extends StatefulWidget {
  @override
  AllContactsState createState() {
    return new AllContactsState();
  }
}

buildContactCardsForName() {
  int c = "a".codeUnitAt(0);
  int end = "z".codeUnitAt(0);
  DateTime today = DateTime.now().toUtc();
  int day = today.day;
  while (c <= end) {
    Scan contact = Scan(
        eEmbed: Embed(
            visitor: Visitor(
                fullName: random.randomAlpha(5) + " ${random.randomAlpha(5)}",
                company: random.randomAlpha(5),
                jobTitle: random.randomAlpha(5))),
        conversationAt:
            new DateTime.utc(today.year, today.month, day--).toString());
    scanModel.contactList.add(contact);
    c++;
  }
  scanModel.contactList = shuffle(scanModel.contactList);
  sortModel.populateSortedList(
      {"sortType": "name", "sortBy": "firstName", "isAsc": true},
      scanModel.contactList);
}

List shuffle(List items) {
  var random = new Random();

  // Go through all elements.
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a pseudorandom number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}

class AllContactsState extends State<AllContacts> {
  FocusNode focusNode = new FocusNode();
  TextEditingController textEditingController = TextEditingController();
  ScrollController _scrollController = new ScrollController();
//  CameraController controller;

  @override
  void initState() {
    super.initState();

//    initializeCamera().then((camController){
//      controller = camController;
//    });

//    _buildContactCardsForName();
    sortModel.populateSortedList(
        {"sortType": "name", "sortBy": "firstName", "isAsc": true},
        scanModel.contactList);
  }

//  Future initializeCamera() async{
//
//    if (controller != null) return controller;
//    final List<CameraDescription> cameras =
//    await availableCameras();
//
//    CameraDescription backCamera;
//    for (CameraDescription camera in cameras) {
//      if (camera.lensDirection ==
//          CameraLensDirection.back) {
//        backCamera = camera;
//        break;
//      }
//    }
//
//    if (backCamera == null)
//      throw ArgumentError(
//          "No back camera found.");
//    controller = new CameraController(
//        backCamera, ResolutionPreset.medium);
//
//    try {
//      await controller.initialize();
//      return controller;
//    } on CameraException catch (_) {
//      await showCameraDialog();
////      Navigator.of(context).pop();
//      print("camera e ");
//    }
//  }

  @override
  void dispose() {
//    sortModel.clear();
//    controller?.dispose();
    super.dispose();
  }

  Future<void> showCameraDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(
            'StandApp does not have access to your camera. To enable access, got to Settings and turn on Camera.',
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

  @override
  Widget build(BuildContext context) {
    return OrientationBuilder(builder: (context, orientation) {
      return Scaffold(
        backgroundColor: ColorConstants.backgroundColors,
        body: ScopedModel<SortModel>(
          model: sortModel,
          child: ScopedModel<ScanModel>(
            model: scanModel,
            child: ScopedModel<InitialiseCamera>(
              model: initialiseCameraModel,
              child: SafeArea(
                child: Stack(
                  children: <Widget>[
                    CustomScrollView(
                      controller: _scrollController,
                      slivers: <Widget>[
                        SliverPadding(
                          padding: EdgeInsets.only(
                              top: 42 * ScreenRatio.heightRatio,
                              left: 32 * ScreenRatio.heightRatio,
                              right: 32 * ScreenRatio.heightRatio),
                          sliver: ScopedModelDescendant<SortModel>(
                            builder: (context, child, model) {
                              print(
                                  "model.searchResultFound => ${model.searchResultFound["found"]}");
                              return SliverList(
                                delegate: SliverChildListDelegate([
                                  !model.searchResultFound["found"]
                                      ? Text(
                                          "All Scans",
                                          style: TextStyles.textStyle32Primary,
                                        )
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        ),
                                  model.searching
                                      ? SizedBox(
                                          height: 30 * ScreenRatio.heightRatio,
                                        )
                                      : Container(
                                          width: 0,
                                          height: 0,
                                        ),
                                  model.searching
                                      ? AnimatedCrossFade(
                                          duration: const Duration(seconds: 1),

                                          firstChild: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                "\"${model.searchResultFound["searchText"]}\"",
                                                style: TextStyles
                                                    .textStyle32Primary,
                                              ),
                                              Text(
                                                "${model.searchResultFound["numResults"]} scans found",
                                                style: TextStyles
                                                    .textStyle14BoldBlack,
                                              ),
                                            ],
                                          ),
//                                    }
//                                    else {
                                          secondChild: Search(
                                            onCancelPressed: () {
                                              if (textEditingController
                                                  .text.isEmpty) {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                model.searchResultFound = {
                                                  "found": false,
                                                  "searchText": "",
                                                  "numResults": 0
                                                };
                                                model.switchToAllScans();
                                              } else {
                                                textEditingController.clear();
                                              }
                                            },
                                            focusNode: focusNode,
                                            onEditingComplete: () {
                                              print(
                                                  "textEditingController.text=> ${textEditingController.text.isEmpty}");

                                              if (textEditingController
                                                  .text.isNotEmpty) {
                                                String searchText =
                                                    textEditingController.text;
                                                print(
                                                    "letter => ${model.mappedListDataOfAllContacts[searchText[0].toUpperCase()]}");

                                                if (model.mappedListDataOfAllContacts[
                                                        searchText[0]
                                                            .toUpperCase()] !=
                                                    null) {
                                                  model.search(searchText);
                                                } else {
                                                  model.clearList();
                                                }
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                              } else {
                                                FocusScope.of(context)
                                                    .requestFocus(FocusNode());
                                                model.switchToAllScans();
                                              }
                                            },
                                            onTap: () {
                                              print("tapped");
                                            },
                                            controller: textEditingController,
                                            autoFocus: true,
                                          ),
                                          crossFadeState:
                                              model.searchResultFound["found"]
                                                  ? CrossFadeState.showFirst
                                                  : CrossFadeState.showSecond,
                                        )

//                                     model.searchResultFound["found"]?
////                                      FocusScope.of(context)
////                                          .requestFocus(FocusNode());
//                                     Column(
//                                      crossAxisAlignment: CrossAxisAlignment.start,
//                                      children: <Widget>[
//                                      Text("\"${model.searchResultFound["searchText"]}\"",style: TextStyles.textStyle32Primary,),
//                                      Text("${model.searchResultFound["numResults"]} scans found",style: TextStyles.textStyle14BoldBlack,),
//                                    ],
//                                    ):
////                                    }
////                                    else {
//                                  Search(
//                                    onCancelPressed: (){
//                                      if(textEditingController.text.isEmpty){
//                                        FocusScope.of(context)
//                                            .requestFocus(FocusNode());
//                                        model.searchResultFound = {
//                                          "found": false,
//                                          "searchText": "",
//                                          "numResults": 0
//                                        };
//                                        model.switchToAllScans();
//                                      }else{
//                                        textEditingController.clear();
//                                      }
//                                    },
//                                      focusNode: focusNode,
//                                      onEditingComplete: () {
//                                        print(
//                                            "textEditingController.text=> ${textEditingController.text.isEmpty}");
//
//                                        if (textEditingController
//                                            .text.isNotEmpty) {
//                                          String searchText =
//                                              textEditingController.text;
//                                          print(
//                                              "letter => ${model.mappedListDataOfAllContacts[searchText[0].toUpperCase()]}");
//
//                                          if (model.mappedListDataOfAllContacts[
//                                                  searchText[0]
//                                                      .toUpperCase()] !=
//                                              null) {
//                                            model.search(searchText);
//                                          } else {
//                                            model.clearList();
//                                          }
//                                          FocusScope.of(context)
//                                              .requestFocus(FocusNode());
//                                        } else {
//                                          FocusScope.of(context)
//                                              .requestFocus(FocusNode());
//                                          model.switchToAllScans();
//                                        }
//                                      },
//                                      onTap: () {
//                                        print("tapped");
//                                      },
//                                      controller: textEditingController,
//                                      autoFocus: true,
//                                    )
//                                    }

                                      : Container(
                                          width: 0,
                                          height: 0,
                                        ),
                                ]),
                              );
                            },
                          ),
                        ),
                        ScopedModelDescendant<SortModel>(
                          builder: (context, child, model) {
                            return SliverPadding(
                              padding: EdgeInsets.only(
//                            top: 49 * ScreenRatio.heightRatio,
                                  bottom: 150 * ScreenRatio.heightRatio,
                                  left: 32,
                                  right: 32),
                              sliver: ScopedModelDescendant<ScanModel>(
                                builder: (context, child, localScanModel) {
                                  return SliverList(
                                    delegate: SliverChildListDelegate(
                                        _buildSections(
                                            model.currentSortType["sortType"],
                                            model,
                                            localScanModel)),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                    Padding(
                      padding: orientation == Orientation.portrait
                          ? EdgeInsets.only(
                              left: 32.0,
                              right: 32,
                              top: MediaQuery.of(context).size.height - 140,
                            )
                          : EdgeInsets.only(
                              left: 32.0,
                              right: 32,
                              top: MediaQuery.of(context).size.height - 70,
                            ),
                      child: ScopedModelDescendant<SortModel>(
                        builder: (context, child, model) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircularButton(
                                heroTag: "7",
                                icon: ImageConstants.menu,
                                backgroundColor: Colors.white,
                                iconcolor: Colors.black,
                                onPressed: () {
                                  Navigator.of(context)
                                      .pushReplacementNamed("/menu");
                                },
                              ),
                              !model.searching
                                  ? CircularButton(
                                      dotNeeded: true,
                                      heroTag: "8",
                                      icon: ImageConstants.filter,
                                      backgroundColor: Colors.white,
                                      iconcolor: Colors.black,
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed("/Filter");
                                      },
                                    )
                                  : Container(),
                              CircularButton(
                                heroTag: "9",
                                icon: model.searching
                                    ? ImageConstants.close
                                    : ImageConstants.inputSearch,
                                backgroundColor: Colors.white,
                                iconcolor: Colors.black54,
                                onPressed: () {
                                  print(model.searching);
                                  print(model.searchMode);
                                  if (model.searching) {
                                    model.searchResultFound = {
                                      "found": false,
                                      "searchText": "",
                                      "numResults": 0
                                    };
                                    model.switchToAllScans();
                                  } else {
                                    model.searchResultFound = {
                                      "found": false,
                                      "searchText": "",
                                      "numResults": 0
                                    };

                                    model.switchToSearchScans();
                                  }
                                  _scrollController.animateTo(0,
                                      duration: new Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                },
                              ),
                              ScopedModelDescendant<InitialiseCamera>(
                                builder: (context, child, initCameraModel) {
                                  return CircularButton(
                                    heroTag: "10",
                                    icon: ImageConstants.scan,
                                    backgroundColor:
                                        ColorConstants.primaryTextColor,
                                    iconcolor: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BarcodeCamera(
                                                      controller:
                                                          initCameraModel
                                                              .controller)));
                                    },
                                  );
                                },
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }

  _buildSections(type, SortModel model, ScanModel localScanModel) {
    if(model.genericMapKeyList.isNotEmpty) {
      return model.genericMapKeyList.map((alpha) {
        return Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(left: 3.0, bottom: 32, top: 48),
                child: Text(
                  type == "name" ? alpha.toUpperCase() : determineDateText(
                      alpha),
                  style: TextStyle(
                      fontSize: 18 * ScreenRatio.widthRatio,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Poppins',
                      color: model.searchMode
                          ? ColorConstants.lightBlack
                          : ColorConstants.touchableCardTextColor),
                ),
              ),
              GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                controller: new ScrollController(keepScrollOffset: false),
                shrinkWrap: true,
//                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                scrollDirection: Axis.vertical,
                children: model.genericMappedData[alpha].map((contact) {
                  return GestureDetector(
                    onTap: () {
                      localScanModel.currentScan = contact;
                      if (contact.uploaded) {
                        Navigator.of(context).pushReplacementNamed("/addBadge");
                      } else {
                        if (!prefs.getBool("guest")) {
                          Navigator.of(context).pushReplacementNamed("/addOfflineBadge");
                        } else {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) =>
                                  GuestModeAddOfflineBadge(online: true)));
                        }
                      }
                    },
                    child: ContactCard(
                      disabled: model.searchMode,
                      name: contact.eEmbed.visitor.fullName,
                      jobTitle: contact.eEmbed.visitor.jobTitle,
                      company: contact.eEmbed.visitor.company,
                      uploaded: contact.uploaded,
                    ),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      }).toList();
    }else{
      return [
        Container(
        height:
        100 * ScreenRatio.heightRatio,
        alignment: Alignment.center,

        margin: EdgeInsets.only(top: 32.0),
//                                          width:
//                                              MediaQuery.of(context).size.width,
//                                          height: 0,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Text(
            (model.searchMode
                ? "No results found"
                : "You currently have no scans"),
            maxLines: 2,
            softWrap: true,
            style: TextStyle(
                fontSize: 32 *
                    ScreenRatio.heightRatio,
                fontWeight: FontWeight.bold,
                color: ColorConstants
                    .lightBlack),
          ),
        ),
      )];
    }
//    }
  }

  determineDateText(dateString) {
    DateTime parsedDateTime = DateTime.parse(dateString);
    DateTime currentDate = DateTime.now();
    String formttedDateTime = "";
    if (parsedDateTime.day == DateTime.now().day) {
      formttedDateTime = "Today";
    } else if (parsedDateTime.day ==
        DateTime(currentDate.year, currentDate.month, currentDate.day - 1)
            .day) {
      formttedDateTime = "Yesterday";
    } else {
      formttedDateTime =
          "${dateIntToStringMonth(parsedDateTime.month)} ${parsedDateTime.day}, ${parsedDateTime.year}";
    }
    return formttedDateTime;
  }
}
