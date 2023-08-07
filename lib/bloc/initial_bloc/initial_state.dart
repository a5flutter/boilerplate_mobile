part of 'initial_bloc.dart';

abstract class InitialState extends Equatable {
  @override
  List<Object> get props => [];
}

class InitialInitial extends InitialState {}

class Authorized extends InitialState{}

class NotAuthorized extends InitialState{}

class FirstStarted extends InitialState{}
