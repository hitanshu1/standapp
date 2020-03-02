
import 'dart:async';

import 'package:connectivity/connectivity.dart';


class InternetCheck {
//  static var _connectionStatus = 'Unknown';
  static Connectivity connectivity;
  static Connectivity currentConnectivity=Connectivity();
  static Stream<ConnectivityResult> subscription;

  static Stream<ConnectivityResult> start(){
    connectivity = new Connectivity();
    subscription =
        connectivity.onConnectivityChanged;
    return subscription;
  }

  static Future<ConnectivityResult> getCurrentConnectivity()async{
    return await currentConnectivity.checkConnectivity();
  }

}