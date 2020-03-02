import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/tapableCards.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';
import 'package:url_launcher/url_launcher.dart';


///Displays information that user does not have any licenses remaining and gives them the choice to use app in guest mode or buy a licence

//TODO: User should be able to scan but not upload without licence key

class SignUpError extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorConstants.backgroundColors,
      body: OrientationBuilder(builder: (context, orientation) {
        return ListView(
          children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              color: ColorConstants.primaryTextColor,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: orientation == Orientation.portrait
                        ? MediaQuery.of(context).size.height / 8
                        : 10,
                  ),
                  Container(
                    width: 54,
                    height: 48,
                    child: SvgPicture.asset(
                      ImageConstants.alertSolid,
                      fit: BoxFit.contain,
                    ),
                  ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 30 : 6,
                  ),
                  Container(
                    width: 311,
                    height: 45,
                    child: Center(
                      child: Text(
                        "Oops!",
                        style: TextStyles.textStyle32,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: orientation == Orientation.portrait ? 15 : 4,
                  ),
                  Expanded(
                    child: Container(
                      width: 311,
                      height: 60,
                      child: Center(
                        child: Column(
                          children: <Widget>[
                            Text(
                              "Your event key is valid.",
                              style: TextStyles.textStyle14,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            ),
                            Text(
                              "However, your organization has no more licenses available.",
                              style: TextStyles.textStyle14,
                              softWrap: true,
                              textAlign: TextAlign.center,
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Center(
              child: Container(
        margin:EdgeInsets.only( top: 32),
                width: 3* MediaQuery.of(context).size.width/4,
                child: Text("Please visit the Smart Event booth or contact support to purchase a license.",maxLines:3,style: TextStyles.textStyle16Card),
              ),
            ),
            Container(
              margin: orientation == Orientation.portrait
                  ? EdgeInsets.only(left: 20, right: 20, top: 32)
                  : EdgeInsets.only(left: 20, right: 20, top: 32),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TappableCards(
                      onTap: (){
                        try {
                          _launchURL(url:'https://events.konduko.com/');
                        } catch (e) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                              content: Text(
                                  e.runtimeType.toString() == 'SocketException'
                                      ? "Connect to the Internet and try again."
                                      : e.toString())));
                        }
                      },
                      text: "Purchase License Key",
                      textSize: 16,
                      assetName: ImageConstants.buy,
                    ),
                  ),
                  Expanded(
                    child: TappableCards(
                      onTap: () {
                        Navigator.of(context).pushNamed("/guestMode");
                      },
                      text: "Use Without License",
                      textSize: 16,
                      assetName: ImageConstants.guest,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: orientation == Orientation.portrait
                  ? EdgeInsets.only(
                  left: 32.0,
                  right: 32,
                  top: 32,bottom: 12
              )
                  : EdgeInsets.only(
                  left: 32.0,
                  right: 32,
                  top: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  CircularButton(
                    heroTag: "4",
                    icon: ImageConstants.back,
                    backgroundColor: Colors.white,
                    iconcolor: Colors.black,
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  CircularButton(
                    heroTag: "5",
                    icon: ImageConstants.help,
                    backgroundColor: Colors.white,
                    iconcolor: ColorConstants.primaryTextColor,
                    onPressed: () {
                      showHelpDialog(context);

                    },
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );

  }
  Future<void> showHelpDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Column(
            children: <Widget>[
              Text(
                'For assistance contact',
                softWrap: true,
                textAlign: TextAlign.center,
              ),
              GestureDetector(
                onTap: () {
                  try {
                    _launchURL(url:'https://konduko.com/');
                  } catch (e) {
                    Scaffold.of(context).showSnackBar(SnackBar(
                        content: Text(
                            e.runtimeType.toString() == 'SocketException'
                                ? "Connect to the Internet and try again."
                                : e.toString())));
                  }
                },
                child: Text(
                  "support@konduko.com",
                  style: TextStyles.textStyle18UnderLined,
                ),
              ),
              Text(
                'or visitor the Konduko Exhibitor Services desk if at an event',
                softWrap: true,
                textAlign: TextAlign.center,
              ),
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('OK',
                style: TextStyle(color: ColorConstants.primaryTextColor),),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  _launchURL({String url}) async {
//    String url = url;
    if (await canLaunch(url)) {
      await launch(url, forceWebView: true, forceSafariVC: true,);
    } else {
      throw 'Could not launch $url';
    }
  }
}
