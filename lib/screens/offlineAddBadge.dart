import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/components/badge.dart';
import 'package:standapp/components/booleanQuestionType.dart';

import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/customFormField.dart';
import 'package:standapp/components/customTextField.dart';
import 'package:standapp/components/multiOptionPicker.dart';
import 'package:standapp/components/offlineBadge.dart';
import 'package:standapp/components/pickerField.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/data/scoped_model_questions.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/data/scoped_model_statistics.dart';
import 'package:standapp/data/scoped_model_upload.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/models/dynamicQuestions.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/services/intermediateService.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:uuid/uuid.dart';

double height;
double width;

class AddOfflineBadge extends StatefulWidget {
  bool online;
  bool buttonDisabled = false;

//  Scan scan;
  AddOfflineBadge({this.online = true});

  @override
  AddOfflineBadgeState createState() {
    return new AddOfflineBadgeState();
  }
}

class AddOfflineBadgeState extends State<AddOfflineBadge>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  ScrollController _scrollController = new ScrollController();

  Visitor visitor = Visitor();

  @override
  dispose(){
    controller?.dispose();
    super.dispose();
  }

  @override
  initState() {
    super.initState();
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
      extraFields = json.decode(scanModel.currentScan.extraFields);
//      extraFields = json.decode(scanModel.currentScan.extraFields);
    }
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
              ? MediaQuery.of(context).size.width / 1.2
              : MediaQuery.of(context).size.width / 2;

