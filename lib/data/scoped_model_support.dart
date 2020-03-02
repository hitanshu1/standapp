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
import 'package:standapp/models/supportForm.dart';
import 'package:standapp/models/user.dart';
import 'package:standapp/services/Api.dart';
import 'package:standapp/services/config.dart';
import 'package:standapp/services/intermediateService.dart';

const String STATISTICS_ENDPOINT =
    "api/v2/events/TESTING/exhibitors/699eacd0-71f1-47ce-a6f5-31893201ab00/statistics";

class SupportModel extends Model {
  SupportForm supportForm = SupportForm();
  Response apiResponse = Response();

  String emailHTMLData = '';

  clear() {
    supportForm = SupportForm();
    apiResponse = Response();
  }

  submitForm(Map supportFormFromUI) async {
    apiResponse = Response();

    User user;

    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    if (prefs != null) {
      if(prefs.getString("user")!=null) {
        user = User.fromJson(json.decode(prefs.getString("user")));
      }
    }

    supportForm = SupportForm.fromJson({
      "key": "rOPosPnDlDhYnJfi6930TA",
      "message": {
        "html":
            "<h3>Konduko StandApp Support Request</h3>"
                " <p>Date Time Sent: ${DateTime.now().toUtc()}</p> <p>Event Key: ${user?.licenceKey}</p> <p>Event Name: ${user?.eventName}</p> <p>License ID: ${user?.licenseId}</p> "
                "<p><strong>Request</strong></p> "
                "<p>Sent By: ${supportFormFromUI["Name"]}</p> <p>Company: ${supportFormFromUI["Company"]}</p> <p>Email Address: ${supportFormFromUI["emailAddress"]}</p>"
                " <p>Phone: ${supportFormFromUI["phoneNumber"]}</p> <p>Notes:<br />${supportFormFromUI["notes"]}</p>",
        "subject": "StandApp Support ${user?.licenceKey} ${user?.ownersName}",
        "from_email": "noreply@konduko.com",
        "from_name": "Konduko StandApp",
        "to": [
          {
            "email": "support@konduko.com",
            "name": "Konduko Support",
            "type": "to"
          }
        ],
        "headers": {"Reply-To": "support@konduko.com"},
        "important": false,
        "track_opens": null,
        "track_clicks": null,
        "auto_text": null,
        "auto_html": null,
        "inline_css": null,
        "url_strip_qs": null,
        "preserve_recipients": null,
        "view_content_link": null,
        "tracking_domain": null,
        "signing_domain": null,
        "return_path_domain": null,
        "merge": true,
        "tags": ["standapp"]
      },
      "async": false
    });

    var response;
    try {
      response = await Api().postRequest(
        url: "https://mandrillapp.com/api/1.0/messages/send.json",
        body: json.encode(supportForm),
      );

      print("response => ${response}");

        apiResponse.data = response.toString();
      apiResponse.error = null;
    } on Exception catch (e) {
      print("e => ${e}");
      apiResponse.error = e.runtimeType.toString() == 'SocketException'
          ? "Note: You currently don’t have an active connection, please connect to the internet"
          : e.toString();
//      return apiResponse;
    }

//    print("type => ${apiResponse.data}");
    notifyListeners();
  }
}

SupportModel supportModel = new SupportModel();
