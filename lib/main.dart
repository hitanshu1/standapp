import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:standapp/data/scoped_model_scan.dart';
import 'package:standapp/models/apiTokenWithLicence.dart';
import 'package:standapp/models/eventDetails.dart';
import 'package:standapp/screens/ONLYUI.dart';
import 'package:standapp/screens/about.dart';
import 'package:standapp/screens/addBadges.dart';
import 'package:standapp/screens/allContacts.dart';
import 'package:standapp/screens/barcodeSacnner/barcodeCamera.dart';

//import 'package:standapp/screens/barcodeSacnner/barcodeCamera.dart';

import 'package:standapp/screens/dashboard.dart';
import 'package:standapp/screens/enterBarcodeManually.dart';
import 'package:standapp/screens/filter.dart';
import 'package:standapp/screens/guestSupport.dart';
import 'package:standapp/screens/keyActivationScreen/keyActivationScreen.dart';
import 'package:standapp/screens/landingScreen/landingScreen.dart';
import 'package:standapp/screens/license.dart';
import 'package:standapp/screens/menu.dart';
import 'package:standapp/models/contact.dart';
import 'package:standapp/screens/offlineAddBadge.dart';
import 'package:standapp/screens/pivot.dart';
import 'package:standapp/screens/registration/registration.dart';
import 'package:standapp/screens/support.dart';
import 'package:standapp/screens/termsAndCondition.dart';
import 'package:standapp/screens/tour.dart';
import 'package:standapp/services/uploadScans.dart';
import 'package:standapp/utils/colorConstants.dart';
import 'package:standapp/screens/guestMode.dart';
import 'package:standapp/screens/signUpError.dart';
import 'package:standapp/utils/screenRatio.dart';
import 'package:background_fetch/background_fetch.dart';


List<Contact> contacts = <Contact>[];
SharedPreferences prefs;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (prefs == null) {
    prefs = await SharedPreferences.getInstance();
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(new MyApp());
  });

  // Register to receive BackgroundFetch events after app is terminated.
  // Requires {stopOnTerminate: false, enableHeadless: true}
  BackgroundFetch.registerHeadlessTask(backgroundFetchHeadlessTask);
}

void backgroundFetchHeadlessTask() async {
  print('[BackgroundFetch] Headless event received.');

  onBackgroundFetch();
  BackgroundFetch.finish();
}


void onBackgroundFetch() async {
  // This is the fetch-event callback.
  print('[BackgroundFetch] Event received');
  String eventForValidKeyString = prefs.getString("eventForValidKey");
  Event eventDetails = Event();
  if(eventForValidKeyString!=null){
    eventDetails = Event.fromJson(json.decode(eventForValidKeyString));
  }

  print('Time of attempt => ${DateTime.now().toUtc()}');
  print('End date => ${eventDetails.eventEndDate}');


  if (scanModel.contactList.isEmpty) {
    if (prefs == null) {
      prefs = await SharedPreferences.getInstance();
    }

    if (prefs.getBool("guest") ?? true) {
      BackgroundFetch.finish();
    } else {
      String apiTokenWithLicenceString =
      prefs.getString("apiTokenWithLicence");
      ApiTokenWithLicence apiTokenWithLicence = ApiTokenWithLicence();


//      String eventForValidKeyString = prefs.getString("eventForValidKey");
      if (apiTokenWithLicenceString != null &&
          eventForValidKeyString != null) {
        apiTokenWithLicence = ApiTokenWithLicence.fromJson(
            json.decode(apiTokenWithLicenceString));
        await scanModel.restoreList(apiTokenWithLicence.newToken);
      }
      if(eventDetails!=null&&DateTime.now().toUtc().isBefore(eventDetails.eventEndDate)){
        UploadService uploadService = UploadService(
            scansFromModel: scanModel.contactList);

        await uploadService.uploadScansInBackground();
      }else{
        BackgroundFetch.finish();

      }
      

    }
  } else {
    if (prefs.getBool("guest") ?? true) {
      BackgroundFetch.finish();
    } else {
      if(eventDetails!=null&&DateTime.now().toUtc().isBefore(eventDetails.eventEndDate)) {
        UploadService uploadService = UploadService(
            scansFromModel: scanModel.contactList);

        await uploadService.uploadScansInBackground();
      }else{
        BackgroundFetch.finish();

      }
    }
  }


  // IMPORTANT:  You must signal completion of your fetch task or the OS can punish your app
  // for taking too long in the background.
//    BackgroundFetch.finish();
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() {
    return new MyAppState();
  }
}

class MyAppState extends State<MyApp> {

  @override
  initState() {
    super.initState();
    initPlatformState();
  }

  Future<void> initPlatformState() async {
    // Configure BackgroundFetch.
    BackgroundFetch.configure(BackgroundFetchConfig(
        minimumFetchInterval: 15,
        stopOnTerminate: false,
        enableHeadless: true,
        forceReload: false
    ), onBackgroundFetch).then((int status) {
      print('[BackgroundFetch] SUCCESS: $status');
    }).catchError((e) {
      print('[BackgroundFetch] ERROR: $e');
    });
//
//    // Optionally query the current BackgroundFetch status.
//    int status = await BackgroundFetch.status;


    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;
  }


  Brightness brightness = Brightness.light;

  @override
  Widget build(BuildContext context) {
    Map<String, WidgetBuilder> routes = {
      '/': (BuildContext context) {
        return Pivot();
      },
      //LandingScreen(),
      '/keyActivation': (BuildContext context) => KeyActivation(),
      '/landingScreen': (BuildContext context) => LandingScreen(),
      '/pivot': (BuildContext context) => Pivot(),
      '/registration': (BuildContext context) => Registration(),
      '/signUpError': (BuildContext context) => SignUpError(),
      '/guestMode': (BuildContext context) => GuestMode(),

      '/dashboard': (BuildContext context) => Dashboard(),

      '/menu': (BuildContext context) => MenuState(),
      '/addBadge': (BuildContext context) => AddBadge(),


      //TODO: Use only for UI dev
//      '/addBadge': (BuildContext context) => UIAddBadge(),


      '/addOfflineBadge': (BuildContext context) => AddOfflineBadge(),
      '/allContacts': (BuildContext context) => AllContacts(),

      '/barcodeCamera': (BuildContext context) => BarcodeCamera(),

      '/enterBarcodeManually': (BuildContext context) => EnterBarcodeManually(),
      '/Filter': (BuildContext context) => Filter(),
      '/Support': (BuildContext context) => Support(),
      '/GuestSupport': (BuildContext context) => GuestSupport(),
      '/About': (BuildContext context) => About(),
      '/TermsAndConditions': (BuildContext context) => TermsAndConditions(),
      '/License': (BuildContext context) => License(),
      '/Tour': (BuildContext context) => Tour(),
    };
    return MaterialApp(
      initialRoute: "/",
      routes: routes,
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: ColorConstants.primaryTextColor,
        fontFamily: 'Poppins',
        cursorColor: Colors.black,
      ),
      builder: (context, child) {
        return MediaQuery(
          child: child,
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
        );
      },
    );
  }


}
