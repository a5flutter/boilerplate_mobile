import 'package:blank_project/flavor/flavor_utils.dart';
import 'package:blank_project/models/income_message.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

abstract class IPushNotificationService {
  static const String onMessageChannel = 'onMessage';
  static const String onLaunchChannel = 'onLaunch';
  static const String onResumeChannel = 'onResume';
  static const String onBackgroundChannel = 'onBackground';

  Future initialisePushNotifications(
    Function(IncomeMessageModel message) onMessageReceived,
  );
}

class PushNotificationService extends IPushNotificationService {
  static final FirebaseMessaging _fcm = FirebaseMessaging.instance;
  late Function(IncomeMessageModel message) onMessageReceived;

  @override
  Future initialisePushNotifications(
    Function(IncomeMessageModel message) onMessageReceived,
  ) async {
    this.onMessageReceived = onMessageReceived;
    final token = await _fcm.getToken();
    devPrint('FirebaseMessaging token: $token');

    final initialMessage = await _fcm.getInitialMessage();
    if (initialMessage != null) {
      handleNotificationMessage(
        initialMessage,
        IPushNotificationService.onLaunchChannel,
      );
    }

    /// Setup for FCM in iOS with foreground mode
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: false,
      badge: false,
    );

    await _fcm.subscribeToTopic(
      FlavorConfig.instance.variables['fcm_topic'] as String,
    );

    FirebaseMessaging.onMessage.listen((message) {
      devPrint('Notification message, on message: $message');
      handleNotificationMessage(
        message,
        IPushNotificationService.onMessageChannel,
      );
    });

    FirebaseMessaging.onMessageOpenedApp.listen((message) async {
      devPrint('Notification message, on messageOpenedApp: $message');
      handleNotificationMessage(
        message,
        IPushNotificationService.onLaunchChannel,
      );
    });
  }

  void handleNotificationMessage(RemoteMessage message, String channel) {
    ///Handling PushNotification example
    try {
        onMessageReceived(
        IncomeMessageModel(
          action: message.data['event'] as String?,
          body: message.notification?.body,
          title: message.notification?.title,
          params: ParamsModel.fromJson(message.data),
        ),
      );
    } catch (e) {
      devPrint(
        'Handle notification message, Error decoding notification message - $e',
      );
    }
  }

  static Future<dynamic> backgroundMessageHandler(
    Map<String, dynamic> message,
  ) async {
    devPrint('Notification message received in background: $message');
  }
}
