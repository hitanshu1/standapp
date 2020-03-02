import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/customFormField.dart';
import 'package:standapp/components/customOnTapFormField.dart';
import 'package:standapp/components/customTextField.dart';
import 'package:standapp/components/offlineBadge.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/services/intermediateService.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:uuid/uuid.dart';

//import 'package:keyboard_visibility/keyboard_visibility.dart';


double height;
double width;

class GuestModeAddOfflineBadge extends StatefulWidget {
  bool online;

  bool buttonDisabled = false;

//  Scan scan;
  GuestModeAddOfflineBadge({this.online = true});

  @override
  GuestModeAddOfflineBadgeState createState() {
    return new GuestModeAddOfflineBadgeState();
  }
}

class GuestModeAddOfflineBadgeState extends State<GuestModeAddOfflineBadge>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  ScrollController _scrollController = new ScrollController();

  double bottomGap = 0;

  Visitor visitor = Visitor();

//  KeyboardVisibilityNotification _keyboardVisibility = new KeyboardVisibilityNotification();
  bool _keyboardState;
  int _keyboardVisibilitySubscriberId;


  initState() {
    super.initState();
//    WidgetsBinding.instance.addObserver(this);


    controller = AnimationController(
        duration: const Duration(milliseconds: 3000), vsync: this);
    final CurvedAnimation curve =
    CurvedAnimation(parent: controller, curve: Curves.bounceOut);
    animation = Tween(begin: -500.0, end: 0.0).animate(curve)
      ..addListener(() {
        setState(() {});
      });
    controller.forward();

    print(scanModel.currentScan);

    if(scanModel.currentScan.extraFields!=null) {
      print("scanModel.currentScan.extraFields in offli => ${scanModel.currentScan.extraFields}");
      //{"levelOfInterest":"Select","purchaseTimeframe":"","purchasingAuthority":"","assignedBudget":"","salesPerson":""}

      print("here in off => ${json.decode(scanModel.currentScan.extraFields).runtimeType}"); //_InternalLinkedHashMap<String, dynamic>

      extraFields = json.decode(scanModel.currentScan.extraFields);
    }

//    _keyboardState = _keyboardVisibility.isKeyboardVisible;
//
//    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
//      onChange: (bool visible) {
////        setState(() {
////          bottomGap = MediaQuery.of(context).viewInsets.bottom;
//////          _keyboardState = visible;
////        });
//        print("_keyboardState => ${MediaQuery
//            .of(context)
//            .viewInsets
//            .bottom}");
//      },
//    );
  }


  @override
  void dispose() {
    super.dispose();
    controller?.dispose();
//    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  }

  final _formKey = GlobalKey<FormState>();

  var uuid = new Uuid();

  Map extraFields = {};

//  final Scan scan = Scan(barCode: "123456789");

//  _buildScansFromLocalStorage() async {
//    var aContact = await Service.guestModeStorageService(
//        parameter: "/scans/${scan.uuid}", action: "read");
//
//    print("contacts=> ${aContact}");
////    contacts.add(Contact.fromJson(aContact));
//  }
//
//@override
//  void dispose() {
//    // TODO: implement dispose
//    super.dispose();
//    WidgetsBinding.instance.removeObserver(this);
//    setState(() {
//      bottomGap = 0;
//    });
//
//}


//  @override
//  void didChangeMetrics(){
//
//    print("keyboard he = > ${MediaQuery.of(context).viewInsets.bottom}");
//  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.online
          ? null
          : AppBar(
        title: Text("OFFLINE"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        backgroundColor: ColorConstants.primaryTextColor,
      ),
      resizeToAvoidBottomPadding: true,
      backgroundColor: ColorConstants.backgroundColors,
      body: OrientationBuilder(
        builder: (context, orientation) {
          height = orientation == Orientation.portrait
              ? MediaQuery.of(context).size.height / 1.5
              : MediaQuery.of(context).size.width / 1.5;
          width = orientation == Orientation.portrait
              ? MediaQuery.of(context).size.width/ 1.2
              : MediaQuery.of(context).size.width / 2;
          return new ScopedModel<ScanModel>(
            model: scanModel,
            child: Form(
              key: _formKey,
              child: CustomScrollView(
                controller: _scrollController,
                cacheExtent: 500,
                slivers: <Widget>[
                  SliverList(
                      delegate: SliverChildListDelegate([
                        Container(
                          alignment: Alignment.center,
                          height: 660 * ScreenRatio.heightRatio,
                          width: 330 * ScreenRatio.widthRatio,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                top: animation.value,
                                child: Container(
                                  height: height,
                                  width: width,
                                  child: OfflineBadge(
                                    height: height,
                                    width: width,
                                    orientation: orientation,
                                    barcode: scanModel.currentScan.barCode,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: orientation == Orientation.portrait
                                ? EdgeInsets.only(left: 32, right: 32)
                                : EdgeInsets.only(
//                                top: 12,
                              left: MediaQuery.of(context).size.height / 2,
                              right: MediaQuery.of(context).size.height / 2,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                GestureDetector(
                                  child: Center(
                                    child: Text(
                                      "Swipe down or tap the Add Details button to enter further",
                                      style: TextStyles.textStyle14BoldBlack,
                                      maxLines: 1,
                                    ),
                                  ),
                                  onTap: () {
                                    _scrollController.animateTo(
                                        MediaQuery.of(context).size.height,
                                        duration: new Duration(seconds: 1),
                                        curve: Curves.fastOutSlowIn);
                                  },
                                ),
                                Center(
                                  child: Text(
                                    "attendee details.",
                                    style: TextStyles.textStyle14BoldBlack,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.only(left: 32.0, right: 32, top: 12)
                              : EdgeInsets.only(
                            left: 32,
                            right: 32,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              CircularButton(
                                icon: ImageConstants.back,
                                iconcolor: Colors.black,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              RoundedButton(
                                shadow: true,
                                width: 137 * ScreenRatio.widthRatio,
                                label: "ADD DETAILS",
                                textColor: Colors.white,
                                backgroundColor: ColorConstants.primaryTextColor,
                                onPressed: () {
                                  _scrollController.animateTo(
                                      MediaQuery.of(context).size.height,
                                      duration: new Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                },
                              ),
                            ],
                          ),
                        ),
                      ])),
                  SliverPadding(
                    padding: const EdgeInsets.only(top: 20.0),
                    sliver: SliverAppBar(
                      elevation: 0,
                      backgroundColor: ColorConstants.backgroundColors,
                      floating: false,
                      pinned: true,
                      flexibleSpace: FlexibleSpaceBar(
                        centerTitle: true,
                        title: InkWell(
                          onTap: () {
                            _scrollController.animateTo(0,
                                duration: new Duration(seconds: 1),
                                curve: Curves.fastOutSlowIn);
                          },
                          child: Text("Swipe up to see scanned badge",
                              style: TextStyles.textStyle14BoldBlack),
                        ),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          margin: EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Details",
                                style: TextStyles.textStyle32Primary,
                              ),
                              ScopedModelDescendant<ScanModel>(
                                builder: (context, child, model) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        top: 25 * ScreenRatio.heightRatio),
                                    height: orientation == Orientation.portrait
                                        ? 58 * ScreenRatio.heightRatio
                                        : 78 * ScreenRatio.heightRatio,
                                    child: CustomFormField(
                                      validator: (firstName) =>
                                      firstName.isEmpty
                                          ? "Enter first name"
                                          : null,
                                      onSaved: (firstName) {
                                        visitor.fullName="";
                                        visitor.fullName = firstName;
                                      },
                                      onTap: () {
//                                        print("keyboard he = > ${}");
//                                        setState(() {
//                                          bottomGap = 200;
//                                        });
                                        _scrollController.animateTo(MediaQuery
                                            .of(context)
                                            .size
                                            .height,
                                            duration: new Duration(seconds: 1),
                                            curve: Curves.fastOutSlowIn);
                                        print("tapped");
                                      },
                                      hintText:
                                      "First name",
                                      initialValue: model.currentScan.eEmbed.visitor
                                          .fullName.split(" ")[0]
                                          .isEmpty
                                          ? null
                                          : model.currentScan.eEmbed.visitor
                                          .fullName.split(" ")[0],

                                      textSize: 18*ScreenRatio.heightRatio,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 18 * ScreenRatio.heightRatio,
                              ),
                              ScopedModelDescendant<ScanModel>(
                                builder: (context, child, model) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        top: 25 * ScreenRatio.heightRatio),
                                    height: orientation == Orientation.portrait
                                        ? 58 * ScreenRatio.heightRatio
                                        : 78 * ScreenRatio.heightRatio,
                                    child: CustomFormField(
                                      validator: (lastName) => lastName.isEmpty
                                          ? "Enter last name"
                                          : null,
                                      onSaved: (lastName) {
                                        visitor.fullName =
                                            visitor.fullName + " " + lastName;
                                      },
                                      hintText: "Last Name",
                                      initialValue: model.currentScan.eEmbed.visitor
                                          .fullName
                                          .isEmpty
                                          ? null
                                          : model.currentScan.eEmbed.visitor
                                          .fullName.split(" ")[1],
                                      textSize: 18,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 18 * ScreenRatio.heightRatio,
                              ),
                              ScopedModelDescendant<ScanModel>(
                                builder: (context, child, model) {
                                  return Container(
                                    margin: EdgeInsets.only(
                                        top: 25 * ScreenRatio.heightRatio),
                                    height: orientation == Orientation.portrait
                                        ? 58 * ScreenRatio.heightRatio
                                        : 78 * ScreenRatio.heightRatio,
                                    child: CustomFormField(
//                                  validator: (email) => email.isEmpty
//                                      ? "Enter email address"
//                                      : null,
                                      onSaved: (email) {
                                        extraFields.update("alternateEmail",
                                                (oldValue) => email,
                                            ifAbsent: () => email);
//                                         visitor.additionalEmail = email;
                                      },
                                      hintText:"Email address",
                                      initialValue: extraFields["alternateEmail"]!=null?extraFields["alternateEmail"]:null,

//                                      initialValue: model.currentScan.eEmbed.visitor
//                                          .additionalEmail.isEmpty
//                                          ? null
//                                          : model
//                                          .currentScan.eEmbed.visitor.additionalEmail,
                                      textSize: 18 * ScreenRatio.heightRatio,
                                    ),
                                  );
                                },
                              ),
//                              SizedBox(
//                                height: 18 * ScreenRatio.heightRatio,
//                              ),

                              //TODO: Store phone numbers too
//                              Container(
//                                margin: EdgeInsets.only(
//                                    top: 25 * ScreenRatio.heightRatio),
//                                height: orientation == Orientation.portrait
//                                    ? 58 * ScreenRatio.heightRatio
//                                    : 78 * ScreenRatio.heightRatio,
//                                child: CustomFormField(
////                                  validator: (phone) => phone.isEmpty
////                                      ? "Enter phone number"
////                                      : null,
////                            onSaved: (phoneNumber) =>
////                                model.currentScan.phoneNumber = phoneNumber,
//                                  hintText: "Phone number",
//                                  textSize: 18 * ScreenRatio.heightRatio,
//                                ),
//                              ),
                            ],
                          ),
                        ),
//                        SizedBox(
//                          height: 18 * ScreenRatio.heightRatio,
//                        ),
//                        ScopedModelDescendant<ScanModel>(
//                          builder: (context, child, model) {
//                            return Container(
//                              margin: EdgeInsets.all(32),
//                              child: Column(
//                                crossAxisAlignment: CrossAxisAlignment.start,
//                                children: <Widget>[
//                                  Text(
//                                    "Questions",
//                                    style: TextStyles.textStyle32Primary,
//                                  ),
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                        top: 25 * ScreenRatio.heightRatio),
//                                    height: orientation == Orientation.portrait
//                                        ? 58 * ScreenRatio.heightRatio
//                                        : 78 * ScreenRatio.heightRatio,
//                                    child: CustomFormField(
////                                  validator: (salesPerson) =>
////                                      salesPerson.isEmpty
////                                          ? "Select a sales person"
////                                          : null,
//                                      onSaved: (salesPerson) {
//
//                                        print(salesPerson);
//                                        extraFields[
//                                        "salesPerson"] = salesPerson;
//                                        print("exta=> ${extraFields}");
//
//                                      },
////                            onSaved: (salesPerson) =>
////                                model.currentScan.salesPerson = salesPerson,
//                                      hintText: "Sales person",
//                                      initialValue: extraFields["salesPerson"]=="Select"?null:extraFields["salesPerson"],
//                                      textSize: 18 * ScreenRatio.heightRatio,
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    height: 18 * ScreenRatio.heightRatio,
//                                  ),
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                        top: 25 * ScreenRatio.heightRatio),
//                                    height: orientation == Orientation.portrait
//                                        ? 58 * ScreenRatio.heightRatio
//                                        : 78 * ScreenRatio.heightRatio,
//                                    child: CustomFormField(
////                                  validator: (interestLevel) =>
////                                      interestLevel.isEmpty
////                                          ? "Interest level"
////                                          : null,
//                                      onSaved: (levelOfInterest) =>
//                                      extraFields[
//                                      "levelOfInterest"] = levelOfInterest,
//                                      initialValue: extraFields["levelOfInterest"]=="Select"?null:extraFields["levelOfInterest"],
//
////                            onSaved: (interestLevel) =>
////                                model.currentScan.interestLevel = interestLevel,
//                                      hintText: "Level of interest",
//                                      textSize: 18 * ScreenRatio.heightRatio,
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    height: 18 * ScreenRatio.heightRatio,
//                                  ),
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                        top: 25 * ScreenRatio.heightRatio),
//                                    height: orientation == Orientation.portrait
//                                        ? 58 * ScreenRatio.heightRatio
//                                        : 78 * ScreenRatio.heightRatio,
//                                    child: CustomFormField(
////                                  validator: (purchasingTimeFrame) =>
////                                      purchasingTimeFrame.isEmpty
////                                          ? "Purchasing time frame"
////                                          : null,
//                                      onSaved: (purchaseTimeframe) {
//                                        extraFields[
//                                        "purchaseTimeframe"] = purchaseTimeframe;
//
//                                      },
//                                      initialValue: extraFields["purchaseTimeframe"]=="Select"?null:extraFields["purchaseTimeframe"],
//
////                            onSaved: (purchasingTimeFrame) =>
////                                model.currentScan.extraFields. = purchasingTimeFrame,
//                                      hintText: "Purchasing timeframe",
//                                      textSize: 18,
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    height: 18 * ScreenRatio.heightRatio,
//                                  ),
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                        top: 25 * ScreenRatio.heightRatio),
//                                    height: orientation == Orientation.portrait
//                                        ? 58 * ScreenRatio.heightRatio
//                                        : 78 * ScreenRatio.heightRatio,
//                                    child: CustomFormField(
////                                  validator: (purchasingAuthority) =>
////                                      purchasingAuthority.isEmpty
////                                          ? "Purchasing authority"
////                                          : null,
//                                      onSaved: (purchasingAuthority) =>
//                                      extraFields[
//                                      "purchasingAuthority"] = purchasingAuthority,
//                                      hintText: "Purchasing authority",
//                                      initialValue: extraFields["purchasingAuthority"]=="Select"?null:extraFields["purchasingAuthority"],
//                                      textSize: 18 * ScreenRatio.heightRatio,
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    height: 18 * ScreenRatio.heightRatio,
//                                  ),
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                        top: 25 * ScreenRatio.heightRatio),
//                                    height: orientation == Orientation.portrait
//                                        ? 58 * ScreenRatio.heightRatio
//                                        : 78 * ScreenRatio.heightRatio,
//                                    child: CustomFormField(
////                                  validator: (budget) =>
////                                      budget.isEmpty ? "Select a budget" : null,
//                                      onSaved: (assignedBudget) =>
//                                      extraFields[
//                                      "assignedBudget"] = assignedBudget,
////                            onSaved: (budget) => model.currentScan.budget = budget,
//                                      hintText: "Select a budget",
//                                      initialValue: extraFields["assignedBudget"]=="Select"?null:extraFields["assignedBudget"],
//
//                                      textSize: 18 * ScreenRatio.heightRatio,
//                                    ),
//                                  ),
//                                  SizedBox(
//                                    height: 18 * ScreenRatio.heightRatio,
//                                  ),
//                                  Container(
//                                    margin: EdgeInsets.only(
//                                        top: 25 * ScreenRatio.heightRatio),
//                                    height: orientation == Orientation.portrait
//                                        ? 58 * ScreenRatio.heightRatio
//                                        : 78 * ScreenRatio.heightRatio,
//                                    child: CustomFormField(
////                            onSaved: (notes) => model.currentScan.notes = notes,
//                                      hintText: "Add notes",
////                                      initialValue: extraFields["assignedBudget"].isEmpty?null:extraFields["assignedBudget"],
//
//                                      textSize: 18 * ScreenRatio.heightRatio,
//                                    ),
//                                  ),
//
//                                ],
//                              ),
//                            );
//                          },
//                        ),
                        SizedBox(
                          height: bottomGap * ScreenRatio.heightRatio,
                        ),

                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.only(
                              top: 5,
                            bottom: 20
                          )
                              : EdgeInsets.only(
                            left: 32.0,
                            right: 32,
                          ),
                          child: ScopedModelDescendant<ScanModel>(
                            builder: (context, child, model) {
                              return Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceAround,
                                children: <Widget>[
                                  CircularButton(
                                    heroTag: "1000",
                                    iconcolor: Colors.black,
                                    icon: ImageConstants.close,
                                    backgroundColor: Colors.white,
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),


                                  //TODO: button should not be able to be tapped twice
                                  AbsorbPointer(
                                    absorbing: widget.buttonDisabled,
//                                              absorbing: false,
                                    child: RoundedButton(
                                      shadow: true,
                                      width: 104 * ScreenRatio.widthRatio,
                                      label: "Finish",
                                      backgroundColor: widget.buttonDisabled?Colors.white:ColorConstants
                                          .primaryTextColor,
                                      textColor: widget.buttonDisabled?ColorConstants.primaryTextColor.withOpacity(0.5) :Colors.white,
                                      onPressed: () async {


                                        setState(() {
                                          widget.buttonDisabled = true;
                                        });
//                                        print("button tapped");

                                        if (_formKey.currentState
                                            .validate()) {
                                          _formKey.currentState.save();
//                                                  if (prefs.getBool("guest")) {
                                          _guestStorage(model);
//                                                  } else {
//                                                    await _activatedUserStorage(
//                                                        model);
//                                                  }
                                        } else {
                                          _scrollController.animateTo(
                                              0 +
                                                  MediaQuery.of(context)
                                                      .size
                                                      .height,
                                              duration: new Duration(
                                                  seconds: 1),
                                              curve:
                                              Curves.fastOutSlowIn);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

//  _activatedUserStorage(ScanModel model) async {
//
//    if(model.currentScan.id == null || model.currentScan.id.isEmpty ) {
//      model.currentScan.id = uuid.v4();
//    }
//
//    model.currentScan.uploaded = false;
//    model.currentScan.extraFields = json.encode(extraFields);
//
//    model.currentScan.eEmbed = Embed(visitor: visitor);
//
//    //TODO: Should not add this field when scan has been edited
////    model.currentScan.conversationAt = DateTime.now().toUtc().toString();
//
//    if (prefs == null) {
//      prefs = await SharedPreferences.getInstance();
//    }
//
//    String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
//    ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();
//    if (apiTokenWithLicenceString != null) {
//      apiTokenWithLicence =
//          ApiTokenWithLicence.fromJson(json.decode(apiTokenWithLicenceString));
//// Store locally under path {token}/scans
//      model.storeScan(scanToBeStored: model.currentScan, user: apiTokenWithLicence.newToken);
//    }
//    setState(() {
//      widget.buttonDisabled = false;
//    });
//
//    Navigator.of(context).popUntil(ModalRoute.withName("/dashboard"));
//  }

  _guestStorage(ScanModel model) {

    if(model.currentScan.id == null || model.currentScan.id.isEmpty ) {
      model.currentScan.id = uuid.v4();
    }

    model.currentScan.uploaded = false;
    model.currentScan.extraFields = json.encode(extraFields);
    model.currentScan.eEmbed = Embed(visitor: visitor);
    model.currentScan.conversationAt = DateTime.now().toUtc().toString();
    print("store new scan => ${model.currentScan}");

    model.storeScan(scanToBeStored: model.currentScan, user: "guest");

    Navigator.of(context).popUntil(ModalRoute.withName("/dashboard"));
  }
}