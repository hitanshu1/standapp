import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/components/barcodeReader.dart';
import 'package:standapp/components/circularButton.dart';
import 'package:standapp/components/roundedButton.dart';
import 'package:standapp/data/scoped_model_questions.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/screens/enterBarcodeManually.dart';
import 'package:standapp/screens/guestModeOfflineAddBadge.dart';
import 'package:standapp/screens/offlineAddBadge.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:standapp/utils/textStyles.dart';

class BarcodeCamera extends StatefulWidget {
  CameraController controller;
  BarcodeCamera({this.controller});
  @override
  BarcodeCameraState createState() {
    return new BarcodeCameraState();
  }
}

class BarcodeCameraState extends State<BarcodeCamera> {
//  CameraController controller;
  bool barCodeDetected = false;
  BarCodeReader reader;

  double boxHeight = 250 * ScreenRatio.heightRatio;
  double boxWidth = 275 * ScreenRatio.widthRatio;

  double focusEdgeWidth = 40 * ScreenRatio.widthRatio;
  double focusEdgeHeight = 40 * ScreenRatio.widthRatio;

  @override
  initState() {
    barCodeDetected = false;
    initPlatformState();
    super.initState();
  }

  @override
  void dispose() {
    widget.controller?.stopImageStream();
    super.dispose();
  }

  onBarcodeObtained(context, barcode) async {
//TODO: Adds a character at the end CRITICAl
    print("barCode 0=> ${json.encode({"barcode": barcode})}");

    if (!prefs.getBool("guest")) {
      await scanModel.fetchScanDetails(barcode.toString());
      if (scanModel.apiResponseForScanDetails.error == null) {
        scanModel.currentScan.conversationAt =
            DateTime.now().toUtc().toString();
        Navigator.of(context).pushReplacementNamed("/addBadge");
      } else {
        Scan scan =
            Scan(barCode: barcode.toString(), uploadedSuccessfullyOnce: false);
        scanModel.currentScan = scan;

//        //Upload restriction code
//        scanModel.currentScan.numberOfAttempts++;

        scanModel.currentScan.conversationAt =
            DateTime.now().toUtc().toString();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) => AddOfflineBadge(online: true)));
      }
    } else {
      Scan scan = Scan(
        barCode: barcode.toString(),
      );
      scanModel.currentScan = scan;
      scanModel.currentScan.conversationAt = DateTime.now().toUtc().toString();
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => GuestModeAddOfflineBadge(online: true)));
    }
  }

  initPlatformState() async {
    print("init0000");
//
//    if (controller != null) return controller;
//      final List<CameraDescription> cameras = await availableCameras();
//
//      CameraDescription backCamera;
//      for (CameraDescription camera in cameras) {
//        if (camera.lensDirection == CameraLensDirection.back) {
//          backCamera = camera;
//          break;
//        }
//      }

//      if (backCamera == null) throw ArgumentError("No back camera found.");
    reader = BarCodeReader.instance;

//      controller = new CameraController(backCamera, ResolutionPreset.medium);

//      try {
//        await controller.initialize();
//      }on CameraException catch(_){
//        await showCameraDialog();
//        Navigator.of(context).pop();
//        print("camera e ");
//      }

//      print("controller=> ${controller}");

//    if (widget.controller.value.isInitialized) {
//      print("initialised");

    reader.detect(widget.controller);
//      setState(() {
//        widget.controller = widget.controller;
//      });

    reader.addListener(() async {
      if (reader.barCodeDetected) {
//          print("barcodeDetected");

        if (!barCodeDetected) {
          barCodeDetected = true;
          print(reader.barCodeValue);

          await onBarcodeObtained(context, reader.barCodeValue);
        }
      }
    });
//    }
  }

  @override
  Widget build(BuildContext context) {
    Rect position = Rect.fromLTRB(80, 208, 80, 208);
    ScreenRatio.setScreenRatio(
        currentScreenHeight: MediaQuery.of(context).size.height,
        currentScreenWidth: MediaQuery.of(context).size.width);
    final size = MediaQuery.of(context).size;
    final deviceRatio = size.width / size.height;

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          widget.controller != null
              ? Transform.scale(
                  scale: widget.controller.value.aspectRatio / deviceRatio,
                  child: Center(
                    child: AspectRatio(
                      aspectRatio: widget.controller.value.aspectRatio,
                      child: CameraPreview(widget.controller),
                    ),
                  ),
                )
              : Container(),

//        Positioned.fill(
//          child: Image.network(
//            "https://openclipart.org/image/2400px/svg_to_png/228343/Colorful-Plus-Pattern-Wallpaper.png",
//            fit: BoxFit.cover,
//          ),
//        ),

          Align(
            alignment: AlignmentDirectional.centerStart,
            child: ClipPath(
//            clipBehavior: Clip.hardEdge,
              clipper:
                  ScanAreaClipper(boxHeight: boxHeight, boxWidth: boxWidth),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 20.0, sigmaY: 20.0),
                child: Container(
                  color: Colors.transparent,
                ),
              ),
            ),
          ),

          //Solution 1 for barcode UI
