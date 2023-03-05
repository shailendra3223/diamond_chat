import 'package:firebase_messaging/firebase_messaging.dart';

class FirebaseMessagingService {
  final FirebaseMessaging _fcm = FirebaseMessaging.instance;

  var data = <String,String>{
    "message":"test"
  };

  Future sendNotification(String title, String body, String? fcmToken) async {
    // Create a message to send
    final message = <String, dynamic>{
      'notification': <String, dynamic>{
        'title': title,
        'body': body,
        'sound': 'default',
      },
      'priority': 'high',
      'data': <String, dynamic>{
        'click_action': 'FLUTTER_NOTIFICATION_CLICK',
        'id': '1',
        'status': 'done'
      },
      'to': fcmToken,
    };

    // Send the message
    try {
      await _fcm.sendMessage(to: fcmToken,data: data);
    } catch (e) {
      print('Error sending message: $e');
    }
  }
}
