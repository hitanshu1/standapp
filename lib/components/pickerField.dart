import 'package:flutter/material.dart';
import 'package:standapp/components/customFormField.dart';
import 'package:standapp/models/dynamicQuestions.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';

typedef onSavedCallback = Function(String, String);
typedef validatorCallback = Function(String);

//List pickerData = [
//  {"label": "Strong", "value": "strong", "order": 0},
//  {"label": "Moderate", "value": "moderate", "order": 1},
//  {"label": "Low", "value": "low", "order": 2}
//];
const double _kPickerItemHeight = 25.0 ;
 double _kPickerSheetHeight = 216.0 * ScreenRatio.heightRatio;

class PickerField extends StatefulWidget {
  Function onTap;
  onSavedCallback onSaved;
  String initialValue = '';
  List pickerData;
  Questions question;
  String label;


  PickerField(
      {this.onTap,
      this.onSaved,
      this.initialValue,
      this.pickerData,
      this.question,
      this.label});
  @override
  PickerFieldState createState() {
    return new PickerFieldState();
  }
}

class PickerFieldState extends State<PickerField> {
  int selectedItemIndex = -1;
  bool focus = false;

  bool validateSuccessful = true;


  Widget _buildBottomPicker(Widget picker) {

    return Container(
      height: _kPickerSheetHeight,
//      padding: const EdgeInsets.only(top: 6.0),
      color: CupertinoColors.white,
      child: DefaultTextStyle(
        style: const TextStyle(
          color: CupertinoColors.black,
          fontSize: 22.0,
        ),
        child: GestureDetector(
          // Blocks taps from propagating to the modal sheet and popping.
          onTap: () {},
          child: SafeArea(
            top: false,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                    alignment: Alignment.centerRight,
                    width: MediaQuery.of(context).size.width,
                    height: 40 * ScreenRatio.heightRatio,
                    child: FlatButton(
                        onPressed: () {
                          setState(() {
                            focus = false;
                          });
                          selectedItemIndex==-1?selectedItemIndex=0:null;
                          Navigator.of(context).pop(selectedItemIndex);
                        },
                        child: Text(
                          "Done",
                          style: TextStyles.textStyle18BoldPrimary,
                        ))),
                Expanded(child: picker),
              ],
            ),
          ),
        ),
      ),
    );
  }

  FixedExtentScrollController scrollController ;

  @override
  void initState() {
    print("widget.initialValue => ${widget.initialValue}");

    if (widget.initialValue != null) {
      widget.pickerData.asMap().forEach((index, eachOption) {
        if (eachOption['value'] == widget.initialValue) {
          print(index);

          selectedItemIndex = index;
        }
      });
    }
    print("selectedItemIndex 0 => ${selectedItemIndex}");
    scrollController =
        FixedExtentScrollController(initialItem: selectedItemIndex);
    super.initState();
  }



  @override
  Widget build(BuildContext context) {
    TextEditingController pickerFieldController = TextEditingController();
    return GestureDetector(
      onTap: () async {
//        print("form tapped");

        var tappedDone;
        widget.onTap();
//        if (widget.initialValue != null) {
//          widget.pickerData.asMap().forEach((index, eachOption) {
//            if (eachOption['label'] == widget.initialValue) {
//              print(index);
//
//              selectedItemIndex = index;
//            }
//          });
//        }
//        print("selectedItemIndex 1 => ${selectedItemIndex}");
//        scrollController.animateToItem(
//            selectedItemIndex,
//            duration: new Duration(seconds: 2),
//            curve: Curves.fastOutSlowIn
//        );
        setState(() {
          focus = true;
        });
//        scrollController =
//            FixedExtentScrollController(initialItem: selectedItemIndex);

        tappedDone = await showCupertinoModalPopup<int>(
            context: context,
            builder: (BuildContext context) {
              return _buildBottomPicker(
                CupertinoPicker(
                scrollController: scrollController,

                  itemExtent: _kPickerItemHeight,
                  backgroundColor: CupertinoColors.white,
                  onSelectedItemChanged: (int index) {
                    pickerFieldController.text = selectedItemIndex != -1
                        ? widget.pickerData[selectedItemIndex]["label"]
                        : "";
                    setState(() => selectedItemIndex = index);
                  },
                  children: List<Widget>.generate(widget.pickerData.length,
                      (int index) {
                    return Center(
                      child: Text(widget.pickerData[index]["label"]),
                    );
                  }),
                ),
              );
            });
        tappedDone==null?setState(() {
          focus = false;
        }):null;
      },
      behavior: HitTestBehavior.opaque,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
//          focus
//              ? Text(
//                  widget.question.label,
//                  style: TextStyle(
//                      fontSize: 14 * ScreenRatio.heightRatio,
//                      color: ColorConstants.lightBlack),
//                )
//              : Container(
//                  width: 0,
//                  height: 0,
//                ),
          Expanded(
            child: CustomFormField(
//              labelText: widget.label,

              showBorder: false,
//              labelText: selectedItemIndex != -1
//                  ?  widget.pickerData[selectedItemIndex]["label"]
//                  : null,
              enabled: false,
              validator: (contentToValidate) {
                contentToValidate = selectedItemIndex != -1
                    ? widget.pickerData[selectedItemIndex]["value"]
                    : "";
                print(
                    "content => ${contentToValidate.isEmpty} & ${widget.question
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
              onSaved: (levelOfInterest) {
//                String answer = '';
//                if(selectedItemIndex!=-1){
//                  answer = widget.pickerData[selectedItemIndex]["label"];
//                }


                widget.onSaved(
                    widget.question.label,
                    selectedItemIndex != -1
                        ? widget.pickerData[selectedItemIndex]["value"]
                        : "");
              },
              hintText: selectedItemIndex != -1
                  ? widget.pickerData[selectedItemIndex]["label"]
                  : widget.question.text,
//              initialValue: widget.initialValue==null?null:widget.initialValue,
              textSize: 18 * ScreenRatio.heightRatio,
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
