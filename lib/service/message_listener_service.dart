import 'package:blank_project/models/income_message.dart';
import 'package:blank_project/service/push_notification_service.dart';
import 'package:blank_project/service/web_socket_service.dart';

class MessageListenerService {
  bool initialized = false;

  IPushNotificationService notificationService =
      PushNotificationService();

  ISocketService socketService = SocketService();

  void initialize( Function(IncomeMessageModel message) onMessage,) {
    if (!initialized) {
      notificationService.initialisePushNotifications(onMessage);
      socketService.connectToWebSocketServer(onMessage);
      initialized = true;
    }
  }

  void disconnectSocket() {
    socketService.disconnectFromWebSocketServer();
  }

  Future<void> reconnectSocket(Function(IncomeMessageModel message) onMessage) async {
    await socketService.connectToWebSocketServer(onMessage);
  }
}
