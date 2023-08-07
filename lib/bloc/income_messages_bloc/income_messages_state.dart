part of 'income_messages_bloc.dart';

class IncomeMessagesState extends Equatable {
  const IncomeMessagesState();

  @override
  List<Object> get props => [];
}

class MessageReceived extends IncomeMessagesState {
  const MessageReceived(this.message);

  final IncomeMessageModel message;
}

class MessagesInitialState extends IncomeMessagesState {}
