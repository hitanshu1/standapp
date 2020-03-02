import 'package:flutter/material.dart';
import 'package:standapp/components/customFlutterTextFormField.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/services.dart';

typedef onSavedCallback = Function(String);
typedef validatorCallback = Function(String);

class CustomFormField extends StatelessWidget {
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
  onSavedCallback onSaved;
  validatorCallback validator;
  bool enabled = true;
  String labelText;
  bool autoValidate = false;


  bool showBorder = true;

  TextStyle hintStyle;





  String initialValue;
  CustomFormField(
      {this.controller,
        this.hintStyle,
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
      this.paddingBottom = true,
      this.autoFocus = false,
      this.onSaved,
      this.validator,
      this.initialValue,
        this.enabled = true,
        this.labelText,
        this.showBorder = true,
        this.autoValidate = false
      });

  @override
  Widget build(BuildContext context) {
//    ScreenRatio.setScreenRatio(
//        currentScreenHeight: MediaQuery.of(context).size.height,
//        currentScreenWidth: MediaQuery.of(context).size.width);
    return SizedBox(
      width: width ?? MediaQuery.of(context).size.width,
      child: CustomTextFormField(

        onTap: onTap??(){},
        autovalidate: autoValidate,
        enabled: enabled,
        autofocus: autoFocus ?? false,

        keyboardType: textInputType ?? TextInputType.text,
//          inputFormatters: [textInputFormatter],
        maxLength: maxLength,
        maxLengthEnforced: maxLengthEnforced ?? false,
        focusNode: focusNode,
        onEditingComplete: onEditingComplete,
        style: TextStyles.textStyle18InputText,

        decoration:InputDecoration(
          contentPadding: EdgeInsets.only(bottom: paddingBottom ? 15.0 : 150),
          border: showBorder?UnderlineInputBorder(
            borderSide:
                BorderSide(width: 2.0, color: ColorConstants.primaryTextColor),

//            borderRadius: BorderRadius.circular(3.0),
          ):InputBorder.none,
          hintText: hintText,
          hintStyle: hintStyle ?? TextStyle(
            fontSize: 18 * ScreenRatio.heightRatio,
            color: ColorConstants.secondaryTextColor,
            fontWeight: FontWeight.w400,
          ),
          labelText: labelText,
          labelStyle: TextStyle(
            fontSize: 18 * ScreenRatio.heightRatio,
            color: ColorConstants.lightBlack,
            fontWeight: FontWeight.bold,
          ),
        ),
        controller: controller,
        onSaved: onSaved,
        validator: validator,
        initialValue: initialValue,

      ),
    );
  }
}
