import 'dart:async';
import 'dart:convert';

import 'package:background_fetch/background_fetch.dart';
import 'package:connectivity/connectivity.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/data/scoped_model_statistics.dart';
import 'package:standapp/data/scoped_model_upload.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/services/Api.dart';
import 'package:standapp/services/internetService.dart';

//import 'package:intl/intl.dart';

class UploadService {
  static List<Scan> scans = <Scan>[];

  static bool onlineStatus = false;
  static StreamSubscription<ConnectivityResult> netCheckSubscription;

  static Timer statFetchTimer;

  static List<Scan> unsuccessfulUploads = <Scan>[];

  UploadService({List<Scan> scansFromModel}) {
    scans.clear();
    scans.addAll(scansFromModel);
  }

  static init() {
    if (netCheckSubscription != null) {
      netCheckSubscription.cancel();
    }
    checkInternet();
  }

  static startUpload() async {
    Iterable<Scan> scansToUpload = <Scan>[];

    unsuccessfulUploads.clear();
    scansToUpload = scanModel.contactList.where((aScan) => !aScan.uploaded);
    print("scansToUpload => ${scansToUpload}");

    scansToUpload.forEach((aScanToUpload) async {
      bool success = await upload(aScanToUpload);
      if (!success) {
        unsuccessfulUploads.add(aScanToUpload);
      }
    });
  }

  static Future<bool> upload(Scan scan) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
    ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

    String token;
    String conversationsLink;

    Scan scanDetails = Scan();

    if (apiTokenWithLicenceString != null) {
      apiTokenWithLicence =
          ApiTokenWithLicence.fromJson(json.decode(apiTokenWithLicenceString));
      token = apiTokenWithLicence.newToken;
      conversationsLink = apiTokenWithLicence.conversationsLink;
    }

    var response;
    List scanDetailsList;
    try {
      response = await Api().postRequest(
          url: conversationsLink,
          body: json.encode(scan),
          headers: {
            "Authorization": "Bearer " + token,
            'content-type': 'application/json'
          });

      scanDetailsList = json.decode(response);

      print("response -> ${response}");

      if (scanDetailsList.isNotEmpty) {
        scanDetails = Scan.fromJson(scanDetailsList[0]);

//        print("scanDetails.updatedAt =>${scanDetails.updatedAt}");

        //TODO: Temporary fix to trim the last decimal to only limit to 3 digits.

//        scan.updatedAt=scan.updatedAt.substring(0,23)+"Z";
//        scanDetails.updatedAt=scanDetails.updatedAt.substring(0,23)+"Z";
//        print("scan.updatedAt =>${scan.updatedAt}");

        // If updatedAt is empty, uploading for 1st time or if the latest updatedAt is greater than what we have
//        if(scan.updatedAt.isEmpty || DateTime.parse(scanDetails.updatedAt).isAfter(DateTime.parse(scan.updatedAt))){
        print("scanDetails -> ${scanDetails}");
        scanDetails.uploaded = true;
        scanDetails.uploadedSuccessfullyOnce = true;

        scanDetails.id = scan.id;
//          scanDetails.extraFields = json.decode(scanDetails.extraFields);
        scanDetails.eEmbed.visitor.additionalEmail =
            scan.eEmbed.visitor.additionalEmail;
        scanModel.updateScanLocallyAndModel(scan: scanDetails, user: "user");
//        }

        return true;
      } else {
        print("No entity associated with the barcode");
        stopUpload();
        return false;
      }
    } on Exception catch (e) {
      print("e => ${e}");
//      stopUpload();
      if (netCheckSubscription != null) {
        netCheckSubscription.cancel();
      }
      scans.clear();
      return false;
//      apiResponseForScanDetails.error = e.runtimeType.toString() == 'SocketException'? "Connect to the Internet and try again.":e.toString();
    }
  }

  static stopUpload() {
// TODO: Determine where to stop the upload and begin again
    if (netCheckSubscription != null) {
      netCheckSubscription.cancel();
    }
    scans.clear();
    statFetchTimer?.cancel();
  }

  checkStatusOfScans() {}

  static checkInternet() async {
    ConnectivityResult currentConnectivity;

    currentConnectivity = await InternetCheck.getCurrentConnectivity();
    if (currentConnectivity == ConnectivityResult.mobile ||
        currentConnectivity == ConnectivityResult.wifi) {
      await scanModel.updateOnlineStatus(true);
      await statisticsModel.fetchStats();

//      if(scans.isNotEmpty){
      print("hereee");
      startUpload();
//      }

    } else {
      scanModel.updateOnlineStatus(false);
    }
    netCheckSubscription =
        InternetCheck.start().listen((ConnectivityResult status) async {
      print("status => ${status}");
      if (status == ConnectivityResult.mobile ||
          status == ConnectivityResult.wifi) {
        await scanModel.updateOnlineStatus(true);
        statFetchTimer = Timer.periodic(Duration(minutes: 2), (_) async {
          await statisticsModel.fetchStats();
          UploadService uploadService = UploadService(
              scansFromModel: scanModel.contactList);

          await uploadService.uploadScansInBackground();
          print("stat fetched");
        });
//          if(scans.isNotEmpty){
        print("hereee");
        startUpload();
//          }

      } else {
        await scanModel.updateOnlineStatus(false);
        statFetchTimer?.cancel();
        print("timer stopped");
      }
    });
  }

  uploadScansInBackground() async {
    ConnectivityResult currentConnectivity;
    currentConnectivity = await InternetCheck.getCurrentConnectivity();
    if (currentConnectivity == ConnectivityResult.mobile ||
        currentConnectivity == ConnectivityResult.wifi) {
      Timer(Duration(seconds: 30), () {
        stopUpload();
        BackgroundFetch.finish();
      });

      startUpload();
    } else {
      BackgroundFetch.finish();
    }
  }
}
