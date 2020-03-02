import 'package:flutter/material.dart';
import 'package:standapp/components/customAlertBox.dart';
import 'package:standapp/components/customFormField.dart';
import 'package:standapp/models/dynamicQuestions.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

typedef onSavedCallback = Function(String, String);
typedef validatorCallback = Function(String);

List pickerData = [
  {
    "label": "Select consecutive days",
    "options": [
      "Every day",
      "Mon",
      "Tue",
      "Wed",
      "Thur",
      "Friday",
      "Saturday",
      "Sunday"
    ]
  },
];
const double _kPickerItemHeight = 25.0;
const double _kPickerSheetHeight = 216.0;

class BooleanQuestion extends StatefulWidget {
  Function onTap;
  onSavedCallback onSaved;
  bool initialValue = false;
  String label = '';
  Questions question;

  BooleanQuestion({this.onTap,
    this.onSaved,
    this.initialValue,
    this.label,
    this.question});
  @override
  BooleanQuestionState createState() {
    return new BooleanQuestionState();
  }
}

class BooleanQuestionState extends State<BooleanQuestion> {
  int _radioValue = 3;
  bool validateSuccessful = true;
  bool selectedYes;

  @override
  void initState() {

    selectedYes = widget.initialValue;

    if (selectedYes != null) {
      _radioValue = selectedYes ? 0 : 1;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {},
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
//        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: CustomFormField(
              validator: (contentToValidate) {
                contentToValidate = selectedYes != null
                    ? (selectedYes ? "Yes" : "No")
                    : "";
                print("content => ${contentToValidate} & ${widget.question
                    .required}");

                if (contentToValidate.isEmpty && widget.question.required) {
                  setState(() {
                    validateSuccessful = false;
                  });
                  return "";
                } else {
                  setState(() {
                    validateSuccessful = true;
                  });
                  return null;
                }
              },
              showBorder: false,
              enabled: false,
              onSaved: (levelOfInterest) {
                if (selectedYes != null) {
                  print("executed here0");

                  widget.onSaved(
                      widget.question.label, selectedYes ? "Yes" : "No");
                } else {
                  print("executed here1");
                  widget.onSaved(widget.question.label, "");
                }
              },
              hintText:
              widget.label.isEmpty ? "Boolean Question" : (validateSuccessful
                  ? widget.label
                  : (widget.label + "*")),
              hintStyle: validateSuccessful ? TextStyle(
                fontSize: 18 * ScreenRatio.heightRatio,
                color: ColorConstants.secondaryTextColor,
                fontWeight: FontWeight.w400,
              ) : TextStyle(
                fontSize: 18 * ScreenRatio.heightRatio,
                color: Colors.red,
                fontWeight: FontWeight.w400,
              ),
              textSize: 18 * ScreenRatio.heightRatio,
            ),
          ),
//            SizedBox(height: 30,),
          Padding(
            padding: EdgeInsets.only(top: 14.0 * ScreenRatio.heightRatio),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Expanded(
                  child: RadioListTile(
                    value: 0,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                    activeColor: ColorConstants.primaryTextColor,
                    title: Text("Yes"),
                  ),
                ),
//                Text("Yes"),
                Expanded(
                  child: RadioListTile(
                    value: 1,
                    groupValue: _radioValue,
                    onChanged: _handleRadioValueChange,
                    activeColor: ColorConstants.primaryTextColor,
                    title: Text("No"),
                  ),
                ),
              ],
            ),
          ),
//          Container(color: focus? ColorConstants.primaryTextColor:Colors.black45,height: 1,)
        ],
      ),
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;

      switch (_radioValue) {
        case 0:
          selectedYes = true;
          break;
        case 1:
          selectedYes = false;
          break;
      }
    });
    print(selectedYes);
  }
}
