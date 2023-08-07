part of 'income_messages_bloc.dart';

abstract class PushNotificationsEvent extends Equatable {
  const PushNotificationsEvent();

  @override
  List<Object> get props => [];
}

class MessagesInitialized extends PushNotificationsEvent {}

class WebSocketReconnected extends PushNotificationsEvent {}

class WebSocketDisconnected extends PushNotificationsEvent {}

class NotificationReceived extends PushNotificationsEvent {
  const NotificationReceived(this.message);

  final IncomeMessageModel message;
}
