import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/models/eventDetails.dart';
import 'package:standapp/models/response.dart';
import 'package:standapp/models/user.dart';
import 'package:standapp/services/Api.dart';
import 'package:standapp/services/config.dart';
import 'package:standapp/services/intermediateService.dart';

const String REGISTRATION_ENDPOINT = "api/v2/register-stand-app";
const String REVOKE_LICENSE = "api/v2/revoke-license";

class KeyRegModel extends Model {
  String activationKey;
  Event eventForValidKey = Event(
      companyName: "Konduko SA",
      eventName: "No current event",
      venueName: "Dubai World Trade Centre",
      eventStartDate: DateTime.parse("2018-12-12T00:00:00Z"),
      eventEndDate: DateTime.parse("2018-12-12T00:00:00Z"));
  ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

  bool licenceAvailable = false;

  User user = User();

  String newToken = "";
  String licenseId = "";

  Response apiResponse = Response();

  clear() {
    activationKey = 'BBB8-DC21';
    eventForValidKey = Event(
        companyName: "Konduko SA",
        eventName: "Middle East Electricity 2019",
        venueName: "Dubai World Trade Centre",
        eventStartDate: DateTime.parse("2018-12-12T00:00:00Z"),
        eventEndDate: DateTime.parse("2018-12-12T00:00:00Z"));
    apiTokenWithLicence = ApiTokenWithLicence();

    licenceAvailable = false;

    user = User();

    newToken = "";
    licenseId = "";
    apiResponse = Response();
  }

  static KeyRegModel of(BuildContext context) =>
      ScopedModel.of<KeyRegModel>(context);

  checkKeyValidity() async {
//    eventForValidKey = Event();

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    apiResponse = Response();
    var response;
    try {
      response = await Api().getRequest(
          url: (config["DEVELOPMENT_BASE_URL"] + REGISTRATION_ENDPOINT),
          headers: {"Authorization": "Bearer " + activationKey});

      prefs.setString("eventForValidKey", response);

      eventForValidKey = Event.fromJson(json.decode(response));

//      await Service.storageService(action: "deleteAll",user: "guest",parameter: "scans");
//
//      scanModel.contactList.clear();
      licenceAvailable = eventForValidKey.licenceCountRemaining > 0;
//      print("true or false => ${eventForValidKey.licenceCountRemaining > 0}");
//      licenceAvailable = false;
      apiResponse.data = eventForValidKey;
    } on Exception catch (e) {
      print("e => ${e.toString()}");
      apiResponse.error = e.runtimeType.toString() == 'SocketException'
          ? "Connect to the Internet and try again."
          : e.toString();
//      return apiResponse;
    }

    print("type => ${apiResponse.data}");
    notifyListeners();
//    return apiResponse;
  }

  fetchNewToken(Map body) async {
//    apiResponse = Response();

    if (licenceAvailable) {
      if (prefs == null) {
        prefs = await SharedPreferences.getInstance();
      }

      var response;
      try {
        response = await Api().postRequest(
            url: (config["DEVELOPMENT_BASE_URL"] + REGISTRATION_ENDPOINT),
            body: json.encode(body),
            headers: {
              "Authorization": "Bearer " + activationKey,
              'content-type': 'application/json'
            });
//      response = {
//        "newToken": "4d508962-b4fe-40fd-b61e-3cec8b6c1ef3",
//        "conversationsLink": "http://api-v3-dev.konduko.com/api/v2/events/TESTING/exhibitors/699eacd0-71f1-47ce-a6f5-31893201ab00/conversations",
//        "licenceId": "6967c36f-d427-473d-a0ad-785459546c90"
//      };

        apiTokenWithLicence =
            ApiTokenWithLicence.fromJson(json.decode(response));
//      apiTokenWithLicence = ApiTokenWithLicence.fromJson(response);

        prefs.setString(
            "apiTokenWithLicence", json.encode(apiTokenWithLicence));
        newToken = apiTokenWithLicence.newToken;
        licenseId = apiTokenWithLicence.licenceId;

        user.companyName = eventForValidKey.companyName;
        user.eventName = eventForValidKey.eventName;
        user.venueTimezone = eventForValidKey.venueTimezone;
        user.venueName = eventForValidKey.venueName;
        user.licenceKey = activationKey;
        user.licenseId = apiTokenWithLicence.licenceId;
        user.token = apiTokenWithLicence.newToken;
        user.registrationDate = DateTime.now().toUtc().toString();
        print("user.registrationDate => ${user.registrationDate}");
        prefs.setString("user", json.encode(user.toJson()));

//        apiResponse.data = apiTokenWithLicence;
        apiResponse.error = null;
      } on Exception catch (e) {
        print("e => ${e.toString()}");

        apiResponse.error = e.runtimeType.toString() == 'SocketException'
            ? "Connect to the Internet and try again."
            : e.toString();
      }
    } else {
      apiResponse.error = "No more available Licences for this key";
    }
  }

  revokeLicence(User user) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    apiResponse = Response();
    var response;
    try {
      response = await Api().postRequest(
          url: (config["DEVELOPMENT_BASE_URL"] + REVOKE_LICENSE),
          headers: {
            "Authorization": "Bearer " + user.token,
            'content-type': 'application/json'
          },
          body: json
              .encode({"key": user.licenceKey, "licenseId": user.licenseId}),
          needStatusCode: true);
    } on Exception catch (e) {
      print("e => ${e.runtimeType.toString() == 'SocketException'}");
      apiResponse.error = e.runtimeType.toString() == 'SocketException'
          ? "Connect to the Internet and try again."
          : e.toString();
//      return apiResponse;
    }

    if (response == 200) {
      apiResponse.data = true;
    } else if (response == 400) {
      apiResponse.error = "License is already revoked";
    }

    return apiResponse;
  }
}

KeyRegModel keyRegModel = new KeyRegModel();

String dateIntToStringMonth(int monthInInt) {
  String monthInString = "";

  switch (monthInInt) {
    case 1:
      monthInString = "January";
      break;
    case 2:
      monthInString = "February";
      break;
    case 3:
      monthInString = "March";
      break;
    case 4:
      monthInString = "April";
      break;
    case 5:
      monthInString = "May";
      break;
    case 6:
      monthInString = "June";
      break;
    case 7:
      monthInString = "July";
      break;
    case 8:
      monthInString = "August";
      break;
    case 9:
      monthInString = "September";
      break;
    case 10:
      monthInString = "October";
      break;
    case 11:
      monthInString = "November";
      break;
    case 12:
      monthInString = "December";
      break;
  }

  return monthInString;
}
