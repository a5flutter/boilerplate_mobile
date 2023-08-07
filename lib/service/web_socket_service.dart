import 'dart:convert';
import 'package:blank_project/flavor/flavor_utils.dart';
import 'package:blank_project/models/income_message.dart';
import 'package:blank_project/repository/secure_local_storage.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:web_socket_channel/io.dart';

///WebSocket listening
abstract class ISocketService {
  Future<void> connectToWebSocketServer(
      Function(IncomeMessageModel message) onMessage,);

  void disconnectFromWebSocketServer();
}

class SocketService extends ISocketService {
  Function(IncomeMessageModel message)? onMessage;
  IOWebSocketChannel? socketChannel;
  bool needToReconnect = true;

  @override
  Future<void> connectToWebSocketServer(
      Function(IncomeMessageModel message) onMessage,) async {
    needToReconnect = true;

    final tokens = await SecureLocalStorage().getTokens();
    final accessToken = tokens?.accessToken;
    if (accessToken == null){
      return;
    }

    if (socketChannel != null){
      disconnectFromWebSocketServer();
    }
    final url = '${FlavorConfig.instance.variables['socket_url']}?auth_token=$accessToken';

    socketChannel = IOWebSocketChannel.connect(url);
    socketChannel?.stream.listen((message) {
        try{
          ///{\"event\": \"NOTIFICATION\", \"action\": \"ACCOUNT_ACCESS_REMOVED\", \"params\": {\"account_id\": 54}}
          ///{\"event\": \"NOTIFICATION\", \"action\": \"ACCREDITATION_REVOKED\", \"params\": null}
          final jsonData = jsonDecode(message.toString()) as Map<String, dynamic>;
          onMessage(IncomeMessageModel.fromJson(jsonData));
        } catch (error, stackTrace) {
          postSentry(error, stackTrace);
        }

    }, onError: (error, stackTrace) async {
      await postSentry(error, stackTrace);
    }, onDone: () async {
      if (needToReconnect) {
        await Future.delayed(const Duration(seconds: 10));
        connectToWebSocketServer(onMessage);
      }
    },);
  }

  @override
  void disconnectFromWebSocketServer() {
    needToReconnect = false;
    socketChannel?.sink.close();
    socketChannel = null;
  }
}
