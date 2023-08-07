import 'package:flutter/material.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:sentry_flutter/sentry_flutter.dart';

bool isDev(){
  return FlavorConfig.instance.variables['environment'] == 'development';
}

void devPrint (String str){
  if (isDev()){
    debugPrint(str);
  }
}

Future<void> postSentry (dynamic error, dynamic stackTrace) async {
  if (isDev()){
    await Sentry.captureException(
      error,
      stackTrace: stackTrace,
    );
  }
}

