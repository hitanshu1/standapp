import 'dart:convert';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/components/badge.dart';
import 'package:standapp/components/booleanQuestionType.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/customFlutterTextFormField.dart';
import 'package:standapp/components/customFormField.dart';
import 'package:standapp/components/customOnTapFormField.dart';
import 'package:standapp/components/customTextField.dart';
import 'package:standapp/components/multiOptionPicker.dart';
import 'package:standapp/components/pickerField.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:standapp/data/scoped_model_questions.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/data/scoped_model_statistics.dart';
import 'package:standapp/data/scoped_model_upload.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/dynamicQuestions.dart';
import 'package:standapp/models/extraFields.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/services/internetService.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/animation.dart';

double height;
double width;

class AddBadge extends StatefulWidget {
  bool buttonDisabled = false;

  @override
  AddBadgeState createState() {
    return new AddBadgeState();
  }
}

class AddBadgeState extends State<AddBadge>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  ScrollController _scrollController = new ScrollController();

  FocusNode notesNodeFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  Map extraFields = {};

  @override
  dispose() {
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

    print(
        "scanModel.currentScan.extraFields => ${scanModel.currentScan.extraFields}");

    if (scanModel.currentScan.extraFields != null) {
      print("decoded => ${json.decode(scanModel.currentScan.extraFields)}");
      extraFields = json.decode(scanModel.currentScan.extraFields);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModel<UploadModel>(
      model: uploadModel,
      child: ScopedModel<ScanModel>(
        model: scanModel,
        child: Scaffold(
          resizeToAvoidBottomPadding: true,
          backgroundColor: ColorConstants.backgroundColors,
          body: OrientationBuilder(
            builder: (context, orientation) {
//              height = orientation == Orientation.portrait
//                  ? MediaQuery.of(context).size.height / 1.3
//                  : MediaQuery.of(context).size.width / 1.3;
//              width = orientation == Orientation.portrait
//                  ? MediaQuery.of(context).size.width
//                  : MediaQuery.of(context).size.width / 2;
              height = 625 * ScreenRatio.heightRatio;
              width = MediaQuery.of(context).size.width;
              return CustomScrollView(
//                semanticChildCount: questionsModel.dynamicQuestions.questions.length+10,
                controller: _scrollController,
                cacheExtent: 20000,
                slivers: <Widget>[
                  SliverList(
                    delegate: SliverChildListDelegate(
                      [
                        Container(
                          height: height + 24,
                          width: width + 24,
                          child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              ScopedModelDescendant<ScanModel>(
                                builder: (context, child, model) {
//                            print("model.cirrentScan => ${model.currentScan}");
                                  return Positioned(
                                    top: animation.value,
                                    child: Container(
                                      height: height,
                                      width: width,
                                      child: Badge(
                                        height: height,
                                        width: 350 * ScreenRatio.heightRatio,
                                        orientation: orientation,
                                        scan: model.currentScan,
                                        online: true,
                                      ),
                                    ),
                                  );
                                },
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
                                  onTap: () {
                                    _scrollController.animateTo(
                                        MediaQuery.of(context).size.height,
                                        duration: new Duration(seconds: 1),
                                        curve: Curves.fastOutSlowIn);
                                  },
                                  child: Center(
                                    child: Text(
                                      "Swipe down or tap the Add Details button to",
                                      style: TextStyles.textStyle14Black,
                                      maxLines: 1,
                                    ),
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    " enter further attendee details.",
                                    style: TextStyles.textStyle14Black,
                                    maxLines: 1,
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: orientation == Orientation.portrait
                              ? EdgeInsets.only(
                                  left: 32.0,
                                  right: 32,
                                  top: 10,
                                )
                              : EdgeInsets.only(
                                  left: 32.0,
                                  right: 32,
                                ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              RoundedButton(
                                shadow: true,
                                width: 156 * ScreenRatio.widthRatio,
                                label: "ADD DETAILS",
                                textColor: ColorConstants.primaryTextColor,
                                backgroundColor: Colors.white,
                                onPressed: () {
                                  _scrollController.animateTo(
                                      MediaQuery.of(context).size.height,
                                      duration: new Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                },
                              ),
                              ScopedModelDescendant<ScanModel>(
                                builder: (context, child, model) {
                                  return ScopedModelDescendant<UploadModel>(
                                    builder: (context, child, uploadModel) {
                                      return AbsorbPointer(
                                        absorbing: widget.buttonDisabled,
                                        child: RoundedButton(
                                          buttonDisabled: widget.buttonDisabled,
                                          shadow: true,
                                          width: 104 * ScreenRatio.widthRatio,
                                          label: "Finish",
                                          textColor:
                                              ColorConstants.primaryTextColor,
                                          backgroundColor: widget.buttonDisabled
                                              ? ColorConstants.primaryTextColor
                                              : Colors.white,
                                          onPressed: () {
                                            if (_formKey.currentState
                                                .validate()) {
                                              setState(() {
                                                widget.buttonDisabled = true;
                                              });
                                              _formKey.currentState.save();

                                              model.currentScan.extraFields =
                                                  json.encode(extraFields);
//                                      print(
//                                          "check 6 => ${json.encode(
//                                              extraFields)}");

                                              model.currentScan.uploaded = true;
                                              _handleScan(uploadModel, context,
                                                  model.currentScan);
                                            }
                                          },
                                        ),
                                      );
                                    },
                                  );
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
                        child: Text("Swipe up to see the attendee's badge",
                            style: TextStyles.textStyle16Black),
                      ),
                    ),
                  ),
                  ScopedModelDescendant<ScanModel>(
                    builder: (context, child, model) {
                      return Form(
                        key: _formKey,
                        child: SliverList(

                          delegate: SliverChildListDelegate(

                            [
                              Container(
                                margin: EdgeInsets.all(32),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      "Additional",
                                      style: TextStyles.textStyle32Primary,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 41 * ScreenRatio.heightRatio),
                                      height:
                                          orientation == Orientation.portrait
                                              ? 58 * ScreenRatio.heightRatio
                                              : 78 * ScreenRatio.heightRatio,
                                      child: CustomFormField(
//                                        validator: (email) =>
//                                            RegExp(r"^(?=.{1,254}$)(?=.{1,64}@)[-!#$%&'*+/0-9=?A-Z^_`a-z{|}~]+(\.[-!#$%&'*+/0-9=?A-Z^_`a-z{|}~]+)*@[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?(\.[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?)*$")
//                                                    .hasMatch(email)
//                                                ? null
//                                                : "Enter valid Email address",
                                        textInputType:
                                            TextInputType.emailAddress,
                                        initialValue:
                                            (extraFields["alternateEmail"] !=
                                                    null
                                                ? extraFields["alternateEmail"]
                                                : null),
                                        onSaved: (email) {
                                          print("email => ${email}");
//                                          model.currentScan.eEmbed.visitor.additionalEmail = email;
                                          extraFields.update("alternateEmail",
                                              (oldValue) => email,
                                              ifAbsent: () => email);


                                          print("extraFields in email => ${extraFields}");

                                        },
                                        hintText: "Additional email",
//                                        labelText: "Additional email",
                                        textSize: 18 * ScreenRatio.widthRatio,
                                        onTap: () {
                                          print("t");
                                          _scrollController.jumpTo(
                                              MediaQuery.of(context)
                                                  .size
                                                  .height);
//                                          _scrollController.animateTo(
//                                              MediaQuery.of(context).size.height,
//                                              duration: new Duration(seconds: 1),
//                                              curve: Curves.fastOutSlowIn);
                                        },
                                      ),
                                    ),
                                    SizedBox(
                                      height: 18 * ScreenRatio.heightRatio,
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: 25 * ScreenRatio.heightRatio),
                                      height:
                                          orientation == Orientation.portrait
                                              ? 58 * ScreenRatio.heightRatio
                                              : 78 * ScreenRatio.heightRatio,
                                      child: CustomFormField(
                                        onTap: () {
                                          _scrollController.animateTo(
                                              MediaQuery.of(context)
                                                  .size
                                                  .height,
                                              duration:
                                                  new Duration(seconds: 1),
                                              curve: Curves.fastOutSlowIn);
                                        },

                                        onSaved: (phoneNumber) {
                                          extraFields.update("phoneNumber",
                                              (oldValue) => phoneNumber,
                                              ifAbsent: () => phoneNumber);
                                        },
                                        hintText: "Additional Phone",
                                        initialValue:
                                            extraFields["phoneNumber"] != null
                                                ? extraFields["phoneNumber"]
                                                : null,
                                        textSize: 18 * ScreenRatio.heightRatio,
//                                        labelText: "Additional Phone",
                                      ),
                                    ),
                                  ],
                                ),
                              ),
//                              SizedBox(
//                                height: 18 * ScreenRatio.heightRatio,
//                              ),
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
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: _buildQuestionsSection(model),
                                    ),
                                    SizedBox(
                                      height: 50 * ScreenRatio.heightRatio,
                                    ),
                                    ScopedModelDescendant<UploadModel>(
                                      builder: (context, child, uploadModel) {
                                        return Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: <Widget>[
                                            CircularButton(
                                              heroTag: "kjskdj",
                                              iconcolor: Colors.black,
                                              icon: ImageConstants.close,
                                              backgroundColor: Colors.white,
                                              onPressed: () async {
//                                                await statisticsModel.fetchStats();

                                                Navigator.of(context).pop();
                                              },
                                            ),
                                            AbsorbPointer(
                                              absorbing: widget.buttonDisabled,
                                              child: RoundedButton(
                                                buttonDisabled:
                                                    widget.buttonDisabled,
                                                shadow: true,
                                                width: 104 *
                                                    ScreenRatio.widthRatio,
                                                label: "Finish",
                                                backgroundColor: ColorConstants
                                                    .primaryTextColor,
                                                textColor: Colors.white,
                                                onPressed: () {
                                                  if (_formKey.currentState
                                                      .validate()) {
                                                    setState(() {
                                                      widget.buttonDisabled =
                                                          true;
                                                    });
                                                    print("button tapped");

                                                    _formKey.currentState
                                                        .save();

                                                    model.currentScan
                                                            .extraFields =
                                                        json.encode(
                                                            extraFields);
                                                    print(
                                                        "check 6 => ${json.encode(
                                                            extraFields)}");

                                                    model.currentScan.uploaded =
                                                        true;
                                                    _handleScan(
                                                        uploadModel,
                                                        context,
                                                        model.currentScan);
                                                  }
                                                },
                                              ),
                                            ),
                                          ],
                                        );
                                      },
                                    )
                                  ],
                                ),
                              ),
//                                SizedBox(height: 300 * ScreenRatio.heightRatio,)
                            ],
                            addAutomaticKeepAlives: true,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  _handleScan(UploadModel model, context, Scan scan) async {
//    print("here");
//  scan.conversationAt = DateTime.now().toUtc().toString();

    ///IMPORTANT
    print("extraFields check here => ${scan.extraFields}");

    ConnectivityResult currentConnectivity;

    currentConnectivity = await InternetCheck.getCurrentConnectivity();
    if (currentConnectivity == ConnectivityResult.mobile ||
        currentConnectivity == ConnectivityResult.wifi) {
      await model.uploadScan(scan);
      Navigator.of(context).pop();
    } else {
      String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
      ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

      String token;
      String conversationsLink;

      if (apiTokenWithLicenceString != null) {
        apiTokenWithLicence = ApiTokenWithLicence.fromJson(
            json.decode(apiTokenWithLicenceString));
        token = apiTokenWithLicence.newToken;
        conversationsLink = apiTokenWithLicence.conversationsLink;
      }

      print("check here for upload once => ${scan}");
      if (scan.uploaded) scan.uploadedSuccessfullyOnce = true;
      scan.uploaded = false;

      await scanModel.updateScanLocallyAndModel(scan: scan, user: "user");
//    scanModel.storeScan(
//        scanToBeStored: scan,
//        user: apiTokenWithLicence.newToken);
      setState(() {
        widget.buttonDisabled = true;
      });
//        await statisticsModel.fetchStats();

      Navigator.of(context).pop();
//    Scaffold.of(context).showSnackBar(
//        SnackBar(content: Text("Connect to the Internet and try again.")));
    }

//    await model.uploadScan(scan);

//    if (model.apiResponseForScanDetails.error == null) {
////      await statisticsModel.fetchStats();
//
//      Navigator.of(context).pop();
//    } else {
//      if (model.apiResponseForScanDetails.error ==
//          "Connect to the Internet and try again.") {
//        String apiTokenWithLicenceString =
//        prefs.getString("apiTokenWithLicence");
//        ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();
//
//        String token;
//        String conversationsLink;
//
//        if (apiTokenWithLicenceString != null) {
//          apiTokenWithLicence = ApiTokenWithLicence.fromJson(
//              json.decode(apiTokenWithLicenceString));
//          token = apiTokenWithLicence.newToken;
//          conversationsLink = apiTokenWithLicence.conversationsLink;
//        }
//
//        scan.uploaded = false;
//        await scanModel.updateScanLocallyAndModel(scan: scan, user: "user");
//        setState(() {
//          widget.buttonDisabled = true;
//        });
////        await statisticsModel.fetchStats();
//
//        Navigator.of(context).pop();
//      } else {
//        Scaffold.of(context).showSnackBar(
//            SnackBar(content: Text(model.apiResponseForScanDetails.error)));
//      }
//    }
  }

  _buildQuestionsSection(ScanModel model) {
//    questionsModel = QuestionsModel();

//    List sortedList;
    questionsModel.dynamicQuestions.questions
        .sort((a, b) => a.order.compareTo(b.order));
//    print("questionsModel.dynamicQuestions.questions => ${questionsModel.dynamicQuestions.questions}");

    return List<Widget>.generate(
        questionsModel.dynamicQuestions.questions.length, (questionsIndex) {
//          print(questionsModel.dynamicQuestions.questions.length);
//      if (questionsIndex == 0) {
//        return Container(
//          width: 0,
//          height: 0,
//        );
//      } else {
      return _buildQuestionBasedOnType(
          questionsModel.dynamicQuestions.questions[questionsIndex], model);
//      }
    });
  }

  _buildQuestionBasedOnType(Questions aSingleQuestion, ScanModel model) {
    switch (aSingleQuestion.inputControl.type) {
      case "TextBox":
        {

//          print("extraFields.keys.contains(aSingleQuestion.label)=> ${extraFields.keys.contains(aSingleQuestion.label)}");
//          print("aSingleQuestion.label=> ${aSingleQuestion.label}");
//          print("extraFields[aSingleQuestion.label]=> ${extraFields[aSingleQuestion.label]}");

          return Container(
            margin: EdgeInsets.only(top: 25 * ScreenRatio.heightRatio),
            height:
//          orientation == Orientation.portrait
//              ?
                58 * ScreenRatio.heightRatio,
//              : 78 * ScreenRatio.heightRatio,
            child: CustomFormField(
              onTap: () {
//                _scrollController.animateTo(MediaQuery.of(context).size.height,
//                    duration: new Duration(seconds: 1),
//                    curve: Curves.fastOutSlowIn);
              },
              validator: (contentToValidate) {
                print(
                    "content => ${contentToValidate} & ${aSingleQuestion.required}");
                return contentToValidate.isEmpty && aSingleQuestion.required
                    ? "Please enter ${aSingleQuestion.text}"
                    : null;
              },

              onSaved: (answer) {
                print("label=>${aSingleQuestion.label}");
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
            margin: EdgeInsets.only(top: 20 * ScreenRatio.heightRatio),
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
                print("extraFields in yes/no => ${extraFields}");

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
            child: CustomTextFormField(
//              focusNode: notesNodeFocus,
              onTap: () {
//                _scrollController.animateTo(
//                    _scrollController.position.maxScrollExtent,
//                    duration: new Duration(seconds: 1),
//                    curve: Curves.fastOutSlowIn);
              },
              validator: (contentToValidate) {

//                print(
//                    "content => ${contentToValidate} & ${aSingleQuestion.required}");

                return contentToValidate.isEmpty && aSingleQuestion.required
                    ? "Please enter ${aSingleQuestion.text}"
                    : null;
              },
              onSaved: (answer) {
//                model.currentScan.text = answer;
                extraFields.update(aSingleQuestion.label, (oldValue) => answer,
                    ifAbsent: () => answer);
              },
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              initialValue:
              extraFields.keys.contains(aSingleQuestion.label)
                  ? extraFields[aSingleQuestion.label]
                  : null,
//                  model.currentScan.text != "-" ? model.currentScan.text : "",
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
}
