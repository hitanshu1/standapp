import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:flutter/animation.dart';

class MenuCards extends StatefulWidget {
  final String text;
  final Function onTap;
  final Orientation orientation;
  BuildContext context;
  final String assetName;

  MenuCards(
      {this.text, this.onTap, this.orientation, this.assetName, this.context});

  @override
  MenuCardsState createState() {
    return new MenuCardsState();
  }
}

class MenuCardsState extends State<MenuCards> {


  bool disabled = false;

  @override
  Widget build(BuildContext context) {
    Widget icon = new SvgPicture.asset(
      widget.assetName,
      color: ColorConstants.primaryTextColor,
      width: 24 * ScreenRatio.widthRatio,
      height: 24 * ScreenRatio.heightRatio,
    );

    return AbsorbPointer(
      absorbing: disabled,
      child: InkWell(
        onTap: () async {
          setState(() {
            disabled = true;
          });
          await widget.onTap();
          setState(() {
            disabled = false;
          });
        },
        child: Container(
          //  margin: EdgeInsets.only(left: 80),
            width: MediaQuery
                .of(context)
                .size
                .width - 64,
            //margin: EdgeInsets.only(left: 5, right: 5),
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey[200],
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ]),
            height:
//          150,
            widget.orientation == Orientation.portrait
                ? MediaQuery
                .of(context)
                .size
                .height / 12
                : MediaQuery
                .of(context)
                .size
                .height / 7,
            child: Center(
              child: Container(
                margin: EdgeInsets.only(left: 24, right: 24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: SizedBox(
                        height: 32 * ScreenRatio.heightRatio,
                        width: 24 * ScreenRatio.widthRatio,
                        child: icon,
                      ),
                    ),
                    SizedBox(
                      width: 16,
                    ),
                    Center(
                      child: SizedBox(
                        height: 24,
                        child: Text(
                          widget.text,
                          style: widget.orientation == Orientation.portrait
                              ? TextStyles.textStyle18Button
                              : TextStyles.textStyle32Button,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )),
      ),
    );
  }
}
