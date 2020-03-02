import 'package:flutter/material.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/termsAndConditionsData.dart';
import 'package:standapp/utils/textStyles.dart';

class TermsAndConditions extends StatelessWidget {

  bool justShowScreen = false;
  TermsAndConditions({this.justShowScreen=false});
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(32, 50, 32, 0),
            child: ListView(
              children: <Widget>[
                Container(
                  width: 180,
                  height: 85 * ScreenRatio.heightRatio,
                  child: Text(
                    "Terms & Conditions",
                    style: TextStyles.textStyle32Primary,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0, bottom: 32),
                  child: Container(
                    child: Text(
                      "Terms of Service for the use of the mobile phone application service of Konduko SA.",
                      style: TextStyles.textStyle14Black,
                    ),
                  ),
                ),
                conditions("01.", "Your Acceptance", condition1),
                conditions("02.", "Stocard Service", condition2),
                conditions("03.", "Your Acceptance", condition1),
                SizedBox(
                  height: 80,
                ),
              ],
            ),
          ),
          justShowScreen?Container(width: 0,height: 0,):Padding(
            padding: orientation == Orientation.portrait
                ? EdgeInsets.only(
                    left: 32.0, top: MediaQuery.of(context).size.height - 90)
                : EdgeInsets.only(
                    left: 32.0, top: MediaQuery.of(context).size.height - 90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircularButton(
                  heroTag: "4",
                  icon: ImageConstants.menu,
                  backgroundColor: Colors.white,
                  iconcolor: Colors.black,
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed("/menu");
                  },
                ),
              ],
            ),
          ),
        ],
      );
    }));
  }

  Widget conditions(String number, String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            number,
            style: TextStyles.textStyle40,
          ),
          Text(
            title,
            style: TextStyles.textStyle18BoldPrimary,
          ),
          Text(
            content,
            style: TextStyles.textStyle12,
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );
  }
}
