import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/main.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/models/dynamicQuestions.dart';
import 'package:standapp/models/response.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/services/Api.dart';
import 'package:standapp/services/config.dart';
import 'package:standapp/services/intermediateService.dart';

const String QUESTIONS_ENDPOINT = "api/v2/questions";

class QuestionsModel extends Model {
  Response apiResponseForScanDetails = Response();

  DynamicQuestions dynamicQuestions = DynamicQuestions(
//      questions: [
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": true,
//      "order": 1
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email1",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": true,
//      "order": 5
//    }),
//    Questions.fromJson({
//      "key": "DEF-8A55-C4D6",
//      "label":"purchasingAuthority",
//      "text": "Purchasing authority",
//      "inputControl": {"type": "YesNo", "options": []},
//      "required": false,
//      "order": 0
//    }),
//    Questions.fromJson({
//      "key": "DEF-731A-F87E",
//      "label": "Notes",
//      "inputControl": {"type": "TextArea", "options": []},
//      "required": false,
//      "order": 2
//    }),
//
//    Questions.fromJson({
//      "key": "DEF-B991-6E2F",
//      "label": "levelOfInterest",
//      "text": "Level of Interest?",
//      "inputControl": {
//        "type": "SingleComboBox",
//        "options": [
//          {
//            "label": "Low",
//            "value": "low",
//            "order": 2
//          },
//          {
//            "label": "Moderate",
//            "value": "moderate",
//            "order": 1
//          },
//          {
//            "label": "Strong",
//            "value": "strong",
//            "order": 0
//          }
//        ]
//      },
//      "required": false,
//      "order": 3
//    }),
//    Questions.fromJson({
//      "key": "DEF-BDCF-8C6R",
//      "label":"favouriteCars",
//      "text": "What are your favourite cars?",
//      "inputControl": {
//        "type": "MultiComboBox",
//        "options": [
//          {
//            "label": "Ferrari",
//            "value": "ferrari italy",
//            "order": 0
//          },
//          {
//            "label": "Lamborgini",
//            "value": "lamborgini italy",
//            "order": 1
//          },
//          {
//            "label": "Mclaren",
//            "value": "mclaren uk",
//            "order": 2
//          },
//          {
//            "label": "Bugatti",
//            "value": "bugatti italy",
//            "order": 3
//          }
//        ]
//      },
//      "required": true,
//      "order": 4
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email2",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email3",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email4",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email5",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email6",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email7",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email8",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email9",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email10",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email11",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email12",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email13",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email14",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email15",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email16",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email17",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email18",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email19",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email20",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//    Questions.fromJson({
//      "key": "DEF-6C6E-90DB",
//      "label":"Email21",
//      "text": "Alternate email address",
//      "inputControl": {"type": "TextBox", "options": []},
//      "required": false,
//      "order": 10
//    }),
//
//
//
//  ]
  );

  fetchQuestions() async {


    apiResponseForScanDetails.data = null;
    apiResponseForScanDetails.error = null;
    dynamicQuestions = DynamicQuestions();



    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    String apiTokenWithLicenceString = prefs.getString("apiTokenWithLicence");
    ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();

    String token;

    if (apiTokenWithLicenceString != null) {
      apiTokenWithLicence =
          ApiTokenWithLicence.fromJson(json.decode(apiTokenWithLicenceString));
      token = apiTokenWithLicence.newToken;
    }

    var response;


    try {
      response = await Api().getRequest(
          url: (config["DEVELOPMENT_BASE_URL"] + QUESTIONS_ENDPOINT),
          headers: {
            "Authorization": "Bearer " + token,
            'content-type': 'application/json'
          });



      dynamicQuestions = DynamicQuestions.fromJson(jsonDecode(response));


      debugPrint("dynamicQuestions =>${response}");

//      if(scanDetailsList.isNotEmpty) {
//
//        apiResponseForScanDetails.error =null;
//      }else{
//        apiResponseForScanDetails.error = "No entity associated with the barcode";
//      }

    } on Exception catch (e) {
      print("e => ${e}");
      apiResponseForScanDetails.error = e.runtimeType.toString() == 'SocketException'? "Connect to the Internet and try again.":e.toString();
    }
  }

//  UploadModel(){
//
//  }
}

QuestionsModel questionsModel = new QuestionsModel();