//          new Container(
//            width: MediaQuery.of(context).size.width,
//            height: MediaQuery.of(context).size.height,
//            decoration: new BoxDecoration(
////                  color: Colors.grey.shade200.withOpacity(0.5),
//              border: Border(
//                top: BorderSide(
//                  width: 208 * ScreenRatio.heightRatio + 4,
////                    color: Color.fromRGBO(255, 255, 255, 0.7),
//                  color: Color.fromRGBO(255, 255, 255, 0.7),
//                ),
//                left: BorderSide(
//                    width: 80 * ScreenRatio.widthRatio - 4,
//                    color: Color.fromRGBO(255, 255, 255, 0.7)),
//                right: BorderSide(
//                    width: 80 * ScreenRatio.widthRatio - 4,
//                    color: Color.fromRGBO(255, 255, 255, 0.7)),
//                bottom: BorderSide(
//                    width: 208 * ScreenRatio.heightRatio + 4,
//                    color: Color.fromRGBO(255, 255, 255, 0.7)),
//              ),
//            ),
//          ),
//
//          Positioned(
//            top: 20.0,
//            left: 20.0,
//            child: IconButton(
//              color: Colors.white,
//              iconSize: 40.0,
//              icon: Icon(_isOn ? Icons.flash_off : Icons.flash_on),
//              onPressed: () {
//                _turnFlash();
//              },
//            ),
//          ),

//          Column(
//            mainAxisAlignment: MainAxisAlignment.center,
//            children: <Widget>[
          Positioned(
            left: (MediaQuery.of(context).size.width - boxWidth) / 2,
            top: (MediaQuery.of(context).size.height - boxHeight) / 2,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                container(),
                Padding(
                  padding: EdgeInsets.only(left: boxWidth - 80),
                ),
                RotatedBox(
                  quarterTurns: 1,
                  child: container(),
                ),
              ],
            ),
          ),
//              Padding(
//                padding: EdgeInsets.only(top: 135.0),
//              ),
          Positioned(
            left: (MediaQuery.of(context).size.width - boxWidth) / 2,
            top: ((MediaQuery.of(context).size.height - boxHeight) / 2) +
                boxHeight -
                40,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                RotatedBox(
                  quarterTurns: 3,
                  child: container(),
                ),
                Padding(
                  padding: EdgeInsets.only(left: boxWidth - 80),
                ),
                RotatedBox(
                  quarterTurns: 2,
                  child: container(),
                ),
              ],
            ),
          ),
//              SizedBox(
//                height: 64 * ScreenRatio.heightRatio,
//              ),
          Positioned(
//            left: MediaQuery.of(context).size.width/2,
            top: (MediaQuery.of(context).size.height / 2) + (boxHeight / 2),
            child: Padding(
              padding: EdgeInsets.only(top: 64 * ScreenRatio.heightRatio),
              child: Column(
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Text(
                      "Position QR code or bar code",
                      style: TextStyles.textStyle16Primary,
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(left: 8, right: 8),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.all(Radius.circular(5))),
                    child: Text(
                      "in this frame to scan automatically",
                      style: TextStyles.textStyle16Primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
//            ],
//          ),
          Positioned(
            bottom: 20,
            left: 32,
            child: CircularButton(
              icon: "assets/icon_footer_close.svg",
              backgroundColor: Colors.white,
              onPressed: () {
//                controller.dispose();
//                reader.dispose();
                Navigator.of(context).pop();
              },
            ),
          ),
          Positioned(
            bottom: 20,
            right: 32,
            child: RoundedButton(
              onPressed: () {
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) => EnterBarcodeManually(
                        onBarcodeObtained: onBarcodeObtained)));
              },
              shadow: false,
              label: "ENTER CODE",
              width: 152 * ScreenRatio.widthRatio,
              backgroundColor: Colors.white,
              textColor: ColorConstants.primaryTextColor,
            ),
          ),
        ],
      ),
    );
  }

//  Future<void> showCameraDialog() async {
//    return showDialog<void>(
//      context: context,
//      barrierDismissible: false, // user must tap button!
//      builder: (BuildContext context) {
//        return AlertDialog(
//          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
//          title: Text(
//            'StandApp does not have access to your camera. To enable access, got to Settings and turn on Camera.',
//            softWrap: true,
//            textAlign: TextAlign.center,
//          ),
//          actions: <Widget>[
//            FlatButton(
//              child: Text('OK',style: TextStyle(color: ColorConstants.primaryTextColor),),
//              onPressed: () {
//                Navigator.of(context).pop();
//              },
//            ),
//          ],
//        );
//      },
//    );
//  }

}

Widget container() {
  return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 4.0, color: Colors.white),
          left: BorderSide(width: 4.0, color: Colors.white),
          right: BorderSide(width: 4.0, color: Colors.transparent),
          bottom: BorderSide(width: 4.0, color: Colors.transparent),
        ),
      ));
}

class ScanAreaClipper extends CustomClipper<Path> {
  var rect = Offset.zero;

  var boxWidth = 275.0;
  var boxHeight = 275.0;

  var positionFromLeft;
  var positionFromTop;

  ScanAreaClipper({this.boxHeight, this.boxWidth});
  @override
  Path getClip(Size size) {
    positionFromLeft = (size.width - boxWidth) / 2;
    positionFromTop = (size.height - boxHeight) / 2;
    return Path.combine(
        PathOperation.difference,
        Path()..addRect(Offset.zero & size),
        Path()
          ..addRect(Rect.fromLTWH(
              positionFromLeft, positionFromTop, boxWidth, boxHeight)));
  }

  @override
  bool shouldReclip(ScanAreaClipper old) => rect != old.rect;
}
