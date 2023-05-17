import 'package:agrivoltaics_flutter_app/app_constants.dart';
import 'package:agrivoltaics_flutter_app/pages/home/notifications.dart';
import 'package:flutter/material.dart';
import 'package:timezone/timezone.dart' as tz;

/*

App State
- Contains any data persisted while the application is open

*/
class AppState extends ChangeNotifier {
  AppState() {
    this.timezone = tz.getLocation(AppConstants.timezone);
  }
  
  // Settings
  late tz.Location timezone;
  List<int> sites = [];

  // Notifications
  List<AppNotification> notifications = [];

  void finalizeState() {
    notifyListeners();
  }
}