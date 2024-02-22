import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseApi {
  final _firebaseMassaging = FirebaseMessaging.instance;
  Future<void> initNotification() async {
    await _firebaseMassaging.requestPermission();
    final fcmToken = await _firebaseMassaging.getToken();
    print("token:$fcmToken");
  }
}
