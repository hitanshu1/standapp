import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class FilterCard extends StatelessWidget {
  final String iconName;
  final String names;
  final bool selected;

  FilterCard({this.iconName, this.names, this.selected});

  @override
  Widget build(BuildContext context) {
//    ScreenRatio.setScreenRatio(
//        currentScreenHeight: MediaQuery.of(context).size.height,
//        currentScreenWidth: MediaQuery.of(context).size.width);
    Widget icon = new SvgPicture.asset(
      iconName,
    );
    return Container(
//        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color:
                  !selected ? Colors.white : ColorConstants.primaryTextColor),
          boxShadow: [
            BoxShadow(blurRadius: 10, spreadRadius: 10, color: Colors.grey[200])
          ],
        ),
        width: 311 * ScreenRatio.widthRatio,
        height: 74 * ScreenRatio.heightRatio,
        child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
              Expanded(
                  child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      child: (Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.max,
                        children: [

                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              height: 30* ScreenRatio.heightRatio,
                              width: 30* ScreenRatio.widthRatio,
                              child: icon,
                            ),
                          SizedBox(
                            width: 10,
                          ),
                            Text(
                              names,
                              maxLines: 2,
                              style: TextStyles.textStyle18w600,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),

                          Padding(
                            padding:  EdgeInsets.only(right: 16.0 * ScreenRatio.widthRatio),
                            child: selected
                                ? Icon(
                                    Icons.check,
                                    color: ColorConstants.primaryTextColor,
                                    size: 24* ScreenRatio.heightRatio,
                                  )
                                : Container(
                                    width: 24,
                                    height: 24,
                                  ),
                          ),

                        ],
                      ))))
            ])));
  }
}
