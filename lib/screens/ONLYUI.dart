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
import 'package:standapp/components/pickerField.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:standapp/data/scoped_model_questions.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/data/scoped_model_upload.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/dynamicQuestions.dart';
import 'package:standapp/models/extraFields.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/animation.dart';

double height;
double width;

class UIAddBadge extends StatefulWidget {
  bool buttonDisabled = false;

  @override
  UIAddBadgeState createState() {
    return new UIAddBadgeState();
  }
}

class UIAddBadgeState extends State<UIAddBadge>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController controller;
  ScrollController _scrollController = new ScrollController();

  FocusNode notesNodeFocus = FocusNode();

  final _formKey = GlobalKey<FormState>();

  Map extraFields = {};

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

    scanModel.currentScan = Scan(
        barCode: "MEED - 46509",
        eEmbed: Embed(
            visitor: Visitor(
              fullName: "Billy Anderson",
              jobTitle: "Vice President",
              company: "Panasonic Corporation",
              email: "billy.a@email.com",
            )));
//    print(
//        "scanModel.currentScan.extraFields => ${scanModel.currentScan.extraFields}");
//
//    if (scanModel.currentScan.extraFields != null) {
//      print(
//          "double decoded => ${json.decode(scanModel.currentScan.extraFields)}");
//      extraFields = json.decode(scanModel.currentScan.extraFields);
//    }
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
                controller: _scrollController,
                cacheExtent: 500,
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
                                        online: false,
                                      ),
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
                ],
              );
            },
          ),
        ),
      ),
    );
  }


//  _buildQuestionsSection(ScanModel model) {
//    return List<Widget>.generate(
//        questionsModel.dynamicQuestions.questions.length, (questionsIndex) {
////          print(questionsModel.dynamicQuestions.questions.length);
//      if (questionsIndex == 0) {
//        return Container(
//          width: 0,
//          height: 0,
//        );
//      } else {
//        return _buildQuestionBasedOnType(
//            questionsModel.dynamicQuestions.questions[questionsIndex]);
//      }
//    });
//  }

