import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/services.dart';

class Search extends StatelessWidget {
  TextEditingController controller;
  String hintText;
  double width;
  double height;
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
  Function onCancelPressed;

  Search(
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
      this.paddingBottom = true,
      this.autoFocus = false,
      this.height,this.onCancelPressed});

  @override
  Widget build(BuildContext context) {
//    ScreenRatio.setScreenRatio(
//        currentScreenHeight: MediaQuery.of(context).size.height,
//        currentScreenWidth: MediaQuery.of(context).size.width);
    return TextField(
      autofocus: autoFocus ?? false,
      controller: controller,
//          keyboardType: textInputType ?? TextInputType.text,
//          inputFormatters: [textInputFormatter],
//          maxLength: maxLength,
//          maxLengthEnforced: maxLengthEnforced ?? false,
          focusNode: focusNode,
      onEditingComplete: onEditingComplete,
          onSubmitted: (a){print("asdasd => $a");},
          onTap: onTap,

      style: TextStyle(
//          height: 1.5,dasdas
        fontSize: 18 * ScreenRatio.widthRatio,
        color: ColorConstants.touchableCardTextColor,
        fontWeight: FontWeight.w600,
        fontFamily: 'Poppins',
      ),

      decoration: InputDecoration(
        contentPadding: EdgeInsets.all(15),
        border: OutlineInputBorder(
          borderSide:
              BorderSide(width: 2.0, color: ColorConstants.primaryTextColor),
          borderRadius: BorderRadius.circular(15),
        ),

        prefixIcon: Icon(
          Icons.search,
          size: 25 * ScreenRatio.heightRatio,
          color: ColorConstants.primaryTextColor,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            Icons.cancel,
            size: 25* ScreenRatio.heightRatio,
          ),
          onPressed: onCancelPressed,
          color: ColorConstants.secondaryTextColor,
        ),
//          Container(
//            color: Colors.red,
//            child: SvgPicture.asset(
//              ImageConstants.inputSearch,
//              width: 1,
//              height: 1,
//              fit: BoxFit.cover,
////            color: ColorConstants.primaryTextColor,
//            ),
//          ),
        labelStyle: TextStyle(
          color: Colors.black,
        ),
        hintText: hintText ?? "Search for contacts",
        hintStyle: TextStyle(
          fontSize: 18 * ScreenRatio.widthRatio,
          letterSpacing: 0.0,
          color: ColorConstants.secondaryTextColor,
          fontWeight: FontWeight.w400,
        ),
      ),
//          controller: controller
    );
  }
}
