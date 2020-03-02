import 'dart:convert';

import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/models/eventDetails.dart';
import 'package:standapp/models/response.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/models/statistics.dart';
import 'package:standapp/services/Api.dart';
import 'package:standapp/services/config.dart';
import 'package:standapp/services/intermediateService.dart';

const String STATISTICS_ENDPOINT =
    "api/v2/events/TESTING/exhibitors/699eacd0-71f1-47ce-a6f5-31893201ab00/statistics";

class StatisticsModel extends Model {
  Statistics statistics = Statistics();
  Response apiResponse = Response();

  String webPageData = '';

  clear() {
    statistics = Statistics();
    apiResponse = Response();
  }

  fetchStats() async {
    apiResponse = Response();

    Event eventForValidKey;
    String statEndpoint;
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
    if (prefs != null) {
      var eventDetails = prefs.getString("eventForValidKey");
      eventForValidKey = Event.fromJson(json.decode(eventDetails));

      statEndpoint = eventForValidKey.lLinks.exhibitor + "/statistics";
    }

    String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
    ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

    if (apiTokenWithLicenceString != null) {
      apiTokenWithLicence =
          ApiTokenWithLicence.fromJson(json.decode(apiTokenWithLicenceString));
      var response;
      try {
        response = await Api().getRequest(url: (statEndpoint), headers: {
          "Authorization": "Bearer " + apiTokenWithLicence.newToken
        });

        print("response => ${response}");

        statistics = Statistics.fromJson(json.decode(response));
        print("stat => ${statistics.leadCount}");
        apiResponse.data = statistics;
        apiResponse.error = null;
      } on Exception catch (e) {
        statistics = Statistics(touchCount: 0, leadCount: 0);
        print("e => ${e}");
        apiResponse.error = e.runtimeType.toString() == 'SocketException'
            ? "Connect to the Internet to view Touches and Leads"
            : e.toString();
//      return apiResponse;
      }
    }
    print("type => ${apiResponse.data}");
    notifyListeners();
  }

  fetchStatisticsWebPage() async {
    apiResponse = Response();

    Event eventForValidKey;
    String statEndpoint;
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }
//    if(prefs!=null){
//      var eventDetails = prefs.getString("eventForValidKey");
//      eventForValidKey = Event.fromJson(json.decode(eventDetails));
//
//      statEndpoint = eventForValidKey.lLinks.exhibitor + "/statistics";
//    }

    String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
    ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

    if (apiTokenWithLicenceString != null) {
      apiTokenWithLicence =
          ApiTokenWithLicence.fromJson(json.decode(apiTokenWithLicenceString));
      var response;
      try {
        response = await Api().postRequest(
            url: config["DEVELOPMENT_BASE_URL"] + "api/v2/webview/statistics",
            headers: {
              "Authorization": "Bearer " + apiTokenWithLicence.newToken
            });

        print("response => ${response}");

        webPageData = response.toString();
        apiResponse.data = response.toString();
        apiResponse.error = null;
      } on Exception catch (e) {
        print("e => ${e}");
        apiResponse.error = e.runtimeType.toString() == 'SocketException'
            ? "Note: You currently don’t have an active connection, please connect to the internet to view this page"
            : e.toString();
      }
    }
    print("type => ${apiResponse.data}");
//    notifyListeners();
  }
}

StatisticsModel statisticsModel = new StatisticsModel();
