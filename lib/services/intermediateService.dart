import 'dart:io';

 import 'package:file_service/file_service.dart';
 import 'package:file_service/file_cyper.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/models/scan.dart';
import 'package:standapp/services/Api.dart';
import './config.dart';
import 'dart:convert';
import 'config.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:crypto/crypto.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

class Service {
  static SharedPreferences prefs;
  static var fileKey;

// return the data either from api or local file based on session
  static Future<dynamic> intermediateService(
      {String parameter, bool noCache, bool refresh, Map res}) async {

  }

  //fetch and write from/to file storage for guest mode

  static storageService(
      {String parameter,
      String user,
      bool noCache,
      bool refresh,
      List res,
      String action}) async {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    if (prefs.getString("key") == null) {
       String key = await FileCypher.getRandomKey();
       prefs.setString("key", key);
    }

    if (action == "write") {
      var result;
      var encodedRes = json.encode(res);
      print("check 5 => ${encodedRes}");
      print("user while writing => ${hashConversion(user)}");

// f688cf7524405baa8edb19d2d508fdadc444c1151664b5f5766f24239a675473/96bac2b1fa8ef1b40f0705fc126c970cd9721715411e221b40d39da7e9779a1d
      try {
         result = await FileService.writeFile(
             path: "${hashConversion(user)}/${hashConversion(parameter)}",
             jsonString: encodedRes,
 //          jsonString: res.toString(),
             key: prefs.getString("key"));
      } catch (e) {
        print(e);
        return result;
      }
      return result;
    } else if (action == "read") {
      List<Scan> contacts = <Scan>[];
      var result;

      print("user => ${user}");
      print("parameter => ${parameter}");

      print(
          "reading from path => ${hashConversion(user)}/${hashConversion(
              parameter)}");

      try {
         result = await FileService.readFile(
             path: "${hashConversion(user)}/${hashConversion(parameter)}",
             key: prefs.getString("key"));
//        if (result. != "File Not Found") {
        print("reading result => ${result}");

        List<dynamic> mapContacts = json.decode(result);

        mapContacts.forEach((map) {
          contacts.add(Scan.fromJson(map));
        });
//        }
      } catch (e) {
        throw e;
//        print("here is the exception inside read => ${result.message}");
//        return contacts;
      }
//      print("result => ${result.message}");
//
//
//      print("prefs.getString('key') => ${prefs.getString("key")}");
//      print("result => ${result}");

      return contacts;
    } else if (action == "deleteAll") {
      var result;
      try {
        var pathWhileDeleting = await hashConversion(user);
        print("path while deleting => ${pathWhileDeleting}");

         result = await FileService.deleteAll(folder: pathWhileDeleting);
        print("result deleting => ${result}");
      } catch (e) {
        print("here is the exception inside delete=> ${e}");
        return false;
      }
//      print("prefs.getString('key') => ${prefs.getString("key")}");
//      print("result => ${result}");

      return true;
    }
  }

// convert a string in to Hash
  static hashConversion(String value) {
    if (fileKey == null) {
      fileKey = utf8.encode("guest");
    }
    var bytes = utf8.encode(value);
    var hmacSha256 = new Hmac(sha256, fileKey); // HMAC-SHA256

    return hmacSha256.convert(bytes).toString();
  }
}
