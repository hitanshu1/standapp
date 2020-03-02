import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:standapp/utils/colorConstants.dart';

class InitialiseCamera extends Model{
  CameraController controller;


  Future initializeCamera(context) async{

    if (controller != null) return controller;
    final List<CameraDescription> cameras =
    await availableCameras();

    CameraDescription backCamera;
    for (CameraDescription camera in cameras) {
      if (camera.lensDirection ==
          CameraLensDirection.back) {
        backCamera = camera;
        break;
      }
    }

    if (backCamera == null)
      throw ArgumentError(
          "No back camera found.");
    controller = new CameraController(
        backCamera, ResolutionPreset.medium);

    try {
      await controller.initialize();
      return controller;
    } on CameraException catch (_) {
      await showCameraDialog(context);
//      Navigator.of(context).pop();
      print("camera e ");
    }

    notifyListeners();
  }

  Future<void> showCameraDialog(context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10))),
          title: Text(
            'StandApp does not have access to your camera. To enable access, got to Settings and turn on Camera.',
            softWrap: true,
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'OK',
                style: TextStyle(color: ColorConstants.primaryTextColor),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }


}

InitialiseCamera initialiseCameraModel = InitialiseCamera();