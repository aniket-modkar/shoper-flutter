import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shoper_flutter/core/service/storage-service.dart';

class FirebaseApi {
  final _firebaseMassaging = FirebaseMessaging.instance;
  final StorageService _storageService = StorageService();

  Future<void> initNotification() async {
    try {
      // Request permission for receiving notifications
      await _firebaseMassaging.requestPermission();

      // Get the FCM token
      final fcmToken = await _firebaseMassaging.getToken();

      // Print the FCM token
      print("FCM Token: $fcmToken");
      _storageService.saveResponseToLocalStorage('FCM Token', fcmToken!);
    } catch (e) {
      // Handle any errors that occur during Firebase Messaging operations
      print("Error initializing notifications: $e");
      // You can choose to log the error, display a user-friendly message,
      // or perform other error handling actions based on your requirements.
    }
  }
}