//  _buildQuestionBasedOnType(Questions aSingleQuestion) {
//    switch (aSingleQuestion.inputControl.type) {
//      case "TextBox":
//        {
//          return Container(
//            margin: EdgeInsets.only(top: 25 * ScreenRatio.heightRatio),
//            height:
////          orientation == Orientation.portrait
////              ?
//            58 * ScreenRatio.heightRatio,
////              : 78 * ScreenRatio.heightRatio,
//            child: CustomFormField(
////                                  validator: (salesPerson) =>
////                                  salesPerson.isEmpty ? "Enter salesPerson" : null,
//
//              onSaved: (answer) {
////                extraFields.putIfAbsent(question.label, ()=>answer);
//                extraFields.update(aSingleQuestion.label, (oldValue) => answer,
//                    ifAbsent: () => answer);
//
////                extraFields.salesPerson = salesPerson.isEmpty?"Select":salesPerson;
////              print("exta=> ${extraFields}");
//              },
////                            onSaved: (salesPerson) =>
////                                model.currentScan.salesPerson = salesPerson,
//              hintText: aSingleQuestion.label,
//              initialValue: extraFields.keys.contains(aSingleQuestion.label)
//                  ? extraFields[aSingleQuestion.label]
//                  : null,
//              textSize: 18 * ScreenRatio.heightRatio,
//            ),
//          );
//        }
//        break;
//
//      case "SingleComboBox":
//        {
//          return Container(
//            margin: EdgeInsets.only(top: 25 * ScreenRatio.heightRatio),
//            height:
////          orientation == Orientation.portrait
////              ?
//            58 * ScreenRatio.heightRatio,
////              : 78 * ScreenRatio.heightRatio,
//            child: PickerField(
//              onTap: () {
////                _scrollController.animateTo(
////                    _scrollController.position.maxScrollExtent,
////                    duration: new Duration(seconds: 1),
////                    curve: Curves.fastOutSlowIn);
//              },
//              pickerData: aSingleQuestion.inputControl.options,
//              initialValue: extraFields.keys.contains(aSingleQuestion.label)
//                  ? extraFields[aSingleQuestion.label]
//                  : null,
//              question: aSingleQuestion,
//              onSaved: (question, answer) {
//                extraFields.update(question, (oldValue) => answer,
//                    ifAbsent: () => answer);
//              },
//            ),
//          );
//        }
//        break;
//
//      case "MultiComboBox":
//        {
//          return Container(
//            margin: EdgeInsets.only(top: 150 * ScreenRatio.heightRatio),
//            height:
////          orientation == Orientation.portrait
////              ?
//            58 * ScreenRatio.heightRatio,
////              : 78 * ScreenRatio.heightRatio,
//            child: MultiOptionPickerField(
//              initialValue: extraFields.keys.contains(aSingleQuestion.label)
//                  ? extraFields[aSingleQuestion.label]
//                  : null,
//              pickerData: [
//                {
//                  "label": aSingleQuestion.label,
//                  "options": aSingleQuestion.inputControl.options
//                }
//              ],
//              question: aSingleQuestion,
//              onSaved: (question, answer) {
//                extraFields.update(question, (oldValue) => answer,
//                    ifAbsent: () => answer);
//              },
//            ),
//          );
//        }
//        break;
//
//      case "YesNo":
//        {
//          return Container(
//            margin: EdgeInsets.only(top: 15 * ScreenRatio.heightRatio),
//            height:
////          orientation == Orientation.portrait
////              ?
//            78 * ScreenRatio.heightRatio,
////              : 78 * ScreenRatio.heightRatio,
//            child: BooleanQuestion(
//              question: aSingleQuestion,
//              label: aSingleQuestion.label,
//              selectedYes: extraFields.keys.contains(aSingleQuestion.label)
//                  ? (extraFields[aSingleQuestion.label] == "Yes" ? true : false)
//                  : null,
//              onSaved: (question, answer) {
//                extraFields.update(question, (oldValue) => answer,
//                    ifAbsent: () => answer);
//              },
////            selectedYes: true,
//            ),
//          );
//        }
//        break;
//
//      case "TextArea":
//        {
//          return Container(
//            margin: EdgeInsets.only(top: 25 * ScreenRatio.heightRatio),
//            height:
////              orientation == Orientation.portrait
////                  ?
//            58 * ScreenRatio.heightRatio,
////                  : 78 * ScreenRatio.heightRatio,
//            child: TextFormField(
//              focusNode: notesNodeFocus,
//              onSaved: (answer) {
//                extraFields.update(aSingleQuestion.label, (oldValue) => answer,
//                    ifAbsent: () => answer);
//              },
//              keyboardType: TextInputType.text,
//              maxLines: 5,
//              initialValue: extraFields.keys.contains(aSingleQuestion.label)
//                  ? extraFields[aSingleQuestion.label]
//                  : null,
//              style: TextStyles.textStyle14Black,
//              decoration: InputDecoration(
//                contentPadding: EdgeInsets.only(
//                  bottom: 100 * ScreenRatio.heightRatio,
//                ),
//                border: UnderlineInputBorder(
//                  borderSide: BorderSide(
//                      width: 2.0, color: ColorConstants.primaryTextColor),
//                ),
//                hintText: "Add notes",
//                hintStyle: TextStyle(
//                  fontSize: 18,
//                  color: ColorConstants.secondaryTextColor,
//                  fontWeight: FontWeight.w400,
//                ),
//              ),
//            ),
//          );
//        }
//        break;
//      default:
//        {
//          //statements;
//        }
//        break;
//    }
//  }

  _handleScan(UploadModel model, context, Scan scan) async {
//    print("here");
//  scan.conversationAt = DateTime.now().toUtc().toString();
    await model.uploadScan(scan);

    if (model.apiResponseForScanDetails.error == null) {
      Navigator.of(context).pop();
    } else {
      if (model.apiResponseForScanDetails.error ==
          "Connect to the Internet and try again.") {
        String apiTokenWithLicenceString =
        prefs.getString("apiTokenWithLicence");
        ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

        String token;
        String conversationsLink;

        if (apiTokenWithLicenceString != null) {
          apiTokenWithLicence = ApiTokenWithLicence.fromJson(
              json.decode(apiTokenWithLicenceString));
          token = apiTokenWithLicence.newToken;
          conversationsLink = apiTokenWithLicence.conversationsLink;
        }

        scan.uploaded = false;
        scanModel.updateScanLocallyAndModel(scan: scan, user: "user");
        setState(() {
          widget.buttonDisabled = true;
        });
        Navigator.of(context).pop();
      } else {
        Scaffold.of(context).showSnackBar(
            SnackBar(content: Text(model.apiResponseForScanDetails.error)));
      }
    }
  }
}
