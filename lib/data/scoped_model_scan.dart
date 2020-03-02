import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/data/scoped_model_filter.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/models/extraFields.dart';
import 'package:standapp/models/response.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/services/Api.dart';
import 'package:standapp/services/config.dart';
import 'package:standapp/services/intermediateService.dart';
import 'package:uuid/uuid.dart';

class ScanModel extends Model {
  List<Scan> contactList = <Scan>[];

  Response apiResponseForScanDetails = Response();

  Scan currentScan = Scan();

  bool onlineStatus = true;

  storeScan({Scan scanToBeStored, String user}) async {
//    print("apiTokenWithLicence.newToken while writing to storage => ${user}");

    bool recordExists = false;
//
//    print("contactList=> ${contactList}");
//    var recordFoundOrNull =
//    contactList.singleWhere((aScanInScanList){
//      if(aScanInScanList.id == scanToBeStored.id||aScanInScanList.barCode==scanToBeStored.barCode){
//        return true;
//      }else{
//        return false;
//      }
//    },orElse: () => null);

    recordExists = searchIfScanAlreadyExists(scanToBeSearched: scanToBeStored);
//    print("type of decode => ${json.decode(scanToBeStored.extraFields).runtimeType.toString()}");

//    print("scanToBeStored.barCode 0=> ${scanToBeStored.barCode}");

    scanToBeStored.barCode =
        trimtrailingSpacesFromBarcode(scanToBeStored.barCode);

//    print("scanToBeStored.barCode 1=> ${scanToBeStored.barCode}");

    if (json.decode(scanToBeStored.extraFields).runtimeType.toString() !=
        "_InternalLinkedHashMap<String, dynamic>") {
      scanToBeStored.extraFields = json.decode(scanToBeStored.extraFields);
    }
    print("check 4 => ${scanToBeStored}");

    if (recordExists) {
      updateScanLocallyAndModel(scan: scanToBeStored, user: "user");
    } else {
      contactList.add(scanToBeStored);
      sortModel.populateSortedList(
          {"sortType": "name", "sortBy": "firstName", "isAsc": true},
          contactList);
      await Service.storageService(
          parameter: "scans", res: contactList, action: "write", user: user);
    }
    notifyListeners();
  }

  updateScanLocallyAndModel({Scan scan, user}) async {
    scan.barCode = trimtrailingSpacesFromBarcode(scan.barCode);

    print("scan to be updated => ${scan}");
    print("scan list => ${contactList}");
    String token;
    String conversationsLink;
    int indexOfScan = -1;

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

//    Scan scanDetails = Scan();
    String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
    ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

    if (apiTokenWithLicenceString != null) {
      apiTokenWithLicence =
          ApiTokenWithLicence.fromJson(json.decode(apiTokenWithLicenceString));

      token = apiTokenWithLicence.newToken;
      conversationsLink = apiTokenWithLicence.conversationsLink;
    }

    indexOfScan =
        searchIfScanAlreadyExists(scanToBeSearched: scan, needIndex: true);
    if (indexOfScan != -1) {
      contactList[indexOfScan] = scan;
      sortModel.populateSortedList(
          {"sortType": "name", "sortBy": "firstName", "isAsc": true},
          contactList);
      user == "user"
          ? await Service.storageService(
              parameter: "scans",
              res: contactList,
              action: "write",
              user: token)
          : null;
//      print("contact => ${contactList}");
    }

    notifyListeners();
  }

  restoreList(String user) async {
//    contactList = <Scan>[];
    List<Scan> contacts = <Scan>[];

    print("user in restore list => ${user}");
    try {
      contacts = await Service.storageService(
          parameter: "scans", action: "read", user: user);
    } catch (e) {
      print("Exception in restorList => $e");
    }
    contactList.addAll(contacts);

    notifyListeners();
  }

