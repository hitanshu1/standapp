import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:standapp/components/absorbantButton.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/customTextField.dart';
import 'package:standapp/data/scoped_model_camera_initialise.dart';
import 'package:standapp/screens/barcodeSacnner/barcodeCamera.dart';

import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class EnterBarcodeManually extends StatefulWidget {
  Function onBarcodeObtained;

  EnterBarcodeManually({this.onBarcodeObtained});

  @override
  EnterBarcodeManuallyState createState() {
    return new EnterBarcodeManuallyState();
  }
}

class EnterBarcodeManuallyState extends State<EnterBarcodeManually> {
  Widget illustrationBarcode = new SvgPicture.asset(
    'assets/illustration_barcode.svg',
//    color: Colors.red,
  );

  bool textFieldTapped = false;

  TextEditingController textEditingController = TextEditingController();

  FocusNode textFieldFocusNode = FocusNode();

  bool disableButton = true;

  @override
  Widget build(BuildContext context) {
//    ScreenRatio.setScreenRatio(
//        currentScreenHeight: MediaQuery.of(context).size.height,
//        currentScreenWidth: MediaQuery.of(context).size.width);
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      backgroundColor: ColorConstants.backgroundColors,
      body: OrientationBuilder(builder: (context, orientation) {
        // print("or -> ${orientation}");
        return ScopedModel<InitialiseCamera>(
          model: initialiseCameraModel,
          child: SafeArea(
            child: CustomScrollView(
//            crossAxisAlignment: CrossAxisAlignment.center,
//            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              slivers: <Widget>[
                SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      SizedBox(
                        height: 23 * ScreenRatio.heightRatio,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 242 * ScreenRatio.widthRatio,
                              height: 76 * ScreenRatio.heightRatio,
                              child: Text(
                                "Add a Contact Manually",
                                style: TextStyles.textStyle32PrimaryHeight,
//                        maxLines: 2,
//                        softWrap: true,
                              ),
                            ),
                            SizedBox(
                              height: 16 * ScreenRatio.heightRatio,
                            ),
                            Text(
                              "Please note that spaces are not required",
                              style: TextStyles.textStyle16Black,
                            ),
                          ],
                        ),
                      ),
                      !textFieldTapped
                          ? SizedBox(
                              height: 98 * ScreenRatio.heightRatio,
                            )
                          : SizedBox(
                              height: 58 * ScreenRatio.heightRatio,
                            ),

//                    !textFieldTapped
//                        ?
                      AnimatedContainer(
                        duration: Duration(seconds: 1),
                        curve: Curves.easeInOut,
                        width:
                            textFieldTapped ? 0 : 279 * ScreenRatio.widthRatio,
                        height:
                            textFieldTapped ? 0 : 165 * ScreenRatio.heightRatio,
                        child: illustrationBarcode,
                      ),
//                    SizedBox(
//                            width: 279 * ScreenRatio.widthRatio,
//                            height: 165 * ScreenRatio.heightRatio,
//                            child: illustrationBarcode,
//                          )
//                        : Container(
//                            width: 0,
//                            height: 0,
//                          ),
                      !textFieldTapped
                          ? SizedBox(
                              height: 55 * ScreenRatio.heightRatio,
                            )
                          : Container(
                              width: 0,
                              height: 0,
                            ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32),
                        child: CustomTextField(
//                        textInputFormatter: MaskedTextInputFormatter(mask: "xxxx/xxxxx", separator: "-",type: "barCode"),
//                          maxLengthEnforced: true,
//                          maxLength: 13,
                          focusNode: textFieldFocusNode,
                          onEditingComplete: () {
                            print("complete");
                            FocusScope.of(context).requestFocus(FocusNode());
                            setState(() {
                              textFieldTapped = false;
                            });
                          },
                          onChanged: (value) {
                            print(value);
                            if (value.length == 1) {
                              setState(() {
                                disableButton = false;
                              });
                            } else if (value.length == 0) {
                              setState(() {
                                disableButton = true;
                              });
                            }
                          },
                          onTap: () {
                            setState(() {
                              textFieldTapped = true;
                            });
                          },
                          controller: textEditingController,
                          textInputType: TextInputType.text,
                          width: 311 * ScreenRatio.widthRatio,
                          hintText: "Tap to enter",
                        ),
                      ),
                      SizedBox(
                        height: 48 * ScreenRatio.heightRatio,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 32.0, right: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            ScopedModelDescendant<InitialiseCamera>(
                              builder: (context, child, initCameraModel) {
                                return CircularButton(
//                      heroTag: "2",

                                  backgroundColor: Colors.white,
                                  icon: 'assets/icon_footer_back.svg',
                                  onPressed: () {
                                    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (context) => BarcodeCamera(
                                            controller:
                                                initCameraModel.controller)));
                                  },
                                );
                              },
                            ),
                            AbsorbantButton(
                              disabled: disableButton,
                              color: ColorConstants.primaryTextColor,
                              label: "ADD CONTACT",
                              width: 137 * ScreenRatio.widthRatio,
                              onPressed: () async {
                                textEditingController.text.isNotEmpty
                                    ? await widget.onBarcodeObtained(
                                        context, textEditingController.text)
                                    : null;
                              },
                            ),
                          ],
                        ),
                      ),
//                    SizedBox(
//                      height: 10 * ScreenRatio.heightRatio,
//                    ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

//class MaskedTextInputFormatter extends TextInputFormatter {
//  final String mask;
//  final String separator;
//  final String type;
//
//  MaskedTextInputFormatter({
//    @required this.mask,
//    @required this.separator,
//    this.type,
//  }) {
//    assert(mask != null);
//    assert(separator != null);
//  }
//
//  @override
//  TextEditingValue formatEditUpdate(
//      TextEditingValue oldValue, TextEditingValue newValue) {
//    RegExp barCode = new RegExp(
//        r'^(?=.*0)[0-9]{12}$');
//    RegExp date = new RegExp(
//        r'^([0]|[1]|[0][1-9]|[1][0-2]|[0][1-9][0-9]|[1][0-2][0-9]|[0][1-9][/][0-9]|[1][0-2][/][0-9]|[0][1-9][/][0-9][1-9]|[1][0-2][/][0-9][1-9]|[1][0-2][/][1-9][0-9])$');
//    if (newValue.text.length > 0) {
//      if (newValue.text.length > oldValue.text.length) {
//        if (newValue.text.length > mask.length) return oldValue;
//        if (!barCode.hasMatch(newValue.text) && (type == "barCode")) {
//          return oldValue;
//        }
//        if (!date.hasMatch(newValue.text) && (type == "date")) {
//          return oldValue;
//        }
//        if (newValue.text.length < mask.length &&
//            mask[newValue.text.length - 1] == separator) {
//          return TextEditingValue(
//            text:
//            '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
//            selection: TextSelection.collapsed(
//              offset: newValue.selection.end + 1,
//            ),
//          );
//        }
//      }
//    }
//    return newValue;
//  }
//}
