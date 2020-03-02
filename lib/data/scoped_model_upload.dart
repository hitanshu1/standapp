import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/models/response.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/services/Api.dart';
import 'package:standapp/services/config.dart';
import 'package:standapp/services/intermediateService.dart';

class UploadModel extends Model {
  Response apiResponseForScanDetails = Response();

  uploadScan(Scan scan) async {
    apiResponseForScanDetails.data = null;
    apiResponseForScanDetails.error = null;

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    Scan scanDetails = Scan();

    String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
    ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

    String token;
    String conversationsLink;

    if (apiTokenWithLicenceString != null) {
      apiTokenWithLicence =
          ApiTokenWithLicence.fromJson(json.decode(apiTokenWithLicenceString));
      token = apiTokenWithLicence.newToken;
      conversationsLink = apiTokenWithLicence.conversationsLink;
    }

    var response;
    List scanDetailsList;
    var encodedScan = json.encode(scan);

    print("check 7 => ${encodedScan}");

    try {
      //Upload restriction code
      // scan.numberOfAttempts++;
      response = await Api().postRequest(
          url: conversationsLink,
          body: encodedScan,
          headers: {
            "Authorization": "Bearer " + token,
            'content-type': 'application/json'
          });

      scanDetailsList = json.decode(response);

      print("uploaded scan from upload scoped model -> ${scanDetailsList}");

      if (scanDetailsList.isNotEmpty) {
        scanDetails = Scan.fromJson(scanDetailsList[0]);
//      scan.conversationAt = scanDetailsList[0]
        scanDetails.id = scan.id;
        scanDetails.uploaded = true;

        //Upload restriction code
        // scanDetails.numberOfAttempts = scan.numberOfAttempts;

        print("check 8 -> ${scanDetails}");
//        scanDetails.extraFields = json.decode(scanDetails.extraFields);
        scanModel.updateScanLocallyAndModel(scan: scanDetails, user: "user");

        apiResponseForScanDetails.error = null;
      } else {
        apiResponseForScanDetails.error =
            "No entity associated with the barcode";
      }
    } on Exception catch (e) {
      print("e => ${e}");
      apiResponseForScanDetails.error =
          e.runtimeType.toString() == 'SocketException'
              ? "Connect to the Internet and try again."
              : e.toString();
    }
  }

//  UploadModel(){
//
//  }
}

UploadModel uploadModel = new UploadModel();
