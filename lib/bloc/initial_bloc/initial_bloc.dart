import 'dart:async';

import 'package:blank_project/flavor/flavor_utils.dart';
import 'package:blank_project/repository/secure_local_storage.dart';
import 'package:blank_project/repository/shared_preferences.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'initial_state.dart';

part 'initial_event.dart';

class InitialBloc extends Bloc<InitialEvent, InitialState> {
  InitialBloc() : super(InitialInitial()) {
    on<CheckCredentials>((event, emit) async {
      // TODO(anybody): implement initialization checks here
      final authModel = await secureStorage.getTokens();
      if (authModel != null &&
          authModel.accessToken != null &&
          authModel.accessToken!.isNotEmpty && !(await checkFirstStart())) {
      devPrint('auth token = ${authModel.accessToken}');
      await Future.delayed(const Duration(seconds: 1));
      emit (Authorized());
      } else {
      emit (NotAuthorized());
      // TODO(anybody): remove code below when no need more
      await Future.delayed(const Duration(seconds: 1));
      emit (Authorized());
      }
    });
  }

  SecureLocalStorage secureStorage = SecureLocalStorage();
  ILocalStorage localStorage = LocalStorage();

  Future<bool> checkFirstStart() async {
    final flag = await localStorage.get('firstStarted');
    if (flag == null || flag.isEmpty ){
      await secureStorage.removeTokens();
      await secureStorage.remove('idUser');
      localStorage.save('firstStarted', 'started');
      return true;
    }
    return false;
  }
}
