import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:standapp/components/absorbantButton.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/customTextField.dart';
import 'package:standapp/data/scoped_model_keyActivation.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

///First screen in the Registration flow. Prompts user to enter an Event key.
///This key is used to make an API through the scoped model named `scoped_model_keyActivation`.
///On Success i.e if there are the licenceRemaining count is positive, navigates the screen to `Registration`

class KeyActivation extends StatefulWidget {
  @override
  KeyActivationState createState() {
    return new KeyActivationState();
  }
}

class KeyActivationState extends State<KeyActivation> {
  FocusNode focusNode = FocusNode();

  TextEditingController keyInputController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColors,
      body: OrientationBuilder(builder: (context, orientation) {
        return ScopedModel<KeyRegModel>(
          model: keyRegModel,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 311 * ScreenRatio.widthRatio,
                        height: 76* ScreenRatio.heightRatio,
                        child: Text(
                          "Enter Activation Key",
                          style: TextStyles.textStyle32PrimaryHeight,
                          maxLines: 2,
                          softWrap: true,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 14.0),
                        child: Text(
                          "Please note that spaces are not required",
                          style: TextStyles.textStyle16Black,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: CustomTextField(
                    inputFormatters: [
                      MaskedTextInputFormatter(
                          mask: 'xxxx-xxxx',
                          separator: '-',
                          type: "credit-card"
                      ),
                    ],
                    controller: keyInputController,
                    autoFocus: true,
                    textInputType: TextInputType.text,
                    width: 311* ScreenRatio.widthRatio,
                    hintText: "Enter key",
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0, right: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      CircularButton(
                        backgroundColor: Colors.white,
                        icon: 'assets/icon_footer_back.svg',
                        onPressed: () {
                          focusNode.unfocus();
                          Navigator.of(context).pop();
                        },
                      ),
                      ScopedModelDescendant<KeyRegModel>(
                          builder: (context, child, model) {
                        return AbsorbantButton(

                          color: ColorConstants.primaryTextColor,
                          label: "CONTINUE",
                          width: 137* ScreenRatio.widthRatio,
                          onPressed: () async {
                            if (keyInputController.text.isNotEmpty) {
                              model.activationKey = keyInputController.text;
                              await model.checkKeyValidity();
                              model.apiResponse.error == null
                                  ? Navigator.of(context)
                                      .pushNamed("/registration")
                                  : Scaffold.of(context).showSnackBar(SnackBar(
                                      content: Text(model.apiResponse.error)));
                            } else {
                              Scaffold.of(context).showSnackBar(SnackBar(
                                  content: Text("Enter Valid Activation key")));
                            }
                          },
                        );
                      }),
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

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;
  final String type;
//  List<String> separatedMask = <String>[];

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
    this.type,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    RegExp creditCard = new RegExp(
        r'^([a-zA-Z0-9]{1,5}|[a-zA-Z0-9]{4}[-]|[a-zA-Z0-9]{4}[-][a-zA-Z0-9]{1,5})$');
    if (newValue.text.length > 0) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (!creditCard.hasMatch(newValue.text) && (type == "credit-card")) {
          return oldValue;
        }

        if (newValue.text.length < mask.length &&
            newValue.text.length == 4
        ) {
          return TextEditingValue(
            text:
            '${oldValue.text?.toUpperCase()}${newValue.text.substring(
                newValue.text.length - 1).toUpperCase()}$separator',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        } else if (newValue.text.length <= mask.length) {
          return TextEditingValue(
            text: newValue.text?.toUpperCase(),
            selection: newValue.selection,
          );
        }
      }
    }
    return newValue;
  }
}