//          height = 625 * ScreenRatio.heightRatio;
//          width = MediaQuery.of(context).size.width;
          return new ScopedModel<ScanModel>(
            model: scanModel,
            child: Form(
              key: _formKey,
              child: CustomScrollView(
                controller: _scrollController,
                cacheExtent: 20000,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        //TODO: Use the same online badge to show the offline content

                        Container(
                          alignment: Alignment.center,
                          height: height + 24,
                          width: width + 24,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                top: animation.value,
                                child: Container(
                                  height: height,
                                  width: width,
//                                  350 * ScreenRatio.heightRatio,
                                  child:
                                    OfflineBadge(
                                      height: height,
                                      width: width,
                                      orientation: orientation,
                                      barcode : scanModel.currentScan.barCode,
                                    ),
//                                  Badge(
//                                    height: height,
//                                    width: width,
//                                    orientation: orientation,
//                                    scan : scanModel.currentScan,
//                                    online: false,
//                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Container(
                            margin: orientation == Orientation.portrait
                                ? EdgeInsets.only(left: 32, right: 32)
                                : EdgeInsets.only(
                                top: 24,
                                    left:
                                        MediaQuery.of(context).size.height / 2,
                                    right:
                                        MediaQuery.of(context).size.height / 2,
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
                                heroTag: "asdasdasdasss",
                                icon: ImageConstants.back,
                                iconcolor: Colors.black,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              RoundedButton(
                                shadow: true,
                                width: 137* ScreenRatio.widthRatio,
                                label: "ADD DETAILS",
                                textColor: Colors.white,
                                backgroundColor:
                                    ColorConstants.primaryTextColor,
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


                      ],
                    ),
                  ),
                  SliverAppBar(
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
                                  String firstName;
                                  String secondName;

                                  return Container(
                                    margin: EdgeInsets.only(
                                        top:
                                        25 * ScreenRatio.heightRatio),
                                    height: orientation ==
                                        Orientation.portrait
                                        ? 58 * ScreenRatio.heightRatio
                                        : 78 * ScreenRatio.heightRatio,
                                    child: CustomFormField(
                                      validator: (firstName) =>
                                      firstName.isEmpty
                                          ? "Enter first name"
                                          : null,
                                      onSaved: (firstName) {
                                        visitor.fullName = "";
                                        visitor.fullName = firstName;
                                      },
                                      hintText: "First name",
                                      initialValue: model.currentScan
                                          .eEmbed.visitor.fullName
                                          .split(" ")[0]
                                          .isEmpty
                                          ? null
                                          : model.currentScan.eEmbed
                                          .visitor.fullName
                                          .split(" ")[0],
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
                                        top:
                                        25 * ScreenRatio.heightRatio),
                                    height: orientation ==
                                        Orientation.portrait
                                        ? 58 * ScreenRatio.heightRatio
                                        : 78 * ScreenRatio.heightRatio,
                                    child: CustomFormField(
                                      validator: (lastName) =>
                                      lastName.isEmpty
                                          ? "Enter last name"
                                          : null,
                                      onSaved: (lastName) {
                                        visitor.fullName =
                                            visitor.fullName +
                                                " " +
                                                lastName;
                                      },
                                      hintText: "Last Name",
                                      initialValue: model
                                          .currentScan
                                          .eEmbed
                                          .visitor
                                          .fullName
                                          .isEmpty
                                          ? null
                                          : model.currentScan.eEmbed
                                          .visitor.fullName
                                          .split(" ")[1],
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
                                        top:
                                        25 * ScreenRatio.heightRatio),
                                    height: orientation ==
                                        Orientation.portrait
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
                                        },
                                      hintText: "Email address",
                                      initialValue: extraFields["alternateEmail"]!=null?extraFields["alternateEmail"]:null,
                                      textSize:
                                      18 * ScreenRatio.heightRatio,
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: 18 * ScreenRatio.heightRatio,
                              ),

                              //TODO: Store phone numbers too
                              Container(
                                margin: EdgeInsets.only(
                                    top: 25 * ScreenRatio.heightRatio),
                                height:
                                orientation == Orientation.portrait
                                    ? 58 * ScreenRatio.heightRatio
                                    : 78 * ScreenRatio.heightRatio,
                                child: CustomFormField(
//                                  validator: (phone) => phone.isEmpty
//                                      ? "Enter phone number"
//                                      : null,
                            onSaved: (phoneNumber) {
                              extraFields.update("phoneNumber",
                                      (oldValue) => phoneNumber,
                                  ifAbsent: () => phoneNumber);
                              },

                                  initialValue:
                                  extraFields["phoneNumber"] != null
                                      ? extraFields["phoneNumber"]
                                      : null,
                                  hintText: "Phone number",
                                  textSize: 18 * ScreenRatio.heightRatio,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 18 * ScreenRatio.heightRatio,
                        ),
                        ScopedModelDescendant<ScanModel>(
                          builder: (context, child, model) {
                            return
                              Container(
                                margin: EdgeInsets.all(32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Questions",
                                      style: TextStyles.textStyle32Primary,
                                    ),
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: _buildQuestionsSection(model),
                                    ),
//                                    SizedBox(height: 5,),
                                    Padding(
                                      padding:
                                      EdgeInsets.only(
                                        top: 32,
                                      ),

                                      child:  Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              CircularButton(
                                                iconcolor: Colors.black,
                                                icon: ImageConstants.close,
                                                backgroundColor: Colors.white,
                                                onPressed: () async {
//                                                  await statisticsModel.fetchStats();

                                                  Navigator.of(context).pop();

                                                },
                                              ),
                                              RoundedButton(
//                                                buttonDisabled: widget.buttonDisabled,
                                                shadow: true,
                                                width: 104*ScreenRatio.widthRatio,
                                                label: "Finish",
                                                backgroundColor: ColorConstants
                                                    .primaryTextColor,
                                                textColor: Colors.white,
                                                onPressed: () async{
                                                  setState(() {
                                                    widget.buttonDisabled = true;
                                                  });
                                                  print("button tapped");



                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    _formKey.currentState.save();

                                                      await _activatedUserStorage(
                                                          model);

                                                  } else {

                                                    Scaffold.of(context).showSnackBar(
                                                        SnackBar(
                                                            content: Text("Enter all required fields to continue")));
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                    )
                                  ],
                                ),
                              );
                          },
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

  _buildQuestionsSection(ScanModel model) {
    questionsModel.dynamicQuestions.questions.sort((a,b)=>a.order.compareTo(b.order));

    return List<Widget>.generate(
        questionsModel.dynamicQuestions.questions.length , (questionsIndex) {
//          print(questionsModel.dynamicQuestions.questions.length);
//      if (questionsIndex == 0) {
//        return Container(width: 0,height: 0,);
//
//      } else {
        return _buildQuestionBasedOnType(
            questionsModel.dynamicQuestions.questions[questionsIndex],model);
//      }
    });
  }

  _buildQuestionBasedOnType(Questions aSingleQuestion,ScanModel model) {

    print("extraFields => ${extraFields}");
    print("aSingleQuestion => ${aSingleQuestion}");
    switch (aSingleQuestion.inputControl.type) {
      case "TextBox":
        {
          return Container(
            margin: EdgeInsets.only(top: 25 * ScreenRatio.heightRatio),
            height:
//          orientation == Orientation.portrait
//              ?
            58 * ScreenRatio.heightRatio,
//              : 78 * ScreenRatio.heightRatio,
            child: CustomFormField(
              validator: (contentToValidate) {
                print("content => ${contentToValidate} & ${aSingleQuestion
                    .required}");
                return contentToValidate.isEmpty && aSingleQuestion.required
                    ? "Please enter ${aSingleQuestion.text}"
                    : null;
              },

              onSaved: (answer) {
//                extraFields.putIfAbsent(question.label, ()=>answer);
                extraFields.update(aSingleQuestion.label, (oldValue) => answer,
                    ifAbsent: () => answer);

//                extraFields.salesPerson = salesPerson.isEmpty?"Select":salesPerson;
//              print("exta=> ${extraFields}");
              },
//              labelText: aSingleQuestion.label,
//                            onSaved: (salesPerson) =>
//                                model.currentScan.salesPerson = salesPerson,
              hintText: aSingleQuestion.text,
              initialValue: extraFields.keys.contains(aSingleQuestion.label)
                  ? extraFields[aSingleQuestion.label]
                  : null,
              textSize: 18 * ScreenRatio.heightRatio,
            ),
          );
        }
        break;

      case "SingleComboBox":
        {
          return Container(
            margin: EdgeInsets.only(top: 50 * ScreenRatio.heightRatio),
            height:
//          orientation == Orientation.portrait
//              ?
            58 * ScreenRatio.heightRatio,
//              : 78 * ScreenRatio.heightRatio,
            child: PickerField(
              onTap: () {
//                _scrollController.animateTo(
//                    _scrollController.position.maxScrollExtent,
//                    duration: new Duration(seconds: 1),
//                    curve: Curves.fastOutSlowIn);
              },
              label: aSingleQuestion.text,

              pickerData: aSingleQuestion.inputControl.options,
              initialValue: extraFields.keys.contains(aSingleQuestion.label)
                  ? extraFields[aSingleQuestion.label]
                  : null,
              question: aSingleQuestion,
              onSaved: (question, answer) {
                extraFields.update(question, (oldValue) => answer,
                    ifAbsent: () => answer);
              },
            ),
          );
        }
        break;

      case "MultiComboBox":
        {
          return Container(
            margin: EdgeInsets.only(top: 32 * ScreenRatio.heightRatio),
            height:
//          orientation == Orientation.portrait
//              ?
            58 * ScreenRatio.heightRatio,
//              : 78 * ScreenRatio.heightRatio,
            child: MultiOptionPickerField(
              label: aSingleQuestion.text,

              initialValue: extraFields.keys.contains(aSingleQuestion.label)
                  ? extraFields[aSingleQuestion.label]
                  : null,
              pickerData: [
                {
                  "label": aSingleQuestion.label,
                  "options": aSingleQuestion.inputControl.options
                }
              ],
              question: aSingleQuestion,
              onSaved: (question, answer) {
                extraFields.update(question, (oldValue) => answer,
                    ifAbsent: () => answer);
              },
            ),
          );
        }
        break;

      case "YesNo":
        {
          return Container(
            margin: EdgeInsets.only(top: 25 * ScreenRatio.heightRatio),
            height:
//          orientation == Orientation.portrait
//              ?
            97 * ScreenRatio.heightRatio,
//              : 78 * ScreenRatio.heightRatio,
            child: BooleanQuestion(
              question: aSingleQuestion,
              label: aSingleQuestion.text,
              initialValue: extraFields.keys.contains(aSingleQuestion.label)
                  ? extraFields[aSingleQuestion.label].isEmpty?null:(extraFields[aSingleQuestion.label] == "Yes" ? true : false)
                  : null,
              onSaved: (question, answer) {
                extraFields.update(question, (oldValue) => answer,
                    ifAbsent: () => answer);
              },
//            selectedYes: true,
            ),
          );
        }
        break;

      case "TextArea":
        {
//          print("TextArea => ${aSingleQuestion}");
          return Container(
            margin: EdgeInsets.only(top: 25 * ScreenRatio.heightRatio),
//            height:
////              orientation == Orientation.portrait
////                  ?
//                58 * ScreenRatio.heightRatio,
//                  : 78 * ScreenRatio.heightRatio,
            child: TextFormField(
//              focusNode: notesNodeFocus,
              onSaved: (answer) {

//                model.currentScan.text = answer;
                extraFields.update(aSingleQuestion.label, (oldValue) => answer,
                    ifAbsent: () => answer);
              },
              validator: (contentToValidate) {
                print("content => ${contentToValidate} & ${aSingleQuestion
                    .required}");
                return contentToValidate.isEmpty && aSingleQuestion.required
                    ? "Please enter ${aSingleQuestion.text}"
                    : null;
              },
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              initialValue:
              extraFields.keys.contains(aSingleQuestion.label)
                  ? extraFields[aSingleQuestion.label]
                  : null,
//              model.currentScan.text !="-"?model.currentScan.text:"",
              style: TextStyles.textStyle14Black,
              decoration: InputDecoration(
//                contentPadding: EdgeInsets.only(
//                  bottom: 100 * ScreenRatio.heightRatio,
//                ),
                border: UnderlineInputBorder(
                  borderSide: BorderSide(
                      width: 2.0, color: ColorConstants.primaryTextColor),
                ),
                hintText: aSingleQuestion.text,
                hintStyle: TextStyle(
                  fontSize: 18 * ScreenRatio.heightRatio,
                  color: ColorConstants.secondaryTextColor,
                  fontWeight: FontWeight.w400,
                ),
//                labelText: aSingleQuestion.label,
              ),
            ),
          );
        }
        break;
      default:
        {
          //statements;
        }
        break;
    }
  }

  _activatedUserStorage(ScanModel model) async {
    if (model.currentScan.id == null || model.currentScan.id.isEmpty) {
      model.currentScan.id = uuid.v4();
    }

    model.currentScan.uploaded = false;
    model.currentScan.extraFields = json.encode(extraFields);

    model.currentScan.eEmbed = Embed(visitor: visitor);



    //TODO: Should not add this field when scan has been edited
//    model.currentScan.conversationAt = DateTime.now().toUtc().toString();

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
    ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();
    if (apiTokenWithLicenceString != null) {
      apiTokenWithLicence =
          ApiTokenWithLicence.fromJson(json.decode(apiTokenWithLicenceString));
// Store locally under path {token}/scans
      model.storeScan(
          scanToBeStored: model.currentScan,
          user: apiTokenWithLicence.newToken);
    }
    setState(() {
      widget.buttonDisabled = false;
    });
//    await statisticsModel.fetchStats();

    Navigator.of(context).popUntil(ModalRoute.withName("/dashboard"));

  }

}
