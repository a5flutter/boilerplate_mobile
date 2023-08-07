import 'package:blank_project/models/income_message.dart';
import 'package:blank_project/service/message_listener_service.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

///Bloc for listening PushNotifications and web sockets
///Dynamic link listener can be added here as well

part 'income_messages_event.dart';

part 'income_messages_state.dart';

class IncomeMessagesBloc
    extends Bloc<PushNotificationsEvent, IncomeMessagesState> {

  IncomeMessagesBloc(): super(const IncomeMessagesState()) {
    on<MessagesInitialized>((_, __) async {
      messageListenerService.initialize(onMessageReceived);
    });
    on<NotificationReceived>((event, emit) {
      emit(MessagesInitialState());
      emit(MessageReceived(event.message));
    });
    on<WebSocketDisconnected>((event, emit) {
      messageListenerService.disconnectSocket();
    });
    on<WebSocketReconnected>((event, emit) async {
      await messageListenerService.reconnectSocket(onMessageReceived);
    });
  }

  final messageListenerService = MessageListenerService();

  void onMessageReceived(IncomeMessageModel message) {
    add(NotificationReceived(message));
  }
}
