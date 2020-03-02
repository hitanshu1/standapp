import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/components/absorbantButton.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class Support extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: OrientationBuilder(builder: (context, orientation) {
      return Stack(
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(32, 50, 32, 32),
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
                  margin: EdgeInsets.only(top: 32, bottom: 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      FittedBox(
                        child: Text(
                          "Benjamin Anderson",
                          style: TextStyles.textStyle32Primary,
                        ),
                      ),
                      Text(
                        "Supervisory Board",
                        style: TextStyles.textStyle14Black,
                      ),
                      Text(
                        "Konduko SA",
                        style: TextStyles.textStyle14Bold,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 21,
                              width: 20,
                              child: SvgPicture.asset(
                                ImageConstants.infoEmail,
                                fit: BoxFit.contain,
                                color: ColorConstants.secondaryTextColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "billy.a@email.com",
                              style: TextStyles.textStyle14Primary,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width,
                        height: 20,
                        child: Row(
                          children: <Widget>[
                            Container(
                              height: 21,
                              width: 20,
                              child: SvgPicture.asset(
                                ImageConstants.infoPhone,
                                fit: BoxFit.contain,
                                color: ColorConstants.secondaryTextColor,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Text(
                              "+1 212 221 7515",
                              style: TextStyles.textStyle14Primary,
                              maxLines: 1,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  keyboardType: TextInputType.text,
                  maxLines: 5,
                  style: TextStyles.textStyle14Black,
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      bottom: 100 * ScreenRatio.heightRatio,
                    ),
                    border: UnderlineInputBorder(
                      borderSide: BorderSide(
                          width: 2.0, color: ColorConstants.primaryTextColor),
                    ),
                    hintText: "Tap to add notes",
                    hintStyle: TextStyle(
                      fontSize: 18,
                      color: ColorConstants.secondaryTextColor,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: orientation == Orientation.portrait
                ? EdgeInsets.only(
                    left: 32.0,
                    right: 32,
                    top: MediaQuery.of(context).size.height - 90)
                : EdgeInsets.only(
                    left: 32.0,
                    right: 32,
                    top: MediaQuery.of(context).size.height - 90),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                CircularButton(
                  heroTag: "4",
                  icon: ImageConstants.menu,
                  backgroundColor: Colors.white,
                  iconcolor: Colors.black,
                  onPressed: () {},
                ),
                AbsorbantButton(
                  width: 190,
                  //shadow: true,
                  label: "SUBMIT REQUEST",
                  color: ColorConstants.primaryTextColor,
                  disabled: true,
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ],
      );
    }));
  }
}
