import 'dart:async';
import 'package:blank_project/application.dart';
import 'package:blank_project/bloc/income_messages_bloc/income_messages_bloc.dart';
import 'package:blank_project/bloc/initial_bloc/initial_bloc.dart';
import 'package:blank_project/flavor/flavor_config.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  ///Launch parameters for configure different environment
  ///--dart-define="ENV=develop"
  ///--dart-define="ENV=staging"
  ///Empty parameters will configure production

  const env = String.fromEnvironment('ENV');
  Config.setEnvironment(env);

  // await Firebase.initializeApp();
  // await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
  //   alert: true,
  //   badge: true,
  //   sound: true,
  // );

  // FlutterError.onError = (FlutterErrorDetails details) async {
  //   if (kReleaseMode) {
  //     await Sentry.captureException(details.exception,
  //         stackTrace: details.stack);
  //   } else {
  //     FlutterError.dumpErrorToConsole(details);
  //   }
  // };

  // runZonedGuarded(() async {
  //   await SentryFlutter.init(
  //         (options) {
  //       options.dsn = FlavorConfig.instance.variables['sentry_dsn'] as String;
  //       options.environment =
  //       FlavorConfig.instance.variables['environment'] as String;
  //     },
  //   );
  runApp(BlankApp());
  // }, (exception, stackTrace) async {
  //   if (kReleaseMode) {
  //     await Sentry.captureException(exception, stackTrace: stackTrace);
  //   }
  // });
}

// TODO(Anybody): check needs of notification channel
// /// Create a [AndroidNotificationChannel] for heads up notifications
// const AndroidNotificationChannel channel = AndroidNotificationChannel(
//   'high_importance_channel', // id
//   'High Importance Notifications', // title
//   'This channel is used for important notifications.', // description
//   importance: Importance.high,
// );

class BlankApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => InitialBloc()),
        BlocProvider(create: (context) => IncomeMessagesBloc()),
      ],
      child: Application(),
    );
  }
}
