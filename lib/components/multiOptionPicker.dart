import 'package:flutter/material.dart';
import 'package:standapp/components/customAlertBox.dart';
import 'package:standapp/components/customFormField.dart';
import 'package:standapp/models/dynamicQuestions.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

typedef onSavedCallback = Function(String,String);
typedef validatorCallback = Function(String);




const double _kPickerItemHeight = 25.0;
const double _kPickerSheetHeight = 216.0;



class MultiOptionPickerField extends StatefulWidget {
  Function onTap;
  onSavedCallback onSaved;
  String initialValue ='';
  List pickerData;
  Questions question;
  String label;



  MultiOptionPickerField({this.onTap,this.onSaved,this.initialValue,this.pickerData,this.question,this.label});
  @override
  MultiOptionPickerFieldState createState() {
    return new MultiOptionPickerFieldState();
  }
}

class MultiOptionPickerFieldState extends State<MultiOptionPickerField> {
  int selectedItemIndex = -1;
  bool focus = false;
  var pickerResult;
  String resultString ='';
  List<String> optionsFromInitValue = <String>[];

  bool validateSuccessful = true;

  @override
  void initState() {

    if(widget.initialValue!=null) {
      resultString = widget.initialValue;
      optionsFromInitValue = widget.initialValue.split(",");
    }
    print("widget.initialValue => ${widget.initialValue}");

    print("widget.optionsFromInitValue 1 => ${optionsFromInitValue}");

    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () async {
        print("form tapped");
//        widget.onTap();
        print("widget.optionsFromInitValue 2 => ${optionsFromInitValue}");

        setState(() {
          focus = true;
        });
        pickerResult =  await showDialog<dynamic>(
            context: context,
            builder: (BuildContext context) {

              return CustomAlertBox(pickerData:widget.pickerData,optionsFromInitValue: optionsFromInitValue);
            });
        print("pickerResult = >${pickerResult}");
        if(pickerResult!=null){
          setState(() {
            resultString = pickerResult;
            optionsFromInitValue = resultString.split(",");
            focus = false;

          });
        }else{
          setState(() {
            focus = false;
          });
        }
        },
      behavior: HitTestBehavior.opaque,
      child:
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child:
            CustomFormField(
              validator: (contentToValidate) {
                contentToValidate = resultString;
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
//              labelText: widget.label,
              showBorder: false,
              enabled: false,
              onSaved: (levelOfInterest) {
                widget.onSaved(widget.question.label,resultString);
              },
              hintText: resultString.isEmpty?widget.question.text:resultString,
              textSize: 18 * ScreenRatio.heightRatio,
//              initialValue: widget.initialValue!=null?widget.initialValue:"",
            ),
          ),
          validateSuccessful ? Container(
            color: focus ? ColorConstants.primaryTextColor : Colors.black45,
            height: 1,
          ) : Container(
            color: Colors.red[800],
            height: 1,
          ),
          validateSuccessful ? Container(width: 0, height: 0,) : Text(
            "Mandatory: Pick an answer",
            style: TextStyle(color: Colors.red[800]),),
        ],
      ),
    );
  }








}
