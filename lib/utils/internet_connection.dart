import 'package:connectivity_plus/connectivity_plus.dart';

class InternetConnection {
  static Future<bool> internetConnection() async {
    final currentConnection = await Connectivity().checkConnectivity();

    return currentConnection != ConnectivityResult.none;
  }
}
