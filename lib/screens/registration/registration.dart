import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
//import 'package:keyboard_visibility/keyboard_visibility.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/components/absorbantButton.dart';
import 'package:standapp/components/animationOpacity.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/customFormField.dart';
import 'package:standapp/components/customOnTapFormField.dart';
import 'package:standapp/components/customTextField.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/data/scoped_model_questions.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/models/user.dart';
import 'package:standapp/services/Api.dart';
import 'package:standapp/services/config.dart';
import 'package:standapp/components/contactCard.dart';
import 'package:standapp/components/settingsCard.dart';
import 'package:standapp/components/tapableCards.dart';

import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

///Prompts the user to enter details related to the user and the company. Based on these, API call is made to obtain a newToken and licenceId which is used later to revoke the licence.
///Based on the API calls made from this and `KeyRegistration` widget screens, user is navigated to either `signUpError` or `Tour` widget screens.

//TODO: Reduce number of lines
class Registration extends StatefulWidget {
  @override
  RegistrationState createState() {
    return new RegistrationState();
  }
}

class RegistrationState extends State<Registration> {
//  KeyboardVisibilityNotification _keyboardVisibility =
//  new KeyboardVisibilityNotification();
  bool _keyboardState;
  int _keyboardVisibilitySubscriberId;
  double textFieldHeight = 85 * ScreenRatio.heightRatio;
  double textHeaderHeight = 250 * ScreenRatio.heightRatio;
  double bottomGap = 249.0;

  bool autoValidate = false;
  bool buttonDisabled;

  ScrollController _scrollController = ScrollController();

  TextEditingController emailFieldController = TextEditingController();
  Widget logo = new SvgPicture.asset(
    'assets/logo_sign.svg',
  );
  final _formKey = GlobalKey<FormState>();
  List<FocusNode> focusNodes = <FocusNode>[];

  @override
  void initState() {
    bottomGap += textFieldHeight * 4;
    for (int i = 0; i < 4; i++) {
      FocusNode aFocusNode = FocusNode();
      focusNodes.add(aFocusNode);
    }

    emailFieldController.addListener(fieldListener);
    super.initState();

//    _keyboardState = _keyboardVisibility.isKeyboardVisible;
//
//    _keyboardVisibilitySubscriberId = _keyboardVisibility.addNewListener(
//      onChange: (bool visible) {
////        setState(() {
////          bottomGap = MediaQuery.of(context).viewInsets.bottom;
////        });
//        print("_keyboardState => ${MediaQuery
//            .of(context)
//            .viewInsets
//            .bottom}");
//      },
//    );
  }

