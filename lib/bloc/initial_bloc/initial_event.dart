part of 'initial_bloc.dart';

abstract class InitialEvent extends Equatable {
  const InitialEvent();

  @override
  List<Object> get props => [];
}

class CheckCredentials extends InitialEvent {}
