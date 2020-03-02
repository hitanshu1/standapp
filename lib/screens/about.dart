import 'package:flutter/material.dart';
import 'package:standapp/components/circularButton.dart';

import 'package:standapp/components/tapableCards.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:url_launcher/url_launcher.dart';

class About extends StatelessWidget {
  Widget logo = new SvgPicture.asset(
    'assets/logo_sign.svg',
//    color: Colors.red,
  );

  Widget logoLabel = new SvgPicture.asset(
    'assets/logo_label.svg',
  );

  @override
  Widget build(BuildContext context) {
//    ScreenRatio.setScreenRatio(
//        currentScreenHeight: MediaQuery.of(context).size.height,
//        currentScreenWidth: MediaQuery.of(context).size.width);
    return WillPopScope(
      onWillPop: ()=>Future.value(false),
      child: Scaffold(
        backgroundColor: ColorConstants.backgroundColors,
        body: OrientationBuilder(builder: (context, orientation) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              orientation == Orientation.portrait
                  ? SizedBox(
                      height: 50 * ScreenRatio.heightRatio,
                    )
                  : Container(
                      width: 0,
                      height: 0,
                    ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    width: 130 * ScreenRatio.widthRatio,
                    height: 130 * ScreenRatio.heightRatio ,
                    child: logo,
                  ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 48 : 28,
                  ),
                  SizedBox(
                    width: 191 * ScreenRatio.widthRatio,
                    height: 32 * ScreenRatio.heightRatio,
                    child: logoLabel,
                  ),
                ],
              ),
              orientation == Orientation.portrait
                  ? Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                      child: Column(
                        children: <Widget>[
                          FittedBox(
                            child: Text(
                              "Konduko, a real-time analytics and",
                              style: TextStyles.textStyle16,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "lead generation platform designed",
                              style: TextStyles.textStyle16,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "specifically for the needs of tradeshow",
                              style: TextStyles.textStyle16,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "and event organisers, exhibitors and",
                              style: TextStyles.textStyle16,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "visitors",
                              style: TextStyles.textStyle16,
                            ),
                          ),
                        ],
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                      child: Column(
                        children: <Widget>[
                          FittedBox(
                            child: Text(
                              "Konduko, a real-time analytics and lead generation platform designed",
                              style: TextStyles.textStyle16,
                            ),
                          ),
                          FittedBox(
                            child: Text(
                              "specifically for the needs of tradeshow and event organisers, exhibitors and visitors",
                              style: TextStyles.textStyle16,
                            ),
                          ),
                        ],
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.only(left: 32.0, right: 32.0),
                child: Row(
//            mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Expanded(
                        child: TappableCards(
                      onTap: () {
                        try {
                          _launchURL();
                        }catch (e){
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(e.toString() == 'Could not launch http://www.konduko.com/'? "Connect to the Internet and try again.":e.toString())));
                        }
                      },
                      assetName: ImageConstants.menuWeb,
                      text: "View Website",
                      textSize: 16,
                      orientation: orientation,
                    )),
                    Expanded(
                        child: TappableCards(
                      onTap: () {
                        Navigator.pushNamed(context, "/GuestSupport");
                      },
                      assetName: ImageConstants.contactSupport,
                      text: "Contact Support",
                      textSize: 16,
                      orientation: orientation,
                    )),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(left: 32.0),
                    child: CircularButton(
//                    heroTag: "1",
                      icon: ImageConstants.menu,
                      backgroundColor: Colors.white,
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed("/menu");
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
        }),
      ),
    );
  }
  _launchURL() async {
    const url = 'http://www.konduko.com/';
    if (await canLaunch(url)) {
      await launch(url,forceWebView: true,forceSafariVC: true,);
    } else {
      throw 'Could not launch http://www.konduko.com/';
    }
  }

}
