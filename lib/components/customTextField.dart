import 'package:flutter/material.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/services.dart';
typedef onChangedCallback = Function(String);

class CustomTextField extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  double width;
  double textSize;
  TextInputType textInputType;
  Function onTap;
  Function onEditingComplete;
  FocusNode focusNode;
  var maxLength;
  bool maxLengthEnforced;
  TextInputFormatter textInputFormatter;
  bool autoFocus;
  bool paddingBottom;

  String labelText;

  List<TextInputFormatter> inputFormatters = <TextInputFormatter>[];

  onChangedCallback onChanged;

  CustomTextField(
      {this.controller,
      this.hintText,
      this.width,
      this.textSize,
      this.textInputType,
      this.onTap,
      this.onEditingComplete,
      this.focusNode,
      this.maxLength,
      this.maxLengthEnforced,
      this.textInputFormatter,
        this.labelText ="",
      this.paddingBottom = true,
      this.autoFocus = false,this.onChanged,this.inputFormatters});

  @override
  Widget build(BuildContext context) {
//    ScreenRatio.setScreenRatio(
//        currentScreenHeight: MediaQuery.of(context).size.height,
//        currentScreenWidth: MediaQuery.of(context).size.width);
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      child: Theme(
        data: ThemeData(
            splashColor: Colors.transparent,
            primaryColor: ColorConstants.primaryTextColor),
        child: TextField(
            cursorColor: ColorConstants.primaryTextColor,
            inputFormatters: inputFormatters,
            autofocus: autoFocus ?? false,
            keyboardType: textInputType ?? TextInputType.text,
//          inputFormatters: [textInputFormatter],
            maxLength: maxLength,
            onChanged: onChanged,
            maxLengthEnforced: maxLengthEnforced ?? false,
            // focusNode: focusNode,
            onEditingComplete: onEditingComplete,
            onTap: onTap,
            style: TextStyles.textStyle18InputText,
            decoration: InputDecoration(
              contentPadding:
                  EdgeInsets.only(bottom: paddingBottom ? 15.0 : 150),
              border: UnderlineInputBorder(
                borderSide: BorderSide(
                    width: 2.0, color: ColorConstants.primaryTextColor),

//            borderRadius: BorderRadius.circular(3.0),
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                fontSize: 18* ScreenRatio.heightRatio,
                color: ColorConstants.secondaryTextColor,
                fontWeight: FontWeight.w400,
              ),
//                labelText: labelText,
            ),
            controller: controller),
      ),
    );
  }
}