  fetchScanDetails(String barcode) async {
    apiResponseForScanDetails.data = null;
    apiResponseForScanDetails.error = null;
    var uuid = new Uuid().v4();

//    print("barCode 1=> ${json.encode({"barcode":"1223445"})}");

//    Trim spaces
    barcode = trimtrailingSpacesFromBarcode(barcode);

//    print("barCode 2=> ${barcode}");

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

//    ExtraFields extraFields = ExtraFields();
    currentScan = Scan.fromJson({
      "conversationAt": DateTime.now().toUtc().toString(),
      "barCode": barcode,
      "text": "-",
    });
    currentScan.id = uuid;
//    print("check 1a => ${currentScan}");

    int scanIndex = searchIfScanAlreadyExists(
        scanToBeSearched: currentScan, needIndex: true);
    if (scanIndex != -1) {
      print("exists");
      currentScan = contactList[scanIndex];
    } else {
      String token;
      String conversationsLink;

//    Scan scanDetails = Scan();
      String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
      ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

      if (apiTokenWithLicenceString != null) {
        apiTokenWithLicence = ApiTokenWithLicence.fromJson(
            json.decode(apiTokenWithLicenceString));

        token = apiTokenWithLicence.newToken;
        conversationsLink = apiTokenWithLicence.conversationsLink;
      }

      var response;
      List scanDetailsList;
//      print("check 1b => ${json.encode({"barcode": currentScan.barCode})}");

      var encodedCurrentScan = json.encode(currentScan);
//      print("check 1c => ${encodedCurrentScan}");

      try {
//      currentScan.id = uuid;

        //Upload restriction code
        // currentScan.numberOfAttempts++;

        response = await Api().postRequest(
            url: conversationsLink,
            body: encodedCurrentScan,
            headers: {
              "Authorization": "Bearer " + token,
              'content-type': 'application/json'
            });

        scanDetailsList = json.decode(response);

        //TODO: response returns multiple // in response due to json decode and encode
//        print("check 2a -> ${response}");
//        print("check 2b -> ${scanDetailsList}");

        if (scanDetailsList.isNotEmpty) {
          currentScan = Scan.fromJson(scanDetailsList[0]);
          currentScan.id = uuid;
          currentScan.uploaded = true;
          currentScan.uploadedSuccessfullyOnce = true;
          print("check 3 => ${currentScan}");
          storeScan(scanToBeStored: currentScan, user: token);

//        apiResponseForScanDetails.data= scanDetails.eEmbed.visitor.fullName;
//            print("scanDetails.barCode -> ${scanDetails.barCode}");

          apiResponseForScanDetails.error = null;
        } else {
          apiResponseForScanDetails.error =
              "No entity associated with the barcode";
        }
      } on Exception catch (e) {
        print("e in fetch => ${e}");
        apiResponseForScanDetails.error =
            e.runtimeType.toString() == 'SocketException'
                ? "Connect to the Internet and try again."
                : e.toString();
      }
    }
  }

  ScanModel() {
//    restoreList("guest");
  }

  String trimtrailingSpacesFromBarcode(String barcode) {
    barcode = ltrim(barcode);
    barcode = rtrim(barcode);
    return barcode;
  }

  /// trims leading whitespace
  String ltrim(String str) {
    return str.replaceFirst(new RegExp(r"^\s+"), "");
  }

  /// trims trailing whitespace
  String rtrim(String str) {
    return str.replaceFirst(new RegExp(r"\s+$"), "");
  }

  dynamic searchIfScanAlreadyExists(
      {Scan scanToBeSearched, bool needIndex = false}) {
    bool recordExists = false;
    var recordFoundOrNull;
    int indexOfscan = -1;
    if (needIndex) {
      indexOfscan = contactList.indexWhere((aScanInScanList) {
        if (aScanInScanList.id == scanToBeSearched.id ||
            aScanInScanList.barCode == scanToBeSearched.barCode) {
          print("record found with index");
          return true;
        } else {
          return false;
        }
      });

      print("indexOfscan => ${indexOfscan}");
    } else {
      recordFoundOrNull = contactList.singleWhere((aScanInScanList) {
        if (aScanInScanList.id == scanToBeSearched.id ||
            aScanInScanList.barCode == scanToBeSearched.barCode) {
          print("record found");
          return true;
        } else {
          return false;
        }
      }, orElse: () => null);
      recordExists = recordFoundOrNull == null ? false : true;
    }

    return needIndex ? indexOfscan : recordExists;
  }

  updateOnlineStatus(bool stat) {
    onlineStatus = stat;
    notifyListeners();
  }

  clear() {
    contactList = <Scan>[];
    currentScan = Scan();
    apiResponseForScanDetails = Response();
  }
}

ScanModel scanModel = new ScanModel();
