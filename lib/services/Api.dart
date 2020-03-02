library api_service_package;

import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  Future<dynamic> getRequest({String url, Map<String, String> headers}) {

    print("url in get=>${url}");
    print("headers in get=>${headers}");

    return http.get(url, headers: headers).then((http.Response response) {
      final res = response.body;
      final int statusCode = response.statusCode;

      print("response in get=>${response.body}");
      print("statusCode in get=>${statusCode}");


      if (statusCode < 200 || statusCode > 400 || json == null) {
        if (statusCode == 401) {
          throw new Exception(
              "Invalid Key. Contact support");
        } else {
          throw new Exception("Error while fetching data");
        }
      }
      return res;
    });
  }

//  Future<dynamic> getRequestWithBody(String url) {
//    return http.get(url).then((http.Response response) {
//      final res = response.body;
//      final int statusCode = response.statusCode;
//
//      if (statusCode < 200 || statusCode > 400 || json == null) {
//        throw new Exception("Error while fetching data");
//      }
//      return res;
//    });
//  }

  Future<dynamic> postRequest({String url, Map<String, String> headers, body,bool needStatusCode = false}) {
    print("url: ${url}");
    print("headers: ${headers}");
    print("body: ${body}");

    return http
        .post(
      url,
      body: body,
      headers: headers,


//    {"Authorization":"Bearer "+eventKey,'content-type': 'application/json'},
    )
        .then((http.Response response) {
      final String res = response.body;
      final int statusCode = response.statusCode;
      print("response in post=>${response.body}");


      print(statusCode);
      if (statusCode < 200 || statusCode > 400 || json == null) {
        throw new Exception("Error while fetching data");
      }
      return needStatusCode? statusCode:
       res;
    });
  }
}