  fieldListener() {
//      print("typing");
    if (emailFieldController.text.length > 0) {
      setState(() {
        buttonDisabled = false;
      });
    } else if (emailFieldController.text.length == 0) {
      setState(() {
        buttonDisabled = true;
      });
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
//    _keyboardVisibility.removeListener(_keyboardVisibilitySubscriberId);
  }

  @override
  Widget build(BuildContext context) {
    print("buttonDisabled => ${buttonDisabled}");
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: ColorConstants.backgroundColors,
      body: OrientationBuilder(builder: (context, orientation) {
        return ScopedModel<KeyRegModel>(
          model: keyRegModel,
          child: Stack(children: <Widget>[
            CustomScrollView(
              controller: _scrollController,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate([
                    SizedBox(
                      height: 42 * ScreenRatio.heightRatio,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 32.0, top: 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            "Registration",
                            style: TextStyles.textStyle32Primary,
                            maxLines: 1,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 12.0),
                            child: Text(
                              "Use the form to sign up.",
                              style: TextStyles.textStyle14Bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 18 * ScreenRatio.heightRatio,
                    ),
                    ScopedModelDescendant<KeyRegModel>(
                        builder: (context, child, model) {
                          return Container(
                            margin: EdgeInsets.only(
                              left: 32.0,
                            ),
//                        height: 128 * ScreenRatio.heightRatio,
                            width: 311 * ScreenRatio.widthRatio,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                Text(
                                  model.apiResponse.data?.companyName,
                                  style: TextStyles.textStyle14Bold,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                          margin: EdgeInsets.only(top: 12),
//                                              width: 50 * ScreenRatio.widthRatio,
//                                              height: 80,
                                          child: Column(
                                            crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: <Widget>[
                                              Text(
                                                "${model.eventForValidKey
                                                    ?.eventName} in ${model
                                                    .eventForValidKey
                                                    ?.venueName}",
//                                                        "Middle East Electricitysdasdsa fdfdfsdgfgfgfhgfhhjhj 2019 in Dubai World Trade Centre",
                                                style: TextStyle(
                                                    fontSize: 18 *
                                                        ScreenRatio.heightRatio,
                                                    color: ColorConstants
                                                        .primaryTextColor,
                                                    fontWeight: FontWeight
                                                        .bold),
                                              ),
                                              Container(
                                                margin: EdgeInsets.only(
                                                  top: 18 *
                                                      ScreenRatio.heightRatio,
                                                ),
                                                child: Text(
                                                  "${dateIntToStringMonth(
                                                      model.eventForValidKey
                                                          ?.eventStartDate
                                                          .month)} ${model
                                                      .eventForValidKey
                                                      ?.eventStartDate
                                                      .day} - ${model
                                                      .eventForValidKey
                                                      ?.eventEndDate
                                                      .day}, ${model
                                                      .eventForValidKey
                                                      ?.eventStartDate.year}",
                                                  style: TextStyles
                                                      .textStyle11w600Secondary,
                                                ),
                                              )
                                            ],
                                          )),
                                    ),
                                    SizedBox(
                                        width: 32 * ScreenRatio.widthRatio),
                                    AnimationOpacity(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            right: 32.0),
                                        child: SizedBox(
                                          width: 64 * ScreenRatio.widthRatio,
                                          height: 64 * ScreenRatio.heightRatio,
                                          child: logo,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        }),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 32,
                        right: 32,
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(
                                  top: 25 * ScreenRatio.heightRatio),
//                              height: orientation == Orientation.portrait
//                                  ? 58 * ScreenRatio.heightRatio
//                                  : 88 * ScreenRatio.heightRatio,
                              child: CustomOnTapTextFormField(
                                onTap: () {
                                  _scrollController.animateTo(textHeaderHeight,
                                      duration: new Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                },
                                focusNode: focusNodes[0],
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[1]);
                                  _scrollController.animateTo(
                                      textHeaderHeight + textFieldHeight,
                                      duration: new Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                },
                                validator: (firstName) => firstName.isEmpty
                                    ? "Enter first name"
                                    : null,
                                onSaved: (firstName) {

                                   keyRegModel.user.ownersName = firstName;
                                },
                                decoration: InputDecoration(
                                  hintText: "First name (required)",
                                  hintStyle: TextStyle(
                                    fontSize: 18 * ScreenRatio.heightRatio,
                                    color: ColorConstants.secondaryTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 18 * ScreenRatio.heightRatio,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 10 * ScreenRatio.heightRatio),
//                              height: orientation == Orientation.portrait
//                                  ? 58 * ScreenRatio.heightRatio
//                                  : 88 * ScreenRatio.heightRatio,
                              child: CustomOnTapTextFormField(
                                onTap: () {
                                  _scrollController.animateTo(
                                      textHeaderHeight + textFieldHeight,
                                      duration: new Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                },
                                focusNode: focusNodes[1],
                                onEditingComplete: () {
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[2]);
//                                  _scrollController.animateTo(
//                                      0,
//                                      duration: new Duration(seconds: 1),
//                                      curve: Curves.fastOutSlowIn);
                                },
                                validator: (lastName) =>
                                lastName.isEmpty ? "Enter last name" : null,
                                onSaved: (lastName) =>
                                keyRegModel.user.ownersName =
                                    keyRegModel.user.ownersName +
                                        " ${lastName}",
                                decoration: InputDecoration(
                                  hintText: "Last name (required)",
                                  hintStyle: TextStyle(
                                    fontSize: 18 * ScreenRatio.heightRatio,
                                    color: ColorConstants.secondaryTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 18 * ScreenRatio.heightRatio,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 25 * ScreenRatio.heightRatio),
//                              height: orientation == Orientation.portrait
//                                  ? 58 * ScreenRatio.heightRatio
//                                  : 88 * ScreenRatio.heightRatio,
                              child: CustomOnTapTextFormField(
                                onTap: () {
                                  _scrollController.animateTo(
                                      textHeaderHeight + (textFieldHeight),
                                      duration: new Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                },
                                focusNode: focusNodes[2],
                                controller: emailFieldController,
                                keyboardType: TextInputType.emailAddress,
                                onEditingComplete: () {
//                                  _scrollController.animateTo(
//                                      0,
//                                      duration: new Duration(seconds: 1),
//                                      curve: Curves.fastOutSlowIn);
                                  setState(() {
                                    buttonDisabled = true;
                                  });
                                  FocusScope.of(context)
                                      .requestFocus(focusNodes[3]);
                                },
                                validator: (email) =>
                                RegExp(
                                    r"^(?=.{1,254}$)(?=.{1,64}@)[-!#$%&'*+/0-9=?A-Z^_`a-z{|}~]+(\.[-!#$%&'*+/0-9=?A-Z^_`a-z{|}~]+)*@[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?(\.[A-Za-z0-9]([A-Za-z0-9-]{0,61}[A-Za-z0-9])?)*$")
                                    .hasMatch(email)
                                    ? null
                                    : "Enter valid Email address",
                                onSaved: (email) =>
                                keyRegModel.user.deviceId = email,
                                decoration: InputDecoration(
                                  hintText: "Email (required)",
                                  hintStyle: TextStyle(
                                    fontSize: 18 * ScreenRatio.heightRatio,
                                    color: ColorConstants.secondaryTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),

                                ),
                              ),
                            ),
                            SizedBox(
                              height: 18 * ScreenRatio.heightRatio,
                            ),
                            Container(
                              margin: EdgeInsets.only(
                                  top: 25 * ScreenRatio.heightRatio),
//                              height: orientation == Orientation.portrait
//                                  ? 58 * ScreenRatio.heightRatio
//                                  : 88 * ScreenRatio.heightRatio,
                              child:
//                              CustomTextField(
//                                focusNode: focusNodes[3],
//                                onEditingComplete: () {
//                                  print("here");
//
//                                  FocusScope.of(context)
//                                      .requestFocus(FocusNode());
//                                },
//                                onChanged: (currentNumber){
//                                  if(currentNumber.length>0){
//                                    setState(() {
//                                      buttonDisabled = false;
//                                    });
//                                  }else if(currentNumber.length == 0){
//                                    setState(() {
//                                      buttonDisabled = true;
//                                    });
//                                  }
//                                },
//                                hintText: "Phone number",
//                                textSize: 18 * ScreenRatio.heightRatio,
//                                textInputType: TextInputType.numberWithOptions(
//                                    signed: true),
//                              ),
                              CustomOnTapTextFormField(
                                focusNode: focusNodes[3],

                                onTap: () {
                                  _scrollController.animateTo(
                                      textHeaderHeight + (textFieldHeight),
                                      duration: new Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                },

                                onEditingComplete: () {
//                                  setState(() {
//                                    buttonDisabled = true;
//                                  });
                                  _scrollController.animateTo(0,
                                      duration: new Duration(seconds: 1),
                                      curve: Curves.fastOutSlowIn);
                                  FocusScope.of(context)
                                      .requestFocus(FocusNode());
//                                  phoneNumberFieldController.removeListener(fieldListener);
                                },
//                              validator: (phone) =>
//                              phone.isEmpty ? "Enter phone number" : null,
                                keyboardType: TextInputType.numberWithOptions(
                                    signed: true),
                                onSaved: (phoneNumber) =>
                                keyRegModel.user.phoneNumber = phoneNumber,
                                decoration: InputDecoration(
                                  hintText: "Phone number",
                                  hintStyle: TextStyle(
                                    fontSize: 18 * ScreenRatio.heightRatio,
                                    color: ColorConstants.secondaryTextColor,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 30 * ScreenRatio.heightRatio,
                            )
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                      EdgeInsets.only(left: 32.0, right: 32, bottom: 42),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          CircularButton(
//                          heroTag: "3",

                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            backgroundColor: Colors.white,
                            icon: 'assets/icon_footer_back.svg',
                          ),
                          ScopedModelDescendant<KeyRegModel>(
                              builder: (context, child, model) {
                                return AbsorbantButton(
                                  disabled: buttonDisabled ?? true,
                                  color: ColorConstants.primaryTextColor,
                                  label: "SIGN UP",
                                  width: 121 * ScreenRatio.widthRatio,
                                  onPressed: () async {
//                                setState(() {
//                                  buttonDisabled = true;
//                                });

                                    if (_formKey.currentState.validate()) {
                                      _formKey.currentState.save();

                                      await model
                                          .fetchNewToken(model.user.toJson());

                                      if (model.apiResponse.error == null) {
                                        if (prefs == null) {
                                          prefs =
                                          await SharedPreferences.getInstance();
                                        }
                                        prefs.setBool("guest", false);

                                        await questionsModel.fetchQuestions();

                                        prefs.setString(
                                            "questions",
                                            json.encode(questionsModel
                                                .dynamicQuestions
                                                .toJson()));

//                                    setState(() {
//                                      buttonDisabled = false;
//                                    });
                                        Navigator.of(context)
                                            .pushNamedAndRemoveUntil("/Tour",
                                                (
                                                Route<dynamic> route) => false);
                                      } else {
                                        if (model.apiResponse.error ==
                                            "Connect to the Internet and try again.") {
//                                      setState(() {
//                                        buttonDisabled = false;
//                                      });
                                          Scaffold.of(context).showSnackBar(
                                              SnackBar(
                                                  content: Text(
                                                      model.apiResponse
                                                          .error)));
                                        } else {
                                          Navigator.of(context)
                                              .pushNamed("/signUpError");
                                        }
                                      }
                                    }
                                  },
                                );
                              }),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: bottomGap * ScreenRatio.heightRatio,
                    ),
                  ]),
                ),
              ],
            ),
//            Padding(
//              padding: EdgeInsets.only(
//                  left: 32.0,
//                  right: 32,
//                  top: MediaQuery.of(context).size.height - 70),
//              child: Row(
//                mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                children: <Widget>[
//                  CircularButton(
////                          heroTag: "3",
//
//                    onPressed: () {
//                      Navigator.of(context).pop();
//                    },
//                    backgroundColor: Colors.white,
//                    icon: 'assets/icon_footer_back.svg',
//                  ),
//                  ScopedModelDescendant<KeyRegModel>(
//                      builder: (context, child, model) {
//                    return AbsorbantButton(
//                      disabled: buttonDisabled,
//                      color: ColorConstants.primaryTextColor,
//                      label: "SIGN UP",
//                      width: 121* ScreenRatio.widthRatio,
//                      onPressed: () async {
//
//                      if (_formKey.currentState.validate()) {
//                        _formKey.currentState.save();
//
//                        await model.fetchNewToken(model.user.toJson());
//
//                        if (model.apiResponse.error == null) {
//
//                          if (prefs == null) {
//                            prefs = await SharedPreferences.getInstance();
//                          }
//                          prefs.setBool("guest", false);
//
//                          Navigator.of(context).pushNamedAndRemoveUntil(
//                              "/Tour", (Route<dynamic> route) => false);
//                        } else {
//                          if(model.apiResponse.error == "Connect to the Internet and try again.") {
//                            Scaffold.of(context).showSnackBar(
//                                SnackBar(
//                                    content: Text(model.apiResponse.error)));
//                          }else{
//                            Navigator.of(context).pushNamed("/signUpError");
//                          }
//                        }
//                      }
//                      },
//                    );
//                  }),
//                ],
//              ),
//            ),
          ]),
        );
      }),
    );
  }
}
