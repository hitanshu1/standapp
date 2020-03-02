import 'package:flutter/material.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/imageConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';


///A slide show of the information about the app. Sort of like the welcome guide with an option to skip.

//Todo: Add other screens to the slide show

class Tour extends StatefulWidget {
  @override
  TourState createState() {
    return new TourState();
  }
}

class TourState extends State<Tour> {
  PageController controller = PageController();
  int currentPageValue = 0;
  @override
  void initState() {
    controller.addListener(() {
      setState(() {
        currentPageValue = controller.page.toInt();
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
//      backgroundColor: ColorConstants.primaryTextColor,
      body: OrientationBuilder(builder: (context, orientation) {
        return SafeArea(
          child: Stack(
            children: <Widget>[
              PageView(
                controller: controller,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: ColorConstants.backgroundColors,
                          width: MediaQuery.of(context).size.width,
//                        height: MediaQuery.of(context).size.height/2 +15,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
//                            FittedBox(
//                              child: Container(
//                                margin: EdgeInsets.only(
//                                    top: 80 * ScreenRatio.heightRatio),
//                                width: orientation == Orientation.portrait
//                                    ? 400 * ScreenRatio.heightRatio
//                                    : 311 * ScreenRatio.widthRatio,
//                                child:
                                    Text(
                                      "Welcome to Your Smart Event",
                                      style: TextStyles.textStyle32Primary,
                                      textAlign: TextAlign.center,
                                    ),
//                              ),
//                            ),
                                Container(
                                  margin: EdgeInsets.only(
//                                      top: 16 * ScreenRatio.heightRatio,
                                      left: 16,
                                      right: 16,
                                      bottom: 16),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "Konduko has two products:",
                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "1. The Konduko Reader (pictured)",
                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "2. The Konduko StandApp (this app)",

                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "The Reader allows you to collect leads & deliver content. The StandApp allows you to scan barcodes and takes notes of your leads.",
                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        height: MediaQuery.of(context).size.height/2,
                          child: Image(image: AssetImage(ImageConstants.slide1),fit: BoxFit.cover,),
//                        Image.asset(ImageConstants.slide1,fit: BoxFit.cover,),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: ColorConstants.backgroundColors,
                          width: MediaQuery.of(context).size.width,
//                        height: MediaQuery.of(context).size.height/2 +15,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
//                            FittedBox(
//                              child: Container(
//                                margin: EdgeInsets.only(
//                                    top: 80 * ScreenRatio.heightRatio),
//                                width: orientation == Orientation.portrait
//                                    ? 400 * ScreenRatio.heightRatio
//                                    : 311 * ScreenRatio.widthRatio,
//                                child:
                                Text(
                                  "Scanning",
                                  style: TextStyles.textStyle32Primary,
                                  textAlign: TextAlign.center,
                                ),
//                              ),
//                            ),
                                Container(
                                  margin: EdgeInsets.only(
//                                      top: 16 * ScreenRatio.heightRatio,
                                      left: 16,
                                      right: 16,
                                      bottom: 16),
                                  child: Column(
                                    children: <Widget>[
                                      Text(
                                        "1. Open the app to the scanner screen",
                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "2. Hold your camera over the barcode",
                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "3. Wait for the barcode to be recognised",

                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "3. Take extra notes as you need to",
                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "Note: the attendee contact details will download if you are online. If not, they will download later when you connect again.",
                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        height: MediaQuery.of(context).size.height/2,
                          child: Image(image: AssetImage(ImageConstants.slide2),fit: BoxFit.cover,),
//                        Image.asset(ImageConstants.slide1,fit: BoxFit.cover,),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: ColorConstants.backgroundColors,
                          width: MediaQuery.of(context).size.width,
//                        height: MediaQuery.of(context).size.height/2 +15,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
//                            FittedBox(
//                              child: Container(
//                                margin: EdgeInsets.only(
//                                    top: 80 * ScreenRatio.heightRatio),
//                                width: orientation == Orientation.portrait
//                                    ? 400 * ScreenRatio.heightRatio
//                                    : 311 * ScreenRatio.widthRatio,
//                                child:
                                Text(
                                  "Dashboard",
                                  style: TextStyles.textStyle32Primary,
                                  textAlign: TextAlign.center,
                                ),
//                              ),
//                            ),
                                Container(
                                  margin: EdgeInsets.only(
                                      top: 16 * ScreenRatio.heightRatio,
                                      left: 16,
                                      right: 16,
                                      bottom: 16),
                                  child: Column(
                                    children: <Widget>[

                                      Text(
                                        "The StandApp Dashboard allows you to see your scans as well as statistics on how many in-progress leads you have collected at the show from both the Readers and StandApps.",
                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
//                        width: MediaQuery.of(context).size.width,
//                        height: MediaQuery.of(context).size.height/2,
                          child: Image(image: AssetImage(ImageConstants.slide3),fit: BoxFit.cover,),
//                        Image.asset(ImageConstants.slide1,fit: BoxFit.cover,),
                        ),
                      ),
                    ],
                  ),
                  Column(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          color: ColorConstants.backgroundColors,
                          width: MediaQuery.of(context).size.width,
//                        height: MediaQuery.of(context).size.height/2 +15,
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
//                            FittedBox(
//                              child: Container(
//                                margin: EdgeInsets.only(
//                                    top: 80 * ScreenRatio.heightRatio),
//                                width: orientation == Orientation.portrait
//                                    ? 400 * ScreenRatio.heightRatio
//                                    : 311 * ScreenRatio.widthRatio,
//                                child:
                                Text(
                                  "More Readers and Apps?",
                                  style: TextStyles.textStyle32Primary,
                                  textAlign: TextAlign.center,
                                ),
//                              ),
//                            ),
                                Container(
                                  margin: EdgeInsets.only(
//                                      top: 16 * ScreenRatio.heightRatio,
                                      left: 16,
                                      right: 16,
                                      bottom: 16),
                                  child: Column(
                                    children: <Widget>[

                                      Text(
                                        "You can order Readers and purchase more StandApps from events.konduko.com",

                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                      Text(
                                        "If you need support, email support@konduko.com or visitor the Konduko Exhibitor Services Desk at the venue.",
                                        style: TextStyles.textStyle18w500,
                                        textAlign: TextAlign.center,
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
//                      Expanded(
//                        child: Container(
////                        width: MediaQuery.of(context).size.width,
////                        height: MediaQuery.of(context).size.height/2,
//                          child: Image(image: AssetImage(ImageConstants.slide1),fit: BoxFit.cover,),
////                        Image.asset(ImageConstants.slide1,fit: BoxFit.cover,),
//                        ),
//                      ),
                    ],
                  ),
                ],
              ),
              Positioned(
                bottom: 20,
                left: 10,
                child: Row(
                    children: List<Widget>.generate(4, (int index) {
                  return circle(currentPageValue == index ? true : false);
                })),
              ),
              Positioned(
                bottom: 20,
                right: 10,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                        "/dashboard", (Route<dynamic> route) => false);
                  },
                  child: new Container(
                    width: 100* ScreenRatio.widthRatio,
                    height: 61.0* ScreenRatio.heightRatio,
                    decoration: new BoxDecoration(
                      color: ColorConstants.primaryTextColor,
                      border: Border.all(color: Colors.white, width: 1.0),
                      borderRadius: new BorderRadius.circular(100.0),
                    ),
                    child: new Center(
                      child: new Text(
                        "SKIP",
                        style: new TextStyle(
                            fontSize: 18.0* ScreenRatio.heightRatio,
                            color: Colors.white,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget circle(bool active) {
    return Container(
      margin: EdgeInsets.all(2.0),
      width: 10.0 * ScreenRatio.widthRatio,
      height: 10.0* ScreenRatio.heightRatio,
      decoration: BoxDecoration(
        color: active ? Colors.white : Colors.white30,
        shape: BoxShape.circle,
        //border: Border.all(width: 0.5, color: Colors.black38)
      ),
    );
  }
}
