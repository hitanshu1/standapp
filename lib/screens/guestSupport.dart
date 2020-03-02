import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:standapp/components/absorbantButton.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/customFormField.dart';
import 'package:standapp/components/customTextField.dart';
import 'package:standapp/data/scoped_model_support.dart';
import 'package:standapp/models/supportForm.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class GuestSupport extends StatefulWidget {
  @override
  GuestSupportState createState() {
    return new GuestSupportState();
  }
}

class GuestSupportState extends State<GuestSupport> {
  Map supportForm = {};

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return ScopedModel<SupportModel>(
        model: supportModel,
        child: Form(
          key: _formKey,
          child: Container(
            padding: EdgeInsets.fromLTRB(32 * ScreenRatio.widthRatio,
                50 * ScreenRatio.heightRatio, 32 * ScreenRatio.widthRatio, 0),
            child: ListView(
              //crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Support",
                  style: TextStyles.textStyle32Primary,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Text(
                    "Use the form below to submit a support request.",
                    style: TextStyles.textStyle14Bold,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32 * ScreenRatio.heightRatio),
                  height: orientation == Orientation.portrait
                      ? 58 * ScreenRatio.heightRatio
                      : 78 * ScreenRatio.heightRatio,
                  child: CustomFormField(
                    hintText: "Name",
                    textSize: 18,
                    onSaved: (name) {
                      supportForm["Name"] = name;
                    },
                    validator: (name) => name.isEmpty ? "Enter name" : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32 * ScreenRatio.heightRatio),
                  height: orientation == Orientation.portrait
                      ? 58 * ScreenRatio.heightRatio
                      : 78 * ScreenRatio.heightRatio,
                  child: CustomFormField(
                    hintText: "Company",
                    textSize: 18,
                    onSaved: (company) {
                      supportForm["Company"] = company;
                    },
                    validator: (name) =>
                        name.isEmpty ? "Enter Company name" : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32 * ScreenRatio.heightRatio),
                  height: orientation == Orientation.portrait
                      ? 58 * ScreenRatio.heightRatio
                      : 78 * ScreenRatio.heightRatio,
                  child: CustomFormField(
                    hintText: "Email address",
                    textSize: 18,
                    onSaved: (mail) {
                      supportForm["emailAddress"] = mail;
                    },
                    validator: (name) =>
                        name.isEmpty ? "Enter email address" : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32 * ScreenRatio.heightRatio),
                  height: orientation == Orientation.portrait
                      ? 58 * ScreenRatio.heightRatio
                      : 78 * ScreenRatio.heightRatio,
                  child: CustomFormField(
                    hintText: "Phone number",
                    textSize: 18,
                    onSaved: (phone) {
                      supportForm["phoneNumber"] = phone;
                    },
                    validator: (name) =>
                        name.isEmpty ? "Enter Phone number" : null,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32 * ScreenRatio.heightRatio),
//            height:
////              orientation == Orientation.portrait
////                  ?
//                58 * ScreenRatio.heightRatio,
//                  : 78 * ScreenRatio.heightRatio,
                  child: TextFormField(
//              focusNode: notesNodeFocus,
                    onSaved: (answer) {
                      supportForm["notes"] = answer;
                    },
                    validator: (name) =>
                        name.isEmpty ? "Add a note to this message" : null,
                    keyboardType: TextInputType.multiline,
                    maxLines: 5,
                    style: TextStyles.textStyle14Black,
                    decoration: InputDecoration(
//                contentPadding: EdgeInsets.only(
//                  bottom: 100 * ScreenRatio.heightRatio,
//                ),
                      border: UnderlineInputBorder(
                        borderSide: BorderSide(
                            width: 2.0, color: ColorConstants.primaryTextColor),
                      ),
                      hintText: "Add Notes",
                      hintStyle: TextStyle(
                        fontSize: 18 * ScreenRatio.heightRatio,
                        color: ColorConstants.secondaryTextColor,
                        fontWeight: FontWeight.w400,
                      ),
//                labelText: aSingleQuestion.label,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 12.0,bottom: 12,left: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircularButton(
                        heroTag: "4",
                        icon: ImageConstants.close,
                        backgroundColor: Colors.white,
                        iconcolor: Colors.black,
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      ScopedModelDescendant<SupportModel>(
                        builder: (context, child, model) {
                          return AbsorbantButton(
                            width: 190 * ScreenRatio.widthRatio,
                            //shadow: true,
                            label: "SUBMIT REQUEST",
                            color: ColorConstants.primaryTextColor,
                            disabled: false,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.save();

                                  await model.submitForm(supportForm);

                                  if (model.apiResponse.error == null) {
                                    Navigator.of(context).pop();
                                  } else {
                                    Scaffold.of(context).showSnackBar(SnackBar(
                                        content:
                                            Text(model.apiResponse.error)));
                                  }
                              }
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
        ),
      );
    }));
  }
}
