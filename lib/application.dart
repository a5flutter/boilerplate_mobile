import 'dart:async';

import 'package:blank_project/bloc/income_messages_bloc/income_messages_bloc.dart';
import 'package:blank_project/bloc/initial_bloc/initial_bloc.dart';
import 'package:blank_project/http/http_errors.dart';
import 'package:blank_project/i18n/app_localization.dart';
import 'package:blank_project/ui/navigation/routes.dart';
import 'package:blank_project/ui/navigation/screens.dart';
import 'package:blank_project/ui/screens/main_screen/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

///Global keys for using Navigator and context access
final GlobalKey<NavigatorState> rootNavigatorKey = GlobalKey<NavigatorState>();
GlobalKey<MainScreenState> mainScreenKey = GlobalKey<MainScreenState>();

bool mainScreenInScope = false;

class Application extends StatefulWidget {
  @override
  _ApplicationState createState() => _ApplicationState();
}

class _ApplicationState extends State<Application> {
  late InitialBloc initialBloc;
  late StreamSubscription<String> httpErrorsSubscription;

  @override
  void initState() {
    subscribeHttpErrorMessages();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    initialBloc = BlocProvider.of<InitialBloc>(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    httpErrorsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<InitialBloc, InitialState>(
      listener: (context, state) {
        // TODO(anybody): implement initial state here
        if (state is Authorized) {
          WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
            rootNavigatorKey.currentState!.pushReplacementNamed(Screens.main);
          });
          return;
        }
        if (state is NotAuthorized) {
          return;
        }
        if (state is FirstStarted) {
          return;
        }
      },
      child: BlocListener<IncomeMessagesBloc, IncomeMessagesState>(
        listener: (context, state) {
          ///Listen income messages here
        },
        child: MaterialApp(
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
            child: child!,
          ),
          navigatorKey: rootNavigatorKey,
          onGenerateRoute: generateRoute,
          routes: appRoutes,
          localizationsDelegates: const [
            LocalizationDelegate(),
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          localeResolutionCallback: (locale, supportedLocales) {
            for (final supportedLocale in supportedLocales) {
              if (supportedLocale.languageCode == locale?.languageCode &&
                  supportedLocale.countryCode == locale?.countryCode) {
                return supportedLocale;
              }
            }
            return supportedLocales.first;
          },
        ),
      ),
    );
  }

  MaterialPageRoute generateRoute(RouteSettings routeSettings) {
    if (routeSettings.name == '/') {
      return MaterialPageRoute(
        builder: (context) => appRoutes[Screens.initial]!(context),
        settings: RouteSettings(
          name: routeSettings.name,
          arguments: routeSettings.arguments,
        ),
      );
    } else {
      return MaterialPageRoute(
        builder: appRoutes[routeSettings.name]!,
        settings: routeSettings,
      );
    }
  }

  void subscribeHttpErrorMessages() {
    ///Global http errors listener
    httpErrorsSubscription = httpErrorsStream.listen((message) {
      if (message.isNotEmpty) {
        // TODO(anybody): implement reaction
        HttpErrors.clearError();
      }
    });
  }
}
